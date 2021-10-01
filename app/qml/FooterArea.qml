/*
 *   SPDX-FileCopyrightText: 2019-2020 Aditya Mehra <aix.m@outlook.org>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Window 2.10
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import org.kde.kirigami 2.12 as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents3

import "code/SkillUtils.js" as SkillUtils

//Item {
//    anchors.left: parent.left
//    anchors.right: parent.right
//    height: Kirigami.Units.gridUnit * 2.4

//    onFocusChanged: {
//        if(focus){
//            refreshButton.forceActiveFocus()
//        }
//    }

//    Kirigami.Separator {
//        id: footerSeparator
//        anchors.left: parent.left
//        anchors.right: parent.right
//    }

//    Rectangle {
//        anchors.top: footerSeparator.bottom
//        anchors.left: parent.left
//        anchors.right: parent.right
//        anchors.bottom: parent.bottom
//        color: "#211e1e"

//        Button {
//            id: refreshButton
//            anchors.fill: parent
//            text: "Refresh"
//            icon.name: "refactor"

//            onClicked: {
//                installerView.updateInstallerModel()
//            }

//            KeyNavigation.up: installerView
//            Keys.onReturnPressed: {
//                clicked()
//            }
//        }
//    }
//}

Rectangle {
    anchors.left: parent.left
    anchors.right: parent.right
    height: Kirigami.Units.gridUnit * 2.6
    color: Qt.rgba(0, 0, 0, 1)

    Kirigami.Separator {
        id: footerSeparator
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
    }

    onFocusChanged: {
        if(focus){
            reloadButton.forceActiveFocus()
        }
    }

    RowLayout {
        id: footerArea
        width: parent.width
        height: Kirigami.Units.gridUnit * 2.4
        anchors.bottom: parent.bottom

        Button {
            id: reloadButton
            Layout.fillWidth: true
            Layout.fillHeight: true
            KeyNavigation.right: fetchButton

            background: Rectangle {
                color: reloadButton.activeFocus ? Kirigami.Theme.highlightColor : Kirigami.Theme.backgroundColor
            }

            contentItem: Item {
                RowLayout {
                    anchors.centerIn: parent
                    Kirigami.Icon {
                        Layout.preferredWidth: Kirigami.Units.iconSizes.small
                        Layout.preferredHeight: Kirigami.Units.iconSizes.small
                        source: "view-refresh"
                    }
                    Label {
                        text: i18n("Refresh")
                    }
                }
            }

            onClicked: {
                installerView.updateInstallerModel()
            }

            KeyNavigation.up: installerView
            Keys.onReturnPressed: {
                clicked()
            }
        }

        Button {
            id: fetchButton
            Layout.fillWidth: true
            Layout.fillHeight: true
            KeyNavigation.left: reloadButton
            KeyNavigation.right: kcmcloseButton

            background: Rectangle {
                color: fetchButton.activeFocus ? Kirigami.Theme.highlightColor : Kirigami.Theme.backgroundColor
            }

            contentItem: Item {
                RowLayout {
                    anchors.centerIn: parent
                    Kirigami.Icon {
                        Layout.preferredWidth: Kirigami.Units.iconSizes.small
                        Layout.preferredHeight: Kirigami.Units.iconSizes.small
                        source: "download"
                    }
                    Label {
                        text: i18n("Fetch Latest")
                    }
                }
            }

            onClicked: {
                installerView.fetchLatestInstallerModel()
            }

            KeyNavigation.up: installerView
            Keys.onReturnPressed: {
                clicked()
            }
        }

        Button {
            id: kcmcloseButton
            KeyNavigation.up: installerView
            KeyNavigation.left: fetchButton
            Layout.fillWidth: true
            Layout.fillHeight: true

            background: Rectangle {
                color: kcmcloseButton.activeFocus ? Kirigami.Theme.highlightColor : Kirigami.Theme.backgroundColor
            }

            contentItem: Item {
                RowLayout {
                    anchors.centerIn: parent
                    Kirigami.Icon {
                        Layout.preferredWidth: Kirigami.Units.iconSizes.small
                        Layout.preferredHeight: Kirigami.Units.iconSizes.small
                        source: "window-close"
                    }
                    Label {
                        text: i18n("Exit")
                    }
                }
            }

            onClicked: {
                Window.window.close()
            }
            Keys.onReturnPressed: {
                Window.window.close()
            }
        }
    }
}
