QT += qml quick quickcontrols2 widgets
TARGET = MycroftSkillInstaller

DESTDIR = $$OUT_PWD/../

SOURCES += main.cpp \
    scriptlauncher.cpp

RESOURCES += qml/resources.qrc

HEADERS += \
    scriptlauncher.h


target.path += /usr/bin/
INSTALLS += target

