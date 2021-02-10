/*
 *   SPDX-FileCopyrightText: 2019-2020 Aditya Mehra <aix.m@outlook.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later OR LicenseRef-KDE-Accepted-GPL
 */

#ifndef FILEREADER_H
#define FILEREADER_H

#include <QObject>
#include <QStringList>

class FileReader : public QObject
{
    Q_OBJECT

public:
    explicit FileReader(QObject *parent = Q_NULLPTR);
    
public Q_SLOTS:
    QByteArray read(const QString &filename);
    bool file_exists_local(const QString &filename);
};

#endif // FILEREADER_H
