/*
 *   SPDX-FileCopyrightText: 2019-2020 Aditya Mehra <aix.m@outlook.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later OR LicenseRef-KDE-Accepted-GPL
 */

#ifndef INSTALLERLISTMODEL_H
#define INSTALLERLISTMODEL_H

#include <QAbstractListModel>
#include <QJsonArray>
#include "filereader.h"
#include "processcommander.h"
#include "globalconfiguration.h"

class InstallerListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString url READ url WRITE setUrl)
    Q_PROPERTY(QString json READ json WRITE setJson)
    Q_PROPERTY(QString query READ query WRITE setQuery)
    Q_PROPERTY(QStringList roles READ roles WRITE setRoles)

public:
    explicit InstallerListModel(QObject *parent = 0);
    int rowCount(const QModelIndex &parent) const override;
    QHash<int, QByteArray> roleNames() const override;
    QVariant data(const QModelIndex &index, int role) const override;

    QString url() const;
    void setUrl(const QString &url);
    QString json() const;
    void setJson(const QString &json);
    QString query() const;
    void setQuery(const QString &query);
    QStringList roles() const;
    void setRoles(const QStringList &roles);

    void getSecondaryJson(const QByteArray &data, const QString &url);
    void buildJSONModel(const QJsonObject json_one, const QJsonDocument json_two);

    void setReloadModel();

public Q_SLOTS:
    QVariantMap get(int row);
    bool checkInstalled(const QString skillname, const QString skillauthor);
    bool checkUpdatesAvailable(const QString url, const QString branch, const QString skillpath);
    void reloadJsonModel();

    bool downloadingModel();
    void setDownloadingModel(bool downloadingModel);

    bool creatingModel();
    void setCreatingModel(bool creatingModel);

    int completeModelCounter();
    int updatingModelCounter();

    void setCategoryBrowser(int category);
    QString getCurrentCategory();

    void fetchLatestForCurrentModel();

Q_SIGNALS:
    void downloadingModelUpdated();
    void creatingModelUpdated();
    void modelUpdated();

private:
    QString m_url;
    QString m_json;
    QString m_query;
    QStringList m_roles;
    QList<QHash<int, QVariant>> m_jsonList;

    QJsonArray m_combinedDoc;
    FileReader m_fileReader;
    int m_originalCount;
    QList<QString> m_blackList;

    bool m_downloadingModel;
    bool m_creatingModel;

    bool m_reloadingModel;

    int m_updatingCount;

    QString m_categoryUrl;
    QString m_cacheDataPath;
    QString m_cacheDataFile;
    int m_nonCacheCount;

    GlobalConfiguration *m_globalConfiguration;
    QString m_selectedBackendType;
    QString m_selectedBackendXdgSupport;
};

#endif

