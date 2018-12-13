#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWidgets/QApplication>
#include <QQuickStyle>
#include <QIcon>
#include <QStringList>
#include "filereader.h"

int main(int argc, char *argv[])
{
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);
    app.setWindowIcon(QIcon("qrc:mycroft-plasma-appicon.png"));
    qmlRegisterType<FileReader>("FileReader", 1, 0, "FileReader");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("qrc:/qml/main.qml")));
    app.processEvents();
    return app.exec();
}
