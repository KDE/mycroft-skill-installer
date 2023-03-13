/*
 *   SPDX-FileCopyrightText: 2019-2020 Aditya Mehra <aix.m@outlook.org>
 *   SPDX-FileCopyrightText: 2019-2020 Marco Martin <mart@kde.org>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3 as Controls
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kirigami 2.12 as Kirigami
import QtGraphicalEffects 1.0
import org.kde.mycroft.bigscreen 1.0 as BigScreen
import GlobalConfiguration 1.0
import SysInfo 1.0

import "../code/SkillUtils.js" as SkillUtils

BigScreen.AbstractDelegate {
    id: delegate

    implicitWidth: listView.cellWidth
    implicitHeight: listView.height

    property var skillInfo
    property bool delDisbaled: false
    property var backendType: GlobalConfiguration.backendConfig
    property var systemUser: GlobalConfiguration.getSystemUser()

    onClicked: {
        if(!delDisbaled){
            listView.currentIndex = index
            lview.setItem()
            installerBox.open()
        }
    }

    Keys.onReturnPressed: {
        clicked()
    }

    Component.onCompleted: {
        if (downloadlink1.substring(downloadlink1.lastIndexOf('/') + 1) != "skill.json"){
            delegate.delDisbaled = true;
        } else {
            SkillUtils.populateSkillInfo(backendType, systemUser)
        }
    }

    onSkillInfoChanged: {
        installedBox.visible = skillInfo.skillInstalled
    }

    contentItem: Item {

        Rectangle {
            anchors.fill: parent
            visible: delDisbaled
            enabled: delDisbaled
            color: Qt.rgba(0, 0, 0, 0.95)
            z: 200

            Kirigami.Heading {
                anchors.top: parent.top
                anchors.topMargin: Kirigami.Units.largeSpacing
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                level: 3
                text: name
            }

            Kirigami.Heading {
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                level: 3
                text: "Skill Disabled\nContact Author\n" + personid
            }

            Kirigami.Heading {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Kirigami.Units.largeSpacing
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                level: 3
                color: Kirigami.Theme.linkColor
                text: "Error: Invalid JSON"
            }
        }

        Kirigami.Heading {
            id: label
            visible: text.length > 0
            level: 3
            width: parent.width
            height: Kirigami.Units.gridUnit * 1.5
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            maximumLineCount: 2
            elide: Text.ElideRight
            color: PlasmaCore.ColorScope.textColor
            text: name
        }

        Image {
            id: icon
            width: parent.width * 0.5625
            height: width
            sourceSize.height: parent.width
            sourceSize.width: parent.height
            anchors.top: label.bottom
            anchors.topMargin: Kirigami.Units.largeSpacing * 2
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.Stretch
            source: previewpic1
        }

        Kirigami.Separator {
            id: descSep
            anchors.top: icon.bottom
            anchors.topMargin: Kirigami.Units.largeSpacing * 2
            width: parent.width
            height: 1
            color: Kirigami.Theme.textColor
            visible: true
        }

        Kirigami.Heading {
            visible: text.length > 0
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            anchors.top: descSep.bottom
            anchors.topMargin: Kirigami.Units.largeSpacing * 2
            width: parent.width
            level: 3
            maximumLineCount: 4
            elide: Text.ElideRight
            color: PlasmaCore.ColorScope.textColor
            text: description
        }

        Item {
            id: installedBox
            visible: false
            anchors.bottom: parent.bottom
            width: parent.width
            height: Kirigami.Units.gridUnit * 3

            Kirigami.Separator {
                id: iconSep
                width: parent.width
                height: 1
                color: Kirigami.Theme.textColor
                visible: true
            }

            RowLayout {
                anchors.top: iconSep.bottom
                anchors.horizontalCenter: parent.horizontalCenter

                Image {
                    id: iconInstall
                    Layout.topMargin: Kirigami.Units.largeSpacing
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: Kirigami.Units.iconSizes.medium
                    Layout.preferredHeight: width
                    source: "qrc:/qml/images/green-tick-thick.svg"
                    visible: true
                }

                Kirigami.Heading {
                    level: 3
                    Layout.topMargin: Kirigami.Units.largeSpacing
                    Layout.alignment: Qt.AlignHCenter
                    text: "Installed"
                }

                Kirigami.Icon {
                    visible: itemUpdateStatus
                    enabled: visible
                    source: "update-none"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.preferredWidth: iconInstall.width
                    Layout.preferredHeight: iconInstall.height
                    color: Kirigami.Theme.highlightColor
                }
            }
        }
    }
}
