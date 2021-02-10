/*
 *   SPDX-FileCopyrightText: 2019-2020 Aditya Mehra <aix.m@outlook.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later OR LicenseRef-KDE-Accepted-GPL
 */

#include "filereader.h"
#include <QFile>

FileReader::FileReader(QObject *parent) 
    : QObject(parent)
{
}

QByteArray FileReader::read(const QString &filename)
{
    QFile file(filename);
    if (!file.open(QIODevice::ReadOnly))
        return QByteArray();

    return file.readAll();
}

bool FileReader::file_exists_local(const QString &filename) {
    return QFile(filename).exists();
}
