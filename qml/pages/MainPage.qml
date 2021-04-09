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

import QtQuick 2.6
import Sailfish.Silica 1.0
import Process 1.0
import "../components"

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    property variant currentAmbience
    property string ambienceFile
    property int rotationAngle
    property bool lightAmbiencesAvailable: Theme.lightPrimaryColor !== undefined

    onOrientationChanged: {
        if(orientation === Orientation.Portrait)
            rotationAngle = 0
        else if(orientation === Orientation.LandscapeInverted)
            rotationAngle = 90
        else if(orientation === Orientation.PortraitInverted)
            rotationAngle = 180
        else if(orientation === Orientation.Landscape)
            rotationAngle = 270
    }

    // As the home screen image path changes with the ambience,
    // we can use it as an indicator when ambience changes.
    property string themeBackgroundImage: Theme._homeBackgroundImage
    onThemeBackgroundImageChanged: {
        ambienceInfoTimer.start()
    }

    Component.onCompleted: {
        ambienceInfoTimer.start()
    }

    Timer {
        id: ambienceInfoTimer
        interval: 100
        running: false
        repeat: false
        onTriggered: {
            ambienceInfoProcess.start("/usr/bin/dconf", ["read", "/desktop/jolla/theme/active_ambience"])
        }
    }

    Process {
        id: ambienceInfoProcess
        onFinished: {
            ambienceFile = readAll()
            ambienceFile = ambienceFile.replace(/'/g,"").replace("\n","")
            //console.log("Current ambience file: "+ambienceFile)
            ambienceFileTimer.start()
        }
    }

    Timer {
        id: ambienceFileTimer
        interval: 100
        running: false
        repeat: false
        onTriggered: {
            ambienceFileProcess.start("/bin/cat", [ambienceFile])
        }
    }

    Process {
        id: ambienceFileProcess
        onFinished: {
            var output = readAll()
            //console.log(output)
            currentAmbience = JSON.parse(output)
        }
    }

    Process {
        id: fontProcess
        function setSize(size) {
            start("/usr/bin/dconf", ["write","/desktop/jolla/theme/font/sizeCategory", size])
        }
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
            spacing: 0
            PageHeader {
                title: qsTr("Theme Tool")
            }

            //////////////////////////////////////////////////

            ExpandingSection {
                title: qsTr("Ambience info")

                content.sourceComponent: ExpandingColumn {

                    DetailItem {
                        label: qsTr("Display Name")
                        value: currentAmbience["displayName"]
                    }
                    DetailItem {
                        label: qsTr("Color Scheme")
                        value: currentAmbience["colorScheme"] === "darkonlight"
                               ? qsTr("Dark on light")
                               : qsTr("Light on dark")
                    }
                    DetailItem {
                        label: qsTr("Favorite")
                        value: currentAmbience["favorite"] ? qsTr("Yes") : qsTr("No")
                    }
                    DetailItem {
                        label: qsTr("Version")
                        value: currentAmbience["version"]
                    }
                    Item {
                        height: wallpaper.height
                        width: parent.width
                        rotation: rotationAngle
                        Image {
                            id: wallpaper
                            anchors.horizontalCenter: parent.horizontalCenter
                            asynchronous: true
                            source: themeBackgroundImage
                            width: Theme.coverSizeLarge.width
                            height: Theme.coverSizeLarge.height
                            fillMode: Image.PreserveAspectCrop
                        }
                    }
                }
            }

            //////////////////////////////////////////////////

            ExpandingSection {
                title: qsTr("Font Sizes")

                content.sourceComponent: ExpandingColumn {
                    SectionHeader {
                        text: qsTr("System font properties")
                    }
                    Label {
                        text: qsTr("Default Font") + ": " + Theme.fontFamily
                    }
                    Label {
                        text: qsTr("Heading Font") + ": " + Theme.fontFamilyHeading
                    }
                    Label {
                        text: qsTr("Pixel ratio") + ": " + Theme.pixelRatio
                    }

                    Item {
                        width: parent.width
                        height: button.height
                        Button {
                            id: button
                            width: Theme.buttonWidthExtraSmall
                            anchors.left: parent.left
                            text: qsTr("Normal")
                            onClicked: fontProcess.setSize("'normal'")
                        }
                        Button {
                            width: Theme.buttonWidthExtraSmall
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Large")
                            onClicked: fontProcess.setSize("'large'")
                        }
                        Button {
                            width: Theme.buttonWidthExtraSmall
                            anchors.right: parent.right
                            text: qsTr("Huge")
                            onClicked: fontProcess.setSize("'huge'")
                        }
                    }

                    SectionHeader {
                        text: qsTr("Sample texts")
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeTinyBase
                        sizeText: qsTr("Tiny Base")
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeTiny
                        sizeText: qsTr("Tiny")
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeExtraSmallBase
                        sizeText: qsTr("Extra Small Base")
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeExtraSmall
                        sizeText: qsTr("Extra Small")
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeSmallBase
                        sizeText: qsTr("Small Base")
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeSmall
                        sizeText: qsTr("Small")
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeMediumBase
                        sizeText: qsTr("Medium Base")
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeMedium
                        sizeText: qsTr("Medium")
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeLargeBase
                        sizeText: qsTr("Large Base")
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeLarge
                        sizeText: qsTr("Large")
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeExtraLargeBase
                        sizeText: qsTr("Extra Large Base")
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeExtraLarge
                        sizeText: qsTr("Extra Large")
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeHugeBase
                        sizeText: qsTr("Huge Base")
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeHuge
                        sizeText: qsTr("Huge")
                    }
                }
            }

            //////////////////////////////////////////////////

            ExpandingSection {
                title: qsTr("Icon Sizes")
                content.sourceComponent: ExpandingColumn {
                    ThemeIcon {
                        size: Theme.iconSizeExtraSmall
                        text: qsTr("Extra Small")
                    }
                    ThemeIcon {
                        size: Theme.iconSizeSmall
                        text: qsTr("Small")
                    }
                    ThemeIcon {
                        size: Theme.iconSizeMedium
                        text: qsTr("Medium")
                    }
                    ThemeIcon {
                        size: Theme.iconSizeLarge
                        text: qsTr("Large")
                    }
                    ThemeIcon {
                        size: Theme.iconSizeExtraLarge
                        text: qsTr("Extra Large")
                    }
                    ThemeIcon {
                        size: Theme.iconSizeLauncher
                        text: qsTr("Launcher")
                    }
                }
            }

            //////////////////////////////////////////////////

            ExpandingSection {
                title: qsTr("Padding sizes")
                content.sourceComponent: ExpandingColumn {
                    ThemeIcon {
                        size: Theme.paddingSmall
                        text: qsTr("Small")
                    }
                    ThemeIcon {
                        size: Theme.paddingMedium
                        text: qsTr("Medium")
                    }
                    ThemeIcon {
                        size: Theme.paddingLarge
                        text: qsTr("Large")
                    }
                }
            }

            //////////////////////////////////////////////////

            ExpandingSection {
                title: qsTr("Item sizes")
                content.sourceComponent: ExpandingColumn {
                    ThemeIcon {
                        size: Theme.itemSizeExtraSmall
                        text: qsTr("Extra Small")
                    }
                    ThemeIcon {
                        size: Theme.itemSizeSmall
                        text: qsTr("Small")
                    }
                    ThemeIcon {
                        size: Theme.itemSizeMedium
                        text: qsTr("Medium")
                    }
                    ThemeIcon {
                        size: Theme.itemSizeLarge
                        text: qsTr("Large")
                    }
                    ThemeIcon {
                        size: Theme.itemSizeExtraLarge
                        text: qsTr("Extra Large")
                    }
                    ThemeIcon {
                        size: Theme.itemSizeHuge
                        text: qsTr("Huge")
                    }
                }
            }

            //////////////////////////////////////////////////

            ExpandingSection {
                title: qsTr("Colors")
                content.sourceComponent: ExpandingColumn {
                    SectionHeader {
                        text: qsTr("Default Colors")
                    }
                    ThemeRect {
                        color: Theme.primaryColor
                        text: qsTr("Primary Color")
                    }
                    ThemeRect {
                        color: Theme.secondaryColor
                        text: qsTr("Secondary Color")
                    }
                    ThemeRect {
                        color: Theme.highlightColor
                        text: qsTr("Highlight Color")
                    }
                    ThemeRect {
                        color: Theme.highlightDimmerColor
                        text: qsTr("Highlight Dimmer Color")
                    }
                    ThemeRect {
                        color: Theme.highlightBackgroundColor
                        text: qsTr("Highlight Background Color")
                    }
                    ThemeRect {
                        color: Theme.secondaryHighlightColor
                        text: qsTr("Secondary Highlight Color")
                    }
                    ThemeRect {
                        color: Theme.overlayBackgroundColor
                        text: qsTr("Overlay Background Color")
                    }


                    SectionHeader {
                        visible: lightAmbiencesAvailable
                        text: qsTr("Dark Colors")
                    }
                    ThemeRect {
                        visible: lightAmbiencesAvailable
                        color: lightAmbiencesAvailable ? Theme.darkPrimaryColor : "transparent"
                        text: qsTr("Dark Primary Color")
                    }
                    ThemeRect {
                        visible: lightAmbiencesAvailable
                        color: lightAmbiencesAvailable ? Theme.darkSecondaryColor : "transparent"
                        text: qsTr("Dark Secondary Color")
                    }

                    SectionHeader {
                        visible: lightAmbiencesAvailable
                        text: qsTr("Light Colors")
                    }
                    ThemeRect {
                        visible: lightAmbiencesAvailable
                        color: lightAmbiencesAvailable ? Theme.lightPrimaryColor : "transparent"
                        text: qsTr("Light Primary Color")
                    }
                    ThemeRect {
                        visible: lightAmbiencesAvailable
                        color: lightAmbiencesAvailable ? Theme.lightSecondaryColor : "transparent"
                        text: qsTr("Light Secondary Color")
                    }

                    SectionHeader {
                        text: qsTr("Presence Mode Colors")
                    }
                    ThemeRect {
                        color: Theme.presenceColor(Theme.PresenceAvailable)
                        text: qsTr("Available Color")
                    }
                    ThemeRect {
                        color: Theme.presenceColor(Theme.PresenceAway)
                        text: qsTr("Away Color")
                    }
                    ThemeRect {
                        color: Theme.presenceColor(Theme.PresenceBusy)
                        text: qsTr("Busy Color")
                    }
                    ThemeRect {
                        color: Theme.presenceColor(Theme.PresenceOffline)
                        text: qsTr("Offline Color")
                    }

                    SectionHeader {
                        visible: lightAmbiencesAvailable
                        text: qsTr("Other Colors")
                    }

                    ThemeRect {
                        visible: lightAmbiencesAvailable
                        color: lightAmbiencesAvailable ? Theme.errorColor : "transparent"
                        text: qsTr("Error Color")
                    }
                }
            }

            //////////////////////////////////////////////////

            ExpandingSection {
                title: qsTr("Button Sizes")
                content.sourceComponent: ExpandingColumn {
                    Button {
                        width: Theme.buttonWidthExtraSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("XSmall", "Must fit in the button.")
                    }
                    Button {
                        width: Theme.buttonWidthSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Small")
                    }
                    Button {
                        width: Theme.buttonWidthMedium
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Medium")
                    }
                    Button {
                        width: Theme.buttonWidthLarge
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: qsTr("Large")
                    }
                }
            }
            //////////////////////////////////////////////////

            ExpandingSection {
                title: qsTr("Cover Sizes")
                content.sourceComponent: ExpandingColumn {
                    CoverRect {
                        rotation: rotationAngle
                        size: Theme.coverSizeSmall
                        text: qsTr("Small")
                    }
                    CoverRect {
                        rotation: rotationAngle
                        size: Theme.coverSizeLarge
                        text: qsTr("Large")
                    }
                }
            }
        }
    }
}
