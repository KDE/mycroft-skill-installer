/*
 *   SPDX-FileCopyrightText: 2019-2020 Aditya Mehra <aix.m@outlook.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later OR LicenseRef-KDE-Accepted-GPL
 */

#ifndef PROCESSCOMMANDER_H
#define PROCESSCOMMANDER_H

#include <QObject>
#include <QProcess>
#include <QThread>

class ProcessCommand : public QObject
{
    Q_OBJECT
public:
    explicit ProcessCommand(QObject *parent=nullptr);

public slots:
    void processRemoteGit(const QString url, const QString branch);
    void processLocalGit(const QString skillpath);
    void readFromStdOutRemote();
    void readFromStdOutLocal();
    QString getRemoteCommitId();
    QString getLocalCommitId();

signals:
    void processedCommandRemoteChanged(const QString &result);
    void processedCommandLocalChanged(const QString &result);
    void processCommandResultCompleted();

private:
    QProcess ExecRemoteCmd;
    QProcess ExecLocalCmd;

    QString m_commitIdRemote;
    QString m_commitIdLocal;
};

class ProcessCommander : public QObject
{
    Q_OBJECT

public:
    explicit ProcessCommander(QObject *parent = nullptr);
    ~ProcessCommander();
    bool runUpdateCheck(const QString url, const QString branch, const QString skillpath);
    bool compareCommits(const QString remoteId, const QString localId);

signals:
    void processRemoteGit(const QString url, const QString branch);
    void processLocalGit(const QString skillpath);

    void processResult(const bool result);
    void processResultCompleted();

private:
    QThread mThread;
    ProcessCommand m_processCommand;
};

#endif // PROCESSCOMMANDER_H
