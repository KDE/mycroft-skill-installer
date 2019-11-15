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
import org.kde.kirigami 2.11 as Kirigami

Controls.ItemDelegate {
    id: delegate

    implicitWidth: listView.cellWidth
    implicitHeight: listView.height

    readonly property ListView listView: ListView.view
    property var skillInfo

    z: listView.currentIndex == index ? 2 : 0

    onClicked: {
        listView.currentIndex = index
        lview.setItem()
        window.initInstallation()
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

    leftPadding: frame.margins.left + background.extraMargin
    topPadding: frame.margins.top + background.extraMargin
    rightPadding: frame.margins.right + background.extraMargin
    bottomPadding: frame.margins.bottom + background.extraMargin

    background: Item {
        id: background
        property real extraMargin:  Math.round(listView.currentIndex == index && delegate.activeFocus ? units.gridUnit/10 : units.gridUnit/2)
        Behavior on extraMargin {
            NumberAnimation {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
        }

        PlasmaCore.FrameSvgItem {
            anchors {
                fill: frame
                leftMargin: -margins.left
                topMargin: -margins.top
                rightMargin: -margins.right
                bottomMargin: -margins.bottom
            }
            imagePath: ":/qml/delegates/background.svg"
            prefix: "shadow"
        }
        PlasmaCore.FrameSvgItem {
            id: frame
            anchors {
                fill: parent
                margins: background.extraMargin
            }
            imagePath: ":/qml/delegates/background.svg"

            width: listView.currentIndex == index && delegate.activeFocus ? parent.width : parent.width - units.gridUnit
            height: listView.currentIndex == index && delegate.activeFocus ? parent.height : parent.height - units.gridUnit
            opacity: 0.8
        }
    }

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
            //Layout.maximumWidth: parent.width
            //Layout.maximumHeight: width
            //Layout.alignment: Qt.AlignTop
            width: parent.width
            height: width - Kirigami.Units.gridUnit * 1.5
            anchors.top: label.bottom
            anchors.topMargin: Kirigami.Units.smallSpacing
            fillMode: Image.Stretch
            source: previewpic1
        }

        Kirigami.Separator {
            id: descSep
            //            Layout.fillWidth: true
            //            Layout.preferredHeight: 1
            //            Layout.topMargin: Kirigami.Units.smallSpacing
            anchors.top: icon.bottom
            anchors.topMargin: Kirigami.Units.smallSpacing
            width: parent.width
            height: 1
            color: Kirigami.Theme.textColor
            visible: true
        }

        Item {
            id: descBox
            width: parent.width
            anchors.top: descSep.bottom
            anchors.topMargin: Kirigami.Units.smallSpacing * 0.5
            anchors.bottom: installedBox.visible ? installedBox.top : parent.bottom

            Kirigami.Heading {
                id: desc
                visible: text.length > 0
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.top: parent.top
                width: parent.width
                height: parent.height / 2
                level: 3
                maximumLineCount: 3
                elide: Text.ElideRight
                color: PlasmaCore.ColorScope.textColor
                text: description
            }
            Item {
                anchors.top: desc.bottom
                width: parent.width
                height: parent.height / 2
                Kirigami.CardsListView {
                    id: exampleRep
                    anchors.fill: parent
                    spacing: 1
                    clip: true
                    delegate: ListDelegate {}
                }
            }
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

            Kirigami.Icon {
                id: iconInstall
                //Layout.preferredWidth: Kirigami.Units.iconSizes.large
                //Layout.preferredHeight: Kirigami.Units.iconSizes.large
                //Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                anchors.top: iconSep.bottom
                width: Kirigami.Units.iconSizes.large
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
                source: "answer-correct"
                visible: true
            }
        }
    }
}
