import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    width: parent.width
    height: Math.max(rect.height, label.height)
    property alias color: rect.color
    property alias text: label.text

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
        wrapMode: Text.Wrap
        maximumLineCount: 2
        text: parent.text
    }
}
