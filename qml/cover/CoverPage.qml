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
