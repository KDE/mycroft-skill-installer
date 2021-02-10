/*
 *   SPDX-FileCopyrightText: 2019-2020 Aditya Mehra <aix.m@outlook.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later OR LicenseRef-KDE-Accepted-GPL
 */

#include "sysinfo.h"

SysInfo::SysInfo(QObject *parent)
    : QObject(parent)
{
}

QString SysInfo::getArch()
{
    return SystemInfo->buildCpuArchitecture();
}
