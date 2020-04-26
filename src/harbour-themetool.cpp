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

    const char* logEnvVar = "QT_LOGGING_RULES";
    for(int i = 1; i < argc; i++) {
        if(!strcmp(argv[i],"-v")) {
            printf("%s %s\n", APP_NAME, APP_VERSION);
            return 0;
        }
        else if(!strcmp(argv[i],"--verbose"))
            qputenv(logEnvVar, "*.info=true;*.debug=false");
        else if(!strcmp(argv[i],"--debug"))
            qputenv(logEnvVar, "*.info=true");
        else if(!strcmp(argv[i],"--help")) {
            printf("%s %s\n", APP_NAME, APP_VERSION);
            printf("Usage:\n");
            printf("  --verbose     Enable informational messages\n");
            printf("  --debug       Enable informational and debugging messages\n");
            printf("  --help        Print version string and exit\n");
            return 0;
        }
    }
    if(!qEnvironmentVariableIsSet(logEnvVar))
        qputenv(logEnvVar, "*.info=false;*.debug=false");

    QGuiApplication* app = SailfishApp::application(argc, argv);
    app->setApplicationVersion(QString(APP_VERSION));

    QQuickView* view = SailfishApp::createView();

    qmlRegisterType<Process>("Process", 1, 0, "Process");
    view->rootContext()->setContextProperty("app_version", APP_VERSION);
    view->setSource(SailfishApp::pathTo(APP_QML));

    view->showFullScreen();

    return app->exec();
}
