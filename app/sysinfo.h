/*
 *   Copyright (C) 2020 by Aditya Mehra <aix.m@outlook.com>                      *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
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

#endif // FILEREADER_H
