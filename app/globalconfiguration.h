/*
 *   SPDX-FileCopyrightText: 2019-2020 Aditya Mehra <aix.m@outlook.com>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later OR LicenseRef-KDE-Accepted-GPL
 */

#ifndef GLOBALCONFIGURATION_H
#define GLOBALCONFIGURATION_H

#include <QObject>
#include <QProcessEnvironment>

class GlobalConfiguration : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString backendConfig READ backendConfig WRITE setBackendConfig NOTIFY backendConfigChanged)
    Q_PROPERTY(bool backendConfigXDGSupported READ backendConfigXDGSupported WRITE setBackendConfigXDGSupported NOTIFY backendConfigXDGSupportedChanged)

public:
    explicit GlobalConfiguration(QObject *parent = nullptr);
    
    QString backendConfig();
    bool backendConfigXDGSupported();

public Q_SLOTS:
    void setBackendConfig(const QString &backendConfig);
    void setBackendConfigXDGSupported(bool backendConfigXDGSupported);
    QString getSystemUser();

Q_SIGNALS:
    void backendConfigChanged();
    void backendConfigXDGSupportedChanged();
};

#endif // GLOBALCONFIGURATION_H