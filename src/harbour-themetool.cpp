/*
Theme Tool - Simple tool to view Sailfish OS ambience and GUI elements.
Copyright (C) 2019 Matti Viljanen

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/

#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>

#include <QGuiApplication>
#include <QQuickView>
#include <QtQml>
#include "src/process.h"

int main(int argc, char *argv[])
{
    // SailfishApp::main() will display "qml/harbour-[name].qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //   - SailfishApp::pathToMainQml() to get a QUrl to the main QML file
    //
    // To display the view, call "show()" (will show fullscreen on device).

    QGuiApplication* app = SailfishApp::application(argc, argv);
    app->setApplicationVersion(QString(APP_VERSION));

    QQuickView* view = SailfishApp::createView();

    qmlRegisterType<Process>("Process", 1, 0, "Process");
    view->rootContext()->setContextProperty("app_version", APP_VERSION);
    view->setSource(SailfishApp::pathTo(APP_QML));

    view->showFullScreen();

    return app->exec();
}
