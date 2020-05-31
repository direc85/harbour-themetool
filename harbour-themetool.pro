# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-themetool

CONFIG += console sailfishapp sailfishapp_i18n

VER = 0.5
REL = 1

VERSION = $${VER}-$${REL}
$$system(bash update-spec-version.sh $$TARGET $$VER $$REL)
DEFINES += APP_VERSION=\"\\\"$$VERSION\\\"\"
DEFINES += APP_NAME=\"\\\"$$TARGET\\\"\"
DEFINES += APP_QML=\"\\\"qml/$${TARGET}.qml\\\"\"

# Do not define QT_NO_DEBUG_OUTPUT!
# Use "--verbose" and "--debug" at runtime instead.
# See main() for details.
#DEFINES += QT_NO_DEBUG_OUTPUT

HEADERS += src/process.h

SOURCES += src/harbour-themetool.cpp

DISTFILES += qml/harbour-themetool.qml \
    qml/components/AboutLabel.qml \
    qml/components/CoverRect.qml \
    qml/components/ExpandingColumn.qml \
    qml/components/GPLv2Label.qml \
    qml/components/ThemeIcon.qml \
    qml/components/ThemeLabel.qml \
    qml/components/ThemeRect.qml \
    qml/cover/CoverPage.qml \
    qml/pages/AboutPage.qml \
    qml/pages/MainPage.qml \
    rpm/harbour-themetool.changes.in \
    rpm/harbour-themetool.changes.run.in \
    rpm/harbour-themetool.spec \
    rpm/harbour-themetool.yaml \
    harbour-themetool.desktop \
    translations/harbour-themetool-sv.ts \
    translations/harbour-themetool-fi.ts \
    translations/harbour-themetool-zh_CN.ts \
    translations/harbour-themetool-hr.ts

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

TRANSLATIONS += \
    translations/harbour-themetool-sv.ts \
    translations/harbour-themetool-fi.ts \
    translations/harbour-themetool-zh_CN.ts \
    translations/harbour-themetool-hr.ts

images.files = images
images.path = /usr/share/$${TARGET}

INSTALLS += images
