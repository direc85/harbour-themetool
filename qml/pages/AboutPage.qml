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

import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: aboutPage

    allowedOrientations: Orientation.Portrait | Orientation.Landscape | Orientation.LandscapeInverted

    SilicaFlickable {
        id: aboutFlickable
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }
            width: Math.min(Screen.width, aboutFlickable.width)
            spacing: Theme.paddingLarge

            Item {
                width: parent.width
                height: Theme.paddingLarge
            }
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: Qt.resolvedUrl("/usr/share/icons/hicolor/172x172/apps/harbour-themetool.png")
                width: Theme.iconSizeExtraLarge
                height: Theme.iconSizeExtraLarge
                smooth: true
                asynchronous: true
            }
            AboutLabel {
                font.pixelSize: Theme.fontSizeLarge
                color: Theme.highlightColor
                text: "Theme Tool " + app_version
            }
            AboutLabel {
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                text: "© 2019-2020 Matti Viljanen"
            }
            AboutLabel {
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                text: qsTr("A simple tool to review the current ambience colors and element sizes.")
            }
            AboutLabel {
                font.pixelSize: Theme.fontSizeSmall
                text: qsTr("Finnish")+" - Matti Viljanen\n"+
                      qsTr("Swedish")+" - Åke Engelbrektson\n"+
                      qsTr("Chinese")+" - dashinfantry\n"+
                      qsTr("Croatian")+" - milotype"
            }
            AboutLabel {
                font.pixelSize: Theme.fontSizeSmall
                text: qsTr("Source code is available at GitHub. Translations, bug reports and other contributions are welcome!")
            }
            Button {
                text: "GitHub"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: Qt.openUrlExternally("https://github.com/direc85/harbour-themetool")
            }
            BackgroundItem {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Theme.iconSizeExtraLarge * 1.2
                height: Theme.iconSizeExtraLarge * 1.2
                onClicked: Qt.openUrlExternally("https://ko-fi.com/direc85")
                contentItem.radius: Theme.paddingSmall

                Image {
                    anchors.centerIn: parent
                    source: Qt.resolvedUrl("/usr/share/harbour-batterybuddy/images/Ko-fi_Icon_RGB_rounded.png")
                    width: Theme.iconSizeExtraLarge
                    height: Theme.iconSizeExtraLarge
                    smooth: true
                    asynchronous: true
                }
            }
            AboutLabel {
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.secondaryColor
                text: qsTr("If you like my work and would like to support me, you can buy me a coffee!")
            }
            ExpandingSection {
                id: gplSection
                width: parent.width
                title: qsTr("License","License: GPLv2")+": GPLv2"
                content.sourceComponent: Item {
                    width: parent.width
                    height: gpl.height
                    GPLv2Label {
                        id: gpl
                    }
                }
            }
            Item {
                width: parent.width
                height: Theme.paddingMedium
                visible: !gplSection.expanded
            }
        }
    }
}
