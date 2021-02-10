/*
 *   SPDX-FileCopyrightText: 2019-2020 Aditya Mehra <aix.m@outlook.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later OR LicenseRef-KDE-Accepted-GPL
 */

#ifndef SYSINFO_H
#define SYSINFO_H

#include <QObject>
#include <QSysInfo>

class SysInfo : public QObject
{
    Q_OBJECT

public:
    explicit SysInfo(QObject *parent = Q_NULLPTR);

public Q_SLOTS:
    QString getArch();

private:
    QSysInfo* SystemInfo;
};

#endif // SYSINFO_H
