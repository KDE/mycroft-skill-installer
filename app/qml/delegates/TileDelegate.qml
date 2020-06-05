/*
 *  Copyright 2019 Aditya Mehra <aix.m@outlook.com>
 *  Copyright 2019 Marco Martin <mart@kde.org>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  2.010-1301, USA.
 */

import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3 as Controls
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kirigami 2.12 as Kirigami
import QtGraphicalEffects 1.0
import org.kde.mycroft.bigscreen 1.0 as BigScreen
import SysInfo 1.0

import "../code/SkillUtils.js" as SkillUtils

BigScreen.AbstractDelegate {
    id: delegate

    implicitWidth: listView.cellWidth
    implicitHeight: listView.height

    property var skillInfo

    onClicked: {
        listView.currentIndex = index
        lview.setItem()
        installerBox.open()
    }

    Keys.onReturnPressed: {
        clicked()
    }

    Component.onCompleted: {
        SkillUtils.populateSkillInfo(downloadlink1)
    }

    onSkillInfoChanged: {
        installedBox.visible = skillInfo.skillInstalled
    }

    contentItem: Item {

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
            }
        }
    }
}
