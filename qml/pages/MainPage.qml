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
    property string themeBackgroundImage: Theme.backgroundImage
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
                        label: qsTr("Favorite")
                        value: currentAmbience["favorite"] ? qsTr("Yes") : qsTr("No")
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
                        text: qsTr("System font size")
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
                        font.pixelSize: Theme.fontSizeTiny
                        text: qsTr("Tiny")+" ("+Theme.fontSizeTiny+"px)"
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeExtraSmall
                        text: qsTr("Extra Small")+" ("+Theme.fontSizeExtraSmall+"px)"
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeSmall
                        text: qsTr("Small")+" ("+Theme.fontSizeSmall+"px)"
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeMedium
                        text: qsTr("Medium")+" ("+Theme.fontSizeMedium+"px)"
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeLarge
                        text: qsTr("Large")+" ("+Theme.fontSizeLarge+"px)"
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeExtraLarge
                        text: qsTr("Extra Large")+" ("+Theme.fontSizeExtraLarge+"px)"
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeHuge
                        text: qsTr("Huge")+" ("+Theme.fontSizeHuge+"px)"
                    }
                }
            }

            //////////////////////////////////////////////////

            ExpandingSection {
                title: qsTr("Icon Sizes")
                content.sourceComponent: ExpandingColumn {
                    ThemeIcon {
                        size: Theme.iconSizeExtraSmall
                        text: qsTr("Extra Small")+" ("+Theme.iconSizeExtraSmall+"px)"
                    }
                    ThemeIcon {
                        size: Theme.iconSizeSmall
                        text: qsTr("Small")+" ("+Theme.iconSizeSmall+"px)"
                    }
                    ThemeIcon {
                        size: Theme.iconSizeMedium
                        text: qsTr("Medium")+" ("+Theme.iconSizeMedium+"px)"
                    }
                    ThemeIcon {
                        size: Theme.iconSizeLarge
                        text: qsTr("Large")+" ("+Theme.iconSizeLarge+"px)"
                    }
                    ThemeIcon {
                        size: Theme.iconSizeExtraLarge
                        text: qsTr("Extra Large")+" ("+Theme.iconSizeExtraLarge+"px)"
                    }
                    ThemeIcon {
                        size: Theme.iconSizeLauncher
                        text: qsTr("Launcher")+" ("+Theme.iconSizeLauncher+"px)"
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
                        text: qsTr("Primary Color")+" ("+Theme.primaryColor+")"
                    }
                    ThemeRect {
                        color: Theme.secondaryColor
                        text: qsTr("Secondary Color")+" ("+Theme.secondaryColor+")"
                    }
                    ThemeRect {
                        color: Theme.highlightColor
                        text: qsTr("Highlight Color")+" ("+Theme.highlightColor+")"
                    }
                    ThemeRect {
                        color: Theme.highlightDimmerColor
                        text: qsTr("Highlight Dimmer Color")+" ("+Theme.highlightDimmerColor+")"
                    }
                    ThemeRect {
                        color: Theme.highlightBackgroundColor
                        text: qsTr("Highlight Background Color")+" ("+Theme.highlightBackgroundColor+")"
                    }
                    ThemeRect {
                        color: Theme.secondaryHighlightColor
                        text: qsTr("Secondary Highlight Color")+" ("+Theme.secondaryHighlightColor+")"
                    }
                    ThemeRect {
                        color: Theme.overlayBackgroundColor
                        text: qsTr("Overlay Background Color")+" ("+Theme.overlayBackgroundColor+")"
                    }


                    SectionHeader {
                        visible: lightAmbiencesAvailable
                        text: qsTr("Dark Colors")
                    }
                    ThemeRect {
                        visible: lightAmbiencesAvailable
                        color: lightAmbiencesAvailable ? Theme.darkPrimaryColor : "transparent"
                        text: qsTr("Dark Primary Color")+" ("+Theme.darkPrimaryColor+")"
                    }
                    ThemeRect {
                        visible: lightAmbiencesAvailable
                        color: lightAmbiencesAvailable ? Theme.darkSecondaryColor : "transparent"
                        text: qsTr("Dark Secondary Color")+" ("+Theme.darkSecondaryColor+")"
                    }

                    SectionHeader {
                        visible: lightAmbiencesAvailable
                        text: qsTr("Light Colors")
                    }
                    ThemeRect {
                        visible: lightAmbiencesAvailable
                        color: lightAmbiencesAvailable ? Theme.lightPrimaryColor : "transparent"
                        text: qsTr("Light Primary Color")+" ("+Theme.lightPrimaryColor+")"
                    }
                    ThemeRect {
                        visible: lightAmbiencesAvailable
                        color: lightAmbiencesAvailable ? Theme.lightSecondaryColor : "transparent"
                        text: qsTr("Light Secondary Color")+" ("+Theme.lightSecondaryColor+")"
                    }

                    SectionHeader {
                        text: qsTr("Presence Mode Colors")
                    }
                    ThemeRect {
                        color: Theme.presenceColor(Theme.PresenceAvailable)
                        text: qsTr("Available Color")+" ("+Theme.presenceColor(Theme.PresenceAvailable)+")"
                    }
                    ThemeRect {
                        color: Theme.presenceColor(Theme.PresenceAway)
                        text: qsTr("Away Color")+" ("+Theme.presenceColor(Theme.PresenceAAway)+")"
                    }
                    ThemeRect {
                        color: Theme.presenceColor(Theme.PresenceBusy)
                        text: qsTr("Busy Color")+" ("+Theme.presenceColor(Theme.PresenceBusy)+")"
                    }
                    ThemeRect {
                        color: Theme.presenceColor(Theme.PresenceOffline)
                        text: qsTr("Offline Color")+" ("+Theme.presenceColor(Theme.PresenceOffline)+")"
                    }

                    SectionHeader {
                        visible: lightAmbiencesAvailable
                        text: qsTr("Other Colors")
                    }

                    ThemeRect {
                        visible: lightAmbiencesAvailable
                        color: lightAmbiencesAvailable ? Theme.errorColor : "transparent"
                        text: qsTr("Error Color")+" ("+Theme.errorColor+")"
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
