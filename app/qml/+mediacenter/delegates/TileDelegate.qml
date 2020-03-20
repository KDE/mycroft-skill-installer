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

BigScreen.AbstractDelegate {
    id: delegate

    implicitWidth: listView.cellWidth
    implicitHeight: listView.height

    property var skillInfo
    property alias ski: skillInstallerBox

    onClicked: {
        listView.currentIndex = index
        lview.setItem()
        //window.initInstallation()
        skillInstallerBox.open()
    }

    Component.onCompleted: {
        console.log(populateSkillInfo(downloadlink1))
    }

    function populateSkillInfo(jsonUrl){
        var doc = new XMLHttpRequest()
        doc.open("GET", jsonUrl, true);
        doc.send();

        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                var tempRes = doc.responseText
                var checkModel = JSON.parse(tempRes)
                var defaultFold = '/opt/mycroft/skills'
                console.log(checkModel.skillname)
                var skillObj = {}
                var skillPath = defaultFold + "/" + checkModel.skillname + "." + checkModel.authorname
                if(fileReader.file_exists_local(skillPath)){
                    console.log("installed")
                    skillObj = {displayName: checkModel.name, skillName: checkModel.skillname, authorName: checkModel.authorname, folderName: checkModel.foldername, skillUrl: checkModel.url, skillInstalled: true, branch: checkModel.branch, skillFolderPath: skillPath, warning: checkModel.warning, desktopFile: checkModel.desktopFile, examples: checkModel.examples}
                    skillInfo = skillObj
                }
                else {
                    console.log("false")
                    skillObj = {displayName: checkModel.name, skillName: checkModel.skillname, authorName: checkModel.authorname, folderName: checkModel.foldername, skillUrl: checkModel.url, skillInstalled: false, branch: checkModel.branch, skillFolderPath: skillPath, warning: checkModel.warning, desktopFile: checkModel.desktopFile, examples: checkModel.examples}
                    skillInfo = skillObj
                }
            }
        }
    }

    onSkillInfoChanged: {
        console.log(skillInfo.skillFolderPath)
        exampleRep.model = skillInfo.examples
        installedBox.visible = skillInfo.skillInstalled
    }

    //    leftPadding: frame.margins.left + background.extraMargin
    //    topPadding: frame.margins.top + background.extraMargin
    //    rightPadding: frame.margins.right + background.extraMargin
    //    bottomPadding: frame.margins.bottom + background.extraMargin

    contentItem: Item {
        //spacing: 0

        Kirigami.Heading {
            id: label
            visible: text.length > 0
            level: 3
            //Layout.fillWidth: true
            //Layout.preferredHeight: Kirigami.Units.gridUnit * 1.5
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
            //            Layout.fillWidth: true
            //            Layout.preferredHeight: 1
            //            Layout.topMargin: Kirigami.Units.smallSpacing
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
                //Layout.fillWidth: true
                //Layout.preferredHeight: 1
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
                    //Layout.preferredWidth: Kirigami.Units.iconSizes.large
                    //Layout.preferredHeight: Kirigami.Units.iconSizes.large
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
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

    Controls.Popup {
        id: skillInstallerBox
        width: listView.width / 2
        height: listView.height
        parent: listView
        x: Math.round((parent.width - width) / 2)
        y: Math.round((parent.height - height) / 2)
        dim: true

        onOpened: {
            installUninstallBtn.forceActiveFocus()
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
                    source: previewpic1
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
                    color: PlasmaCore.ColorScope.textColor
                    text: description
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
                    spacing: 1
                    clip: true
                    delegate: ListDelegate{}
                }
            }

            Rectangle {
                id: skiStatusArea
                anchors.bottom: installUninstallBtn.top
                anchors.bottomMargin: Kirigami.Units.smallSpacing
                color: Kirigami.Theme.highlightColor
                height: Kirigami.Units.gridUnit * 2
                visible: iconInstall.visible
                width: parent.width

                Kirigami.Heading {
                    level: 3
                    text: "Status: Installed"
                    anchors.fill: parent
                    visible: iconInstall.visible
                    anchors.leftMargin: Kirigami.Units.smallSpacing
                }
            }

            Controls.Button {
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

                contentItem: Controls.Label {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    text: iconInstall.visible ? "Uninstall" : "Install"
                }

                onClicked: {
                    window.initInstallation()
                }

                Keys.onReturnPressed: {
                    clicked()
                }
            }
        }
    }
}
