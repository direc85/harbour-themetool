import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

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
                title: "Font Families"

                content.sourceComponent: ExpandingColumn {
                    Label {
                        width: parent.width
                        font: Theme.fontFamily
                        text: "Default: "+Theme.fontFamily
                    }
                    Label {
                        width: parent.width
                        font: Theme.fontFamilyHeading
                        text: "Heading: "+Theme.fontFamilyHeading
                    }
                }
            }

            //////////////////////////////////////////////////

            ExpandingSection {
                title: "Font Sizes"

                content.sourceComponent: ExpandingColumn {
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeTiny
                        text: "Tiny ("+Theme.fontSizeTiny+"px)"
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeExtraSmall
                        text: "Extra Small ("+Theme.fontSizeExtraSmall+"px)"
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeSmall
                        text: "Small ("+Theme.fontSizeSmall+"px)"
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeMedium
                        text: "Medium ("+Theme.fontSizeMedium+"px)"
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeLarge
                        text: "Large ("+Theme.fontSizeLarge+"px)"
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeExtraLarge
                        text: "Extra Large ("+Theme.fontSizeExtraLarge+"px)"
                    }
                    ThemeLabel {
                        font.pixelSize: Theme.fontSizeHuge
                        text: "Huge ("+Theme.fontSizeHuge+"px)"
                    }
                }
            }

            //////////////////////////////////////////////////

            ExpandingSection {
                title: "Icon Sizes"
                content.sourceComponent: ExpandingColumn {
                    ThemeIcon {
                        size: Theme.iconSizeExtraSmall
                        text: "Extra Small ("+Theme.iconSizeExtraSmall+"px)"
                    }
                    ThemeIcon {
                        size: Theme.iconSizeSmall
                        text: "Small ("+Theme.iconSizeSmall+"px)"
                    }
                    ThemeIcon {
                        size: Theme.iconSizeMedium
                        text: "Medium ("+Theme.iconSizeMedium+"px)"
                    }
                    ThemeIcon {
                        size: Theme.iconSizeLarge
                        text: "Large ("+Theme.iconSizeLarge+"px)"
                    }
                    ThemeIcon {
                        size: Theme.iconSizeExtraLarge
                        text: "Extra Large ("+Theme.iconSizeExtraLarge+"px)"
                    }
                    ThemeIcon {
                        size: Theme.iconSizeLauncher
                        text: "Launcher ("+Theme.iconSizeLauncher+"px)"
                    }
                }
            }

            //////////////////////////////////////////////////

            ExpandingSection {
                title: "Colors"
                content.sourceComponent: ExpandingColumn {
                    SectionHeader {
                        text: "Default Colors"
                    }
                    ThemeRect {
                        color: Theme.primaryColor
                        text: "Primary Color ("+Theme.primaryColor+")"
                    }
                    ThemeRect {
                        color: Theme.secondaryColor
                        text: "Secondary Color ("+Theme.secondaryColor+")"
                    }
                    ThemeRect {
                        color: Theme.highlightColor
                        text: "Highlight Color ("+Theme.highlightColor+")"
                    }
                    ThemeRect {
                        color: Theme.highlightDimmerColor
                        text: "Highlight Dimmer Color ("+Theme.highlightDimmerColor+")"
                    }
                    ThemeRect {
                        color: Theme.highlightBackgroundColor
                        text: "Highlight Background Color ("+Theme.highlightBackgroundColor+")"
                    }
                    ThemeRect {
                        color: Theme.secondaryHighlightColor
                        text: "Secondary Highlight Color ("+Theme.secondaryHighlightColor+")"
                    }
                    ThemeRect {
                        color: Theme.overlayBackgroundColor
                        text: "Overlay Background Color ("+Theme.overlayBackgroundColor+")"
                    }


                    SectionHeader {
                        text: "Dark Colors"
                    }
                    ThemeRect {
                        color: Theme.darkPrimaryColor
                        text: "Dark Primary Color ("+Theme.darkPrimaryColor+")"
                    }
                    ThemeRect {
                        color: Theme.darkSecondaryColor
                        text: "Dark Secondary Color ("+Theme.darkSecondaryColor+")"
                    }

                    SectionHeader {
                        text: "Light Colors"
                    }
                    ThemeRect {
                        color: Theme.lightPrimaryColor
                        text: "Light Primary Color ("+Theme.lightPrimaryColor+")"
                    }
                    ThemeRect {
                        color: Theme.lightSecondaryColor
                        text: "Light Secondary Color ("+Theme.lightSecondaryColor+")"
                    }

                    SectionHeader {
                        text: "Presence Mode Colors"
                    }
                    ThemeRect {
                        color: Theme.presenceColor(Theme.PresenceAvailable)
                        text: "Available Color ("+Theme.presenceColor(Theme.PresenceAvailable)+")"
                    }
                    ThemeRect {
                        color: Theme.presenceColor(Theme.PresenceAway)
                        text: "Away Color ("+Theme.presenceColor(Theme.PresenceAAway)+")"
                    }
                    ThemeRect {
                        color: Theme.presenceColor(Theme.PresenceBusy)
                        text: "Busy Color ("+Theme.presenceColor(Theme.PresenceBusy)+")"
                    }
                    ThemeRect {
                        color: Theme.presenceColor(Theme.PresenceOffline)
                        text: "Offline Color ("+Theme.presenceColor(Theme.PresenceOffline)+")"
                    }

                    SectionHeader {
                        text: "Other Colors"
                    }

                    ThemeRect {
                        color: Theme.errorColor
                        text: "Error Color ("+Theme.errorColor+")"
                    }
                }
            }

            //////////////////////////////////////////////////

            ExpandingSection {
                title: "Button Sizes"
                content.sourceComponent: ExpandingColumn {
                    Button {
                        width: Theme.buttonWidthExtraSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "XSmall"
                    }
                    Button {
                        width: Theme.buttonWidthSmall
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Small"
                    }
                    Button {
                        width: Theme.buttonWidthMedium
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Medium"
                    }
                    Button {
                        width: Theme.buttonWidthLarge
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Large"
                    }
                }
            }
            //////////////////////////////////////////////////

            ExpandingSection {
                title: "Cover Sizes"
                content.sourceComponent: ExpandingColumn {
                    CoverRect {
                        size: Theme.coverSizeSmall
                        text: "Small"
                    }
                    CoverRect {
                        size: Theme.coverSizeLarge
                        text: "Large"
                    }
                }
            }
        }
    }
}
