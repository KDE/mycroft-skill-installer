/*
 *   SPDX-FileCopyrightText: 2019-2020 Aditya Mehra <aix.m@outlook.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later OR LicenseRef-KDE-Accepted-GPL
 */

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QEventLoop>
#include "installerlistmodel.h"
#include "processcommander.h"

InstallerListModel::InstallerListModel(QObject *parent) : QAbstractListModel(parent)
{
    m_blackList.append("1490534");
    m_blackList.append("1193621");
}

void InstallerListModel::reloadJsonModel()
{
    m_jsonList.clear();
    while(m_combinedDoc.count()) {
        m_combinedDoc.pop_back();
    }
    if(!m_reloadingModel){
        setReloadModel();
    }
}

void InstallerListModel::setReloadModel()
{
    m_reloadingModel = true;
    setUrl(m_url);
}

QString InstallerListModel::json() const
{
    return m_json;
}

QString InstallerListModel::url() const
{
    return m_url;
}

void InstallerListModel::setUrl(const QString &url)
{
    m_jsonList.clear();
    while(m_combinedDoc.count()) {
        m_combinedDoc.pop_back();
    }
    setDownloadingModel(true);
    m_originalCount = 0;
    QNetworkAccessManager *manager = new QNetworkAccessManager(this);
    QNetworkRequest request;
    const QUrl qurl = url;
    m_url = url;
    request.setUrl(qurl);
    QNetworkReply *reply = manager->get(request);
    connect(reply, &QNetworkReply::finished, [this, reply] () {
        QByteArray response_data = reply->readAll();
        getSecondaryJson(response_data);
        reply->close();
    });
}

void InstallerListModel::getSecondaryJson(const QByteArray &data)
{
    QNetworkAccessManager *manager = new QNetworkAccessManager(this);
    QNetworkRequest request;
    QJsonDocument json = QJsonDocument::fromJson(data);
    QJsonObject r = json.object();
    QJsonArray storeItems = r.value("data").toArray();
    qDebug() << "Store Items Count Before Invalid" << storeItems.count();
    for(int s = 0; s < storeItems.count(); s++) {
        QJsonObject storeItem = storeItems[s].toObject();
        QString id = storeItem["id"].toString();
        QString download_name = storeItem["downloadname1"].toString();
        if(download_name != "skill.json"){
            storeItems.removeAt(s);
        }
        if(m_blackList.contains(id)){
            storeItems.removeAt(s);
        }
    }
    qDebug() << "Store Items Count After Invalid" << storeItems.count();

    m_originalCount = storeItems.count();
    for(int i = 0; i < storeItems.count(); i++) {
        QJsonObject storeItem = storeItems[i].toObject();
        QString download_url = storeItem["downloadlink1"].toString();
        QString json_response;
        request.setUrl(download_url);
        QNetworkReply *reply = manager->get(request);
        connect(reply, &QNetworkReply::finished, [this, reply, storeItem] () {
            QByteArray response_data = reply->readAll();
            QJsonDocument json_second = QJsonDocument::fromJson(response_data);
            buildJSONModel(storeItem, json_second);
            reply->close();
        });
    }
    setDownloadingModel(false);
    m_reloadingModel = false;
}

void InstallerListModel::buildJSONModel(const QJsonObject json_one, const QJsonDocument json_two)
{
    setCreatingModel(true);
    QJsonObject json_obj_one = json_two.object();
    QJsonObject json_obj_tow = json_one;

    QString skillName = json_obj_one["skillname"].toString().toLower();
    QString skillAuthor = json_obj_one["authorname"].toString().toLower();
    QString skillBranch = json_obj_one["branch"].toString();
    QString skillUrl = json_obj_one["url"].toString() + ".git";

    bool skillInstallCheck = checkInstalled(skillName, skillAuthor);
    json_obj_one.insert("itemInstallStatus", skillInstallCheck);

    QString defaultFolder = "/opt/mycroft/skills";
    QString skillPath = defaultFolder + "/" + skillName + "." + skillAuthor;

    QList<QString> badPaths = {"/opt/mycroft/skills/.", "/opt/mycroft/skills/ . ", "/opt/mycroft/skills/ .", "/opt/mycroft/skills/ ./", "/opt/mycroft/skills/. /"};

    if(skillInstallCheck && !badPaths.contains(skillPath)) {
        bool skillUpdateAvailable = checkUpdatesAvailable(skillUrl, skillBranch, skillPath);
        json_obj_one.insert("itemUpdateStatus", skillUpdateAvailable);
    } else {
        json_obj_one.insert("itemUpdateStatus", false);
    }

    QVariantMap map = json_obj_one.toVariantMap();
    map.insert(json_obj_tow.toVariantMap());

    QJsonObject cmdJson = QJsonObject::fromVariantMap(map);
    m_combinedDoc.append(cmdJson);

    qDebug() << "Combining Json For " << skillName <<  m_combinedDoc.count();
    m_updatingCount = m_combinedDoc.count();

    if(m_combinedDoc.count() == m_originalCount){
        QJsonObject recordObject;
        recordObject.insert("data", m_combinedDoc);

        QJsonDocument doc(recordObject);

        setJson(doc.toJson());
    }
    setCreatingModel(false);
}

