#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWidgets/QApplication>
#include <QQuickStyle>
#include <QIcon>
#include <QStringList>
#include "filereader.h"
#include "sysinfo.h"

static QObject *sysinfo_singleton(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return new SysInfo;
}

int main(int argc, char *argv[])
{
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);
    app.setWindowIcon(QIcon("qrc:mycroft-plasma-appicon.png"));
    qmlRegisterType<FileReader>("FileReader", 1, 0, "FileReader");
    qmlRegisterSingletonType<SysInfo>("SysInfo", 1, 0, "SysInfo", sysinfo_singleton);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("qrc:/qml/main.qml")));
    app.processEvents();
    return app.exec();
}
