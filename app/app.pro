QT += qml quick quickcontrols2 widgets
TARGET = MycroftSkillInstaller

DESTDIR = $$OUT_PWD/../

SOURCES += main.cpp \
    scriptlauncher.cpp

RESOURCES += qml/resources.qrc

HEADERS += \
    scriptlauncher.h


target.path += /usr/bin/
desktop.path += /usr/share/applications/
desktop.files += net.bs.mycroft.installer.desktop

INSTALLS += target desktop

