import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    width: parent.width
    height: Math.max(icon.height, label.height)
    property alias text: label.text
    property int size

    Icon {
        id: icon
        width: parent.size
        height: parent.size
        source: "image://theme/icon-l-image"
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }

        Rectangle {
            anchors.fill: parent
            z: -1
            color: label.color
            opacity: 0.2
        }
    }

    Label {
        id: label
        anchors {
            left: icon.right
            leftMargin: Theme.paddingMedium
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        wrapMode: Text.NoWrap
        truncationMode: TruncationMode.Fade
    }
}
