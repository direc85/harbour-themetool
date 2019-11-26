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

Item {
    width: parent.width
    height: Math.max(rect.height, label.height)
    property alias color: rect.color
    property string text

    Rectangle {
        id: rect
        width: Theme.iconSizeMedium
        height: Theme.iconSizeMedium
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }
        color: label.color
        opacity: 1.0
        border.color: label.color
        border.width: Theme.iconSizeExtraSmall / 10
    }

    Label {
        id: label
        anchors {
            left: rect.right
            leftMargin: Theme.paddingMedium
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        text: parent.text+" ("+rect.color+")"
        wrapMode: Text.Wrap
        maximumLineCount: 2
    }
}
