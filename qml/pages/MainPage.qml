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
                            source: Theme._homeBackgroundImage
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
                        text: qsTr("Dark Colors")
                    }
                    ThemeRect {
                        color: Theme.darkPrimaryColor
                        text: qsTr("Dark Primary Color")+" ("+Theme.darkPrimaryColor+")"
                    }
                    ThemeRect {
                        color: Theme.darkSecondaryColor
                        text: qsTr("Dark Secondary Color")+" ("+Theme.darkSecondaryColor+")"
                    }

                    SectionHeader {
                        text: qsTr("Light Colors")
                    }
                    ThemeRect {
                        color: Theme.lightPrimaryColor
                        text: qsTr("Light Primary Color")+" ("+Theme.lightPrimaryColor+")"
                    }
                    ThemeRect {
                        color: Theme.lightSecondaryColor
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
                        text: qsTr("Other Colors")
                    }

                    ThemeRect {
                        color: Theme.errorColor
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
