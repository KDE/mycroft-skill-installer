/*
 *   SPDX-FileCopyrightText: 2019-2020 Aditya Mehra <aix.m@outlook.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later OR LicenseRef-KDE-Accepted-GPL
 */

#include "processcommander.h"
#include <QDebug>
#include <QTextCodec>
#include <QEventLoop>

ProcessCommand::ProcessCommand(QObject *parent)
    : QObject(parent),
      ExecRemoteCmd(new QProcess(this)),
      ExecLocalCmd(new QProcess(this))
{
    connect(&ExecRemoteCmd, SIGNAL(readyReadStandardOutput()), this, SLOT(readFromStdOutRemote()));
    connect(&ExecLocalCmd, SIGNAL(readyReadStandardOutput()), this, SLOT(readFromStdOutLocal()));
}

void ProcessCommand::processRemoteGit(const QString url, const QString branch)
{
    QString args_url = "grep";
    ExecRemoteCmd.start("git", {"ls-remote", url, "|", args_url, branch, "|", "cut", "-f", "1"});
    //qDebug() << url << branch;
}

void ProcessCommand::processLocalGit(const QString skillpath)
{
    QString args_url = skillpath + "/";
    ExecLocalCmd.setWorkingDirectory(args_url);
    ExecLocalCmd.start("git", {"rev-parse", "HEAD"});
}

void ProcessCommand::readFromStdOutRemote()
{
    QByteArray result = ExecRemoteCmd.readAllStandardOutput();
    QVariant output = result;
    if(output.toString().contains("\t")){
        QStringList qoutput = output.toString().split("\t");
        //       qDebug() << "remote" << qoutput[0];
        m_commitIdRemote = qoutput[0];
        if(m_commitIdRemote != ""){
            emit processCommandResultCompleted();
        }
    } else {
        emit processCommandResultCompleted();
    }
}

void ProcessCommand::readFromStdOutLocal()
{
    QByteArray result = ExecLocalCmd.readAllStandardOutput();
    QVariant output = result;
    if(output.toString().contains("\n")){
        QStringList qoutput = output.toString().split("\n");
        m_commitIdLocal = qoutput[0];
        //qDebug() << "local" << qoutput[0];
    } else {
        emit processCommandResultCompleted();
    }
}

QString ProcessCommand::getRemoteCommitId()
{
    return m_commitIdRemote;
}

QString ProcessCommand::getLocalCommitId()
{
    return m_commitIdLocal;
}

ProcessCommander::ProcessCommander(QObject *parent) : QObject(parent)
{
    m_processCommand.moveToThread(&mThread);
    connect(this, &ProcessCommander::processRemoteGit, &m_processCommand, &ProcessCommand::processRemoteGit);
    connect(this, &ProcessCommander::processLocalGit, &m_processCommand, &ProcessCommand::processLocalGit);

    mThread.start();
}

bool ProcessCommander::runUpdateCheck(const QString url, const QString branch, const QString skillpath)
{
    QEventLoop loop;
    loop.connect(&m_processCommand, SIGNAL(processCommandResultCompleted()), SLOT(quit()));
    emit processRemoteGit(url, branch);
    emit processLocalGit(skillpath);
    loop.exec();
    QString remoteId = m_processCommand.getRemoteCommitId();
    QString localId = m_processCommand.getLocalCommitId();
    bool result = compareCommits(remoteId, localId);
    //qDebug() << "Returning Result For " << url << result;
    return result;
}

bool ProcessCommander::compareCommits(const QString remoteId, const QString localId)
{
    if(remoteId == localId){
        return false;
    } else if(remoteId != "" && localId != "") {
        return true;
    } else {
        return false;
    }
}

ProcessCommander::~ProcessCommander()
{
    mThread.exit();
    mThread.wait();
}