void InstallerListModel::setJson(const QString &json)
{
    qDebug() << "Got new json file";
    m_json = json;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(m_json.toUtf8());
    QJsonObject jsonObj = jsonDoc.object();
    QJsonArray jsonArray = jsonObj[m_query].toArray();
    foreach (const QJsonValue & value, jsonArray) {
        QJsonObject obj = value.toObject();
        QHash<int, QVariant> jsonData;
        beginInsertRows(QModelIndex(), m_jsonList.size(), m_jsonList.size());
        for ( int i = 0; i < m_roles.size(); i++ ) {
            jsonData.insert(i, obj[m_roles[i]].toVariant());
        }
        m_jsonList.append(jsonData);
        endInsertRows();
    }
    emit modelUpdated();
}

bool InstallerListModel::checkInstalled(const QString skillname, const QString skillauthor)
{
    QString defaultFolder = "/opt/mycroft/skills";
    QString skillPath = defaultFolder + "/" + skillname + "." + skillauthor;
    bool checkinstall = m_fileReader.file_exists_local(skillPath);
    return checkinstall;
}

bool InstallerListModel::checkUpdatesAvailable(const QString url, const QString branch, const QString skillpath)
{
    ProcessCommander *m_proc = new ProcessCommander;
    bool updateAvailable = m_proc->runUpdateCheck(url, branch, skillpath);
    return updateAvailable;
}

QString InstallerListModel::query() const
{
    return m_query;
}

void InstallerListModel::setQuery(const QString &query)
{
    m_query = query;
}

QStringList InstallerListModel::roles() const
{
    return m_roles;
}

void InstallerListModel::setRoles(const QStringList &roles)
{
    m_roles = roles;
}

int InstallerListModel::rowCount(const QModelIndex &) const
{
    return m_jsonList.size();
}

QHash<int, QByteArray> InstallerListModel::roleNames() const
{
    QHash<int, QByteArray> ret;
    for ( int i = 0; i < m_roles.size(); i++ ) {
        ret.insert(i, m_roles[i].toUtf8());
    }
    return ret;
}

QVariant InstallerListModel::data(const QModelIndex &index, int role) const
{
    return m_jsonList[index.row()][role];
}

QVariantMap InstallerListModel::get(int row)
{
    QHash<int,QByteArray> names = roleNames();
    QHashIterator<int, QByteArray> i(names);
    QVariantMap res;
    QModelIndex idx = index(row, 0);
    while (i.hasNext()) {
        i.next();
        QVariant data = idx.data(i.key());
        res[i.value()] = data;
    }
    return res;
}

bool InstallerListModel::downloadingModel()
{
    return m_downloadingModel;
}

void InstallerListModel::setDownloadingModel(bool downloadingModel)
{
    m_downloadingModel = downloadingModel;
    emit downloadingModelUpdated();
}

bool InstallerListModel::creatingModel()
{
    return m_creatingModel;
}

void InstallerListModel::setCreatingModel(bool creatingModel)
{
    m_creatingModel = creatingModel;
    emit creatingModelUpdated();
}

int InstallerListModel::completeModelCounter()
{
    return m_originalCount;
}

int InstallerListModel::updatingModelCounter()
{
    return m_updatingCount;
}
