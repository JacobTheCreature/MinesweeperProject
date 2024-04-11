#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "minesweepercell.h"
#include "difficultyselect.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<minesweepercell>("Minesweeper", 1, 0, "Minesweepercell");
    qmlRegisterType<difficultySelect>("difficultySelect", 1, 0, "DifficultySelect");

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/ihopethisworks/Main.qml"_qs);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
