#ifndef PROCESS_H
#define PROCESS_H

// Source: http://www.xargs.com/qml/process.html
// Copyright © 2015 John Temples

#include <QProcess>

class Process : public QProcess {
    Q_OBJECT

public:
    Process(QObject *parent = nullptr) : QProcess(parent) { }

    Q_INVOKABLE void start(const QString &program, const QStringList &arguments) {
        QProcess::start(program, arguments);
        QProcess::waitForStarted(1000);
        QProcess::waitForFinished(1000);
    }

    Q_INVOKABLE QByteArray readAll() {
        return QProcess::readAll();
    }

    Q_INVOKABLE int errorCode() {
        return QProcess::exitCode();
    }
};

#endif // PROCESS_H
