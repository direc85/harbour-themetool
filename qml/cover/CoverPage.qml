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

CoverBackground {

    property variant fontSize: ["'normal'", "'large'", "'huge'"]
    property int fontSizeIndex: 0
    property bool cooldown: false

    Timer {
        id: cooldownTimer
        interval: 100
        running: false
        repeat: false
        onTriggered: cooldown = false
    }

    Rectangle {
        anchors {
            top: label.top
            bottom: label.bottom
            left: parent.left
            right: parent.right
        }
        color: Theme.highlightDimmerColor
    }

    Label {
        id: label
        anchors {
            centerIn: parent
            topMargin: Theme.paddingSmall
            bottomMargin: Theme.paddingSmall
        }
        horizontalAlignment: Text.AlignHCenter
        font.weight: Font.Bold
        text: qsTr("Theme\nTool")
    }

    Image {
        id: wallpaper
        anchors.fill: parent
        asynchronous: true
        source: Theme.backgroundImage
        fillMode: Image.PreserveAspectCrop
        opacity: 0.25
    }

    Process {
        id: process
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-next"
            onTriggered: {
                if(!cooldown) {
                    cooldown = true
                    fontSizeIndex = (fontSizeIndex + 1) % 3
                    process.start("/usr/bin/dconf", ["write","/desktop/jolla/theme/font/sizeCategory", fontSize[fontSizeIndex]])
                    cooldownTimer.start()
                }
            }
        }
    }
}
