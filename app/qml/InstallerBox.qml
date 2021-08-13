/*
 *   SPDX-FileCopyrightText: 2019-2020 Aditya Mehra <aix.m@outlook.org>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.9
import QtQml.Models 2.3
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import org.kde.kirigami 2.12 as Kirigami
import SysInfo 1.0
import "delegates" as Delegates

import "code/Installer.js" as Installer

Popup {
    id: skillInstallerBox
    width: parent.width / 2
    height: parent.height
    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)
    dim: true
    property var getArch: SysInfo.getArch()
    property var skillInfo

    onOpened: {
        installUninstallBtn.forceActiveFocus()
    }

    function checkPlatformSupport() {
        console.log("From QML BOX: " + skillInfo.itemUpdateStatus)
        var platforms
        if(skillInfo.platforms === "all"){
            platforms = ["all"]
        } else {
            platforms = skillInfo.platforms.split(",")
        }
        if(platforms.indexOf("all") !== -1){
            return 1
        } else {
            if(platforms.indexOf(getArch) !== -1){
                return 1
            } else {
                installUninstallBtn.enabled = false
                skiStatusLabl.text = "Unsupported Architecture"
                skiStatusArea.visible = true
                return 0
            }
        }
    }

    background: Rectangle {
        color: Kirigami.Theme.backgroundColor
        layer.enabled: true
        anchors.fill: parent
        anchors.margins: Kirigami.Units.gridUnit
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 2
            radius: 8.0
            samples: 8
            color: Qt.rgba(0,0,0,0.6)
        }
    }

    Item {
        id: descBox
        anchors.fill: parent
        anchors.margins: Kirigami.Units.gridUnit

        RowLayout {
            id: desc
            anchors.top: parent.top
            width: parent.width
            height: parent.height / 4

            Image {
                id: skiicon
                Layout.preferredWidth: Kirigami.Units.iconSizes.huge
                Layout.preferredHeight: Kirigami.Units.iconSizes.huge
                Layout.alignment: Qt.AlignCenter
                Layout.leftMargin: Kirigami.Units.smallSpacing
                fillMode: Image.Stretch
                source: skillInfo ? (typeof skillInfo.itemPreviewPic !== "undefined" ? skillInfo.itemPreviewPic : "") : ""
            }

            Kirigami.Heading {
                visible: text.length > 0
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: true
                Layout.fillHeight: true
                level: 3
                maximumLineCount: 3
                elide: Text.ElideRight
                color: Kirigami.Theme.textColor
                text: skillInfo ? (typeof skillInfo.itemDescription !== "undefined" ? skillInfo.itemDescription : "") : ""
            }
        }

        Kirigami.Separator {
            id: descSept1
            anchors.top: desc.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: Kirigami.Units.smallSpacing
            anchors.rightMargin: Kirigami.Units.smallSpacing
            height: 1
        }

        Kirigami.Heading {
            id: descListHeading
            level: 3
            anchors.top: descSept1.bottom
            width: parent.width
            height: Kirigami.Units.gridUnit * 2
            anchors.left: parent.left
            anchors.leftMargin: Kirigami.Units.smallSpacing
            text: "Some Example's To Try: " + "<i>Hey Mycroft..</i>"
        }

        Kirigami.Separator {
            id: descSept2
            anchors.top: descListHeading.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: Kirigami.Units.smallSpacing
            anchors.rightMargin: Kirigami.Units.smallSpacing
            height: 1
        }

        Item {
            anchors.top: descSept2.bottom
            anchors.topMargin: Kirigami.Units.smallSpacing
            width: parent.width
            height: parent.height / 2

            Kirigami.CardsListView {
                id: exampleRep
                anchors.fill: parent
                model: skillInfo ? (typeof skillInfo.examples !== "undefined" ? skillInfo.examples.split(",") : "") : ""
                spacing: 1
                clip: true
                delegate: Delegates.ListDelegate{}
            }
        }

        Rectangle {
            id: skiStatusArea
            anchors.bottom: installUninstallBtn.top
            anchors.bottomMargin: Kirigami.Units.smallSpacing
            color: skillInfo ? (typeof skillInfo.itemUpdateStatus !== "undefined" && skillInfo.itemUpdateStatus ? "#33BB5E" : Kirigami.Theme.highlightColor) : ""
            height: Kirigami.Units.gridUnit * 2
            visible: skillInfo ? (typeof skillInfo.itemInstallStatus !== "undefined" ? skillInfo.itemInstallStatus : "") : ""
            width: parent.width

            Kirigami.Heading {
                id: skiStatusLabl
                level: 3
                text: skillInfo ? (typeof skillInfo.itemUpdateStatus !== "undefined" && skillInfo.itemUpdateStatus ? "Status: Update Available" : "Status: Installed") : ""
                anchors.fill: parent
                visible: skiStatusArea.visible
                anchors.leftMargin: Kirigami.Units.smallSpacing
            }
        }

        Button {
            id: installUninstallBtn
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: Kirigami.Units.smallSpacing
            anchors.rightMargin: Kirigami.Units.smallSpacing
            anchors.bottomMargin: Kirigami.Units.smallSpacing
            anchors.right: parent.right
            height: Kirigami.Units.gridUnit * 2

            background: Rectangle {
                Kirigami.Theme.colorSet: Kirigami.Theme.Button
                color: installUninstallBtn.down ? Kirigami.Theme.highlightColor : Kirigami.Theme.backgroundColor
                border.color: installUninstallBtn.activeFocus ? Kirigami.Theme.hoverColor : Kirigami.Theme.disabledTextColor
                border.width: 1
            }

            contentItem: Label {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                text: skillInfo ? (skillInfo.itemUpdateStatus ? "Update" : (skillInfo.itemInstallStatus ? "Uninstall" : "Install")) : ""
            }

            onClicked: {
                if(skillInfo.itemUpdateStatus){
                    installerArea.initializeUpdater()
                } else {
                    installerArea.initializeInstaller()
                }
            }

            Keys.onReturnPressed: {
                clicked()
            }
        }
    }
}
