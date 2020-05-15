#include "sysinfo.h"

SysInfo::SysInfo(QObject *parent)
    : QObject(parent)
{
}

QString SysInfo::getArch()
{
    return SystemInfo->buildCpuArchitecture();
}
