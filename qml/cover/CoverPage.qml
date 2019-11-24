import QtQuick 2.6
import Sailfish.Silica 1.0

CoverBackground {
    Rectangle {
        anchors {
            top: label.top
            bottom: label.bottom
            left: parent.left
            right: parent.right
        }
        color: Theme.highlightDimmerColor
        opacity: 0.9
    }

    Label {
        id: label
        anchors {
            centerIn: parent
            topMargin: Theme.paddingSmall
            bottomMargin: Theme.paddingSmall
        }
        horizontalAlignment: Text.AlignHCenter
        text: "Theme\nTool"
    }

    Image {
        id: wallpaper
        anchors.fill: parent
        asynchronous: true
        source: Theme._homeBackgroundImage
        fillMode: Image.PreserveAspectCrop
        opacity: 0.25
    }
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-next"
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-pause"
        }
    }
}
