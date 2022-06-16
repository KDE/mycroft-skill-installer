#include "globalconfiguration.h"
#include <KConfigGroup>
#include <KSharedConfig>

GlobalConfiguration::GlobalConfiguration(QObject *parent) 
    : QObject(parent)
{
}

QString GlobalConfiguration::backendConfig()
{
    static KSharedConfigPtr config = KSharedConfig::openConfig(QLatin1String("msibackendrc"));
    static KConfigGroup grp(config, QLatin1String("Backend"));
    if (grp.isValid()) {
        return grp.readEntry(QLatin1String("selectedBackend"), QStringLiteral("msm"));
    } else {
        return QStringLiteral("msm");
    }
}

bool GlobalConfiguration::backendConfigXDGSupported()
{
    static KSharedConfigPtr config = KSharedConfig::openConfig(QLatin1String("msibackendrc"));
    static KConfigGroup grp(config, QLatin1String("Backend"));
    if (grp.isValid()) {
        return grp.readEntry(QLatin1String("xdgSupported"), false);
    } else {
        return false;
    }
}

void GlobalConfiguration::setBackendConfig(const QString &backendConfig)
{
    static KSharedConfigPtr config = KSharedConfig::openConfig(QLatin1String("msibackendrc"));
    static KConfigGroup grp(config, QLatin1String("Backend"));
    if (grp.isValid()) {
        grp.writeEntry(QLatin1String("selectedBackend"), backendConfig);
        config->sync();
    }
    emit backendConfigChanged();
}

void GlobalConfiguration::setBackendConfigXDGSupported(bool backendConfigXDGSupported)
{
    static KSharedConfigPtr config = KSharedConfig::openConfig(QLatin1String("msibackendrc"));
    static KConfigGroup grp(config, QLatin1String("Backend"));
    if (grp.isValid()) {
        grp.writeEntry(QLatin1String("xdgSupported"), backendConfigXDGSupported);
        config->sync();
    }
    emit backendConfigXDGSupportedChanged();
}

QString GlobalConfiguration::getSystemUser()
{
    QProcessEnvironment env = QProcessEnvironment::systemEnvironment();
    QString user = env.value(QLatin1String("USER"));
    if (user.isEmpty()) {
        user = env.value(QLatin1String("USERNAME"));
    }
    return user;
}