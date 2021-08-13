/*
 *   SPDX-FileCopyrightText: 2019-2020 Aditya Mehra <aix.m@outlook.org>
 *
 *   SPDX-License-Identifier: GPL-3.0-or-later OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.9
import QtQml.Models 2.3
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.kde.mycroft.bigscreen 1.0 as BigScreen
import org.kde.kirigami 2.12 as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents3
import QMLTermWidget 1.0
import SysInfo 1.0
import QtGraphicalEffects 1.0
import InstallerListModel 1.0
import "delegates" as Delegates

import "code/SkillUtils.js" as SkillUtils
import "code/Installer.js" as Installer

Kirigami.Page {
    id: mainPageComponent
    title: "Mycroft Skill Installer"
    property alias skillView: lview.view
    property bool lviewFirstItem: lview.view.currentIndex != 0 ? 1 : 0

    background: Rectangle {
        color: Qt.rgba(0,0,0,0.8)
    }

    function updateInstallerModel(){
        modelInstaller.reloadJsonModel()
    }

    Rectangle {
        id: viewBusyOverlay
        z: 300
        anchors.fill: parent
        visible: false
        enabled: visible
        color: Qt.rgba(0, 0, 0, 0.8)

        PlasmaComponents3.BusyIndicator {
            id: viewBusyIndicator
            visible: viewBusyOverlay.visible
            anchors.centerIn: parent
            running: viewBusyOverlay.visible
            enabled: viewBusyOverlay.visible

            Label {
                id: viewBusyIndicatorLabel
                visible: viewBusyOverlay.visible
                enabled: viewBusyOverlay.visible
                anchors.top: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Loading Skills"
            }
        }
    }

    InstallerListModel {
        id: modelInstaller
        url: "https://api.kde-look.org/ocs/v1/content/data?categories=608&pagesize=100&format=json"
        query: "data"
        roles: ["id", "name", "description", "downloadlink1", "previewpic1", "typename", "personid", "downloads", "itemInstallStatus", "itemUpdateStatus", "url", "branch", "warning", "desktopFile", "examples", "platforms", "systemDeps", "authorname", "skillname", "foldername"]

        onDownloadingModelUpdated: {
            if(modelInstaller.downloadingModel()){
                viewBusyOverlay.visible = true
                viewBusyIndicatorLabel.text = "Downloading Skills"
            }
        }

        onCreatingModelUpdated: {
            if(modelInstaller.creatingModel()){
                viewBusyOverlay.visible = true
                viewBusyIndicatorLabel.text = "Checking For Updates " + modelInstaller.updatingModelCounter() + "/" + modelInstaller.completeModelCounter()
            }
        }

        onModelUpdated: {
            console.log("Got Model Updated")
            viewBusyOverlay.visible = false
            viewBusyIndicatorLabel.text = ""
            SkillUtils.fillListModel()
        }

        Component.onCompleted: {
            if(modelInstaller.downloadingModel()){
                viewBusyOverlay.visible = true
                viewBusyIndicatorLabel.text = "Downloading Skills"
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            Layout.fillWidth: true
            Layout.maximumHeight: Kirigami.Units.gridUnit * 2

            PlasmaComponents3.ComboBox {
                id: categorySelector
                displayText: "Category: " + currentText
                Layout.preferredWidth: parent.width * 0.30
                Layout.fillHeight: true
                model: [ "All Skills", "Configuration", "Entertainment", "Information", "Productivity" ]
                leftPadding: Kirigami.Units.gridUnit
                rightPadding: Kirigami.Units.gridUnit
                Keys.onDownPressed: {
                    lview.currentItem.forceActiveFocus()
                }
                Keys.onReturnPressed: {
                    categorySelector.popup.open()
                    categorySelector.popup.forceActiveFocus()
                }

                KeyNavigation.right: sortByRatingBtn

                delegate: ItemDelegate {

                    background: Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                    }

                    contentItem: Kirigami.Heading{
                        level: 2
                        text: modelData
                    }
                }

                indicator: Kirigami.Icon {
                    width: Kirigami.Units.iconSizes.small
                    height: Kirigami.Units.iconSizes.small
                    x: 0
                    y: categorySelector.topPadding + (categorySelector.availableHeight - height) / 2
                    source: categorySelector.popup.opened ? "arrow-up" : "arrow-down"
                }

                background: Rectangle {
                    anchors.fill: parent
                    anchors.rightMargin: -Kirigami.Units.gridUnit * 4
                    color: categorySelector.focus ? Kirigami.Theme.highlightColor : "transparent"
                }

                contentItem: Kirigami.Heading {
                    level: 2
                    text: categorySelector.displayText
                }

                popup: Popup {
                    y: categorySelector.height - 1
                    width: categorySelector.width
                    implicitHeight: contentItem.implicitHeight
                    padding: 1

                    onVisibleChanged: {
                        if(visible){
                            pCView.forceActiveFocus()
                        }
                    }

                    contentItem: ListView {
                        id: pCView
                        clip: true
                        implicitHeight: contentHeight
                        model: categorySelector.popup.visible ? categorySelector.delegateModel : null
                        currentIndex: categorySelector.highlightedIndex
                        keyNavigationEnabled: true
                        highlight: informationModel.highlighter
                        highlightFollowsCurrentItem: true
                        snapMode: ListView.SnapToItem

                        Keys.onReturnPressed: {
                            console.log(currentIndex)
                            categorySelector.currentIndex = pCView.currentIndex
                            categorySelector.popup.close()
                            lview.forceActiveFocus()
                        }
                    }

                    background: Rectangle {
                        anchors {
                            fill: parent
                            margins: -1
                        }
                        color: Kirigami.Theme.backgroundColor
                        border.color: Kirigami.Theme.backgroundColor
                        radius: 2
                        layer.enabled: true

                        layer.effect: DropShadow {
                            transparentBorder: true
                            radius: 4
                            samples: 8
                            horizontalOffset: 2
                            verticalOffset: 2
                            color: Qt.rgba(0, 0, 0, 0.3)
                        }
                    }
                }

                onCurrentIndexChanged: {
                    console.log(currentIndex)
                    if(currentIndex == 0){
                        informationModel.categoryURL = "https://api.kde-look.org/ocs/v1/content/data?categories=608&pagesize=100&format=json"
                    } else if(currentIndex == 1){
                        informationModel.categoryURL = "https://api.kde-look.org/ocs/v1/content/data?categories=609&pagesize=100&format=json"
                    } else if(currentIndex == 2){
                        informationModel.categoryURL = "https://api.kde-look.org/ocs/v1/content/data?categories=415&pagesize=100&format=json"
                    } else if(currentIndex == 3){
                        informationModel.categoryURL = "https://api.kde-look.org/ocs/v1/content/data?categories=610&pagesize=100&format=json"
                    } else if(currentIndex == 4){
                        informationModel.categoryURL = "https://api.kde-look.org/ocs/v1/content/data?categories=611&pagesize=100&format=json"
                    } else {
                        informationModel.categoryURL = "https://api.kde-look.org/ocs/v1/content/data?categories=608&pagesize=100&format=json"
                    }

                    if(informationModel.categoryURL != ""){
                        if(modelInstaller.url != informationModel.categoryURL){
                            modelInstaller.url = informationModel.categoryURL
                        }
                    }

                    lview.forceActiveFocus()
                }
            }
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
            PlasmaComponents3.Button {
                id: sortByRatingBtn
                Layout.preferredWidth: parent.width * 0.10
                Layout.fillHeight: true
                text: "Sort By Rating"
                icon.name: "view-sort"
                KeyNavigation.down: lview
                KeyNavigation.right: sortByNameBtn

                Keys.onReturnPressed: {
                    clicked()
                }

                onClicked:{
                    sortModel.sortColumnName = "downloads"
                    sortModel.order = "desc"
                    sortModel.quick_sort()
                }
            }

            PlasmaComponents3.Button {
                id: sortByNameBtn
                Layout.preferredWidth: parent.width * 0.10
                Layout.fillHeight: true
                text: "Sort By Name"
                icon.name: "view-sort"
                KeyNavigation.down: lview
                KeyNavigation.right: sortByInstalledBtn
                KeyNavigation.left: sortByRatingBtn

                Keys.onReturnPressed: {
                    clicked()
                }

                onClicked: {
                    sortModel.sortColumnName = "name"
                    sortModel.order = "asc"
                    sortModel.quick_sort()
                }
            }

            PlasmaComponents3.Button {
                id: sortByInstalledBtn
                Layout.preferredWidth: parent.width * 0.10
                Layout.fillHeight: true
                text: "Sort Installed"
                icon.name: "view-sort"
                KeyNavigation.down: lview
                KeyNavigation.right: sortByDefaultBtn
                KeyNavigation.left: sortByNameBtn

                Keys.onReturnPressed: {
                    clicked()
                }

                onClicked: {
                    sortModel.sortColumnName = "itemInstallStatus"
                    sortModel.order = "desc"
                    sortModel.quick_sort()
                }
            }

            PlasmaComponents3.Button {
                id: sortByDefaultBtn
                Layout.preferredWidth: parent.width * 0.10
                Layout.fillHeight: true
                text: "Sort Default"
                icon.name: "view-sort"
                KeyNavigation.down: lview
                KeyNavigation.left: sortByInstalledBtn

                Keys.onReturnPressed: {
                    clicked()
                }

                onClicked: {
                    sortModel.sortColumnName = ""
                    sortModel.quick_sort()
                }
            }
        }

        Kirigami.Separator {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Kirigami.ShadowedRectangle {
                id: leftArrow
                color: Kirigami.Theme.backgroundColor
                width: Kirigami.Units.iconSizes.large
                height: Kirigami.Units.iconSizes.large
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                radius: width
                anchors.leftMargin: Kirigami.Units.largeSpacing
                enabled: lviewFirstItem
                opacity: lviewFirstItem ? 1 : 0.4

                shadow {
                    size: Kirigami.Units.largeSpacing * 2
                }

                Kirigami.Icon {
                    source: "arrow-left"
                    width: Kirigami.Units.iconSizes.medium
                    height: Kirigami.Units.iconSizes.medium
                    anchors.centerIn: parent
                    enabled: lviewFirstItem
                    opacity: lviewFirstItem ? 1 : 0.4
                }
            }

            Rectangle {
                anchors.left: leftArrow.right
                anchors.leftMargin: Kirigami.Units.largeSpacing
                anchors.right: rightArrow.left
                anchors.rightMargin: Kirigami.Units.largeSpacing
                height: parent.height
                color: "transparent"
                clip: true

                SortFilterModel {
                    id: sortModel
                }

                BigScreen.TileView {
                    id: lview
                    focus: true
                    model: sortModel
                    title: " "
                    cellWidth: parent.width / 4
                    anchors.left: parent.left
                    anchors.leftMargin: Kirigami.Units.gridUnit
                    width: parent.width
                    height: parent.height

                    property string mbranch
                    property string mfolderName
                    property string mskillName
                    property string mauthorName
                    property string mskillUrl
                    property string mskillFolderPath
                    property bool mdesktopFile
                    property bool mskillInstalled
                    property bool mSystemDeps
                    property int lastIndex

                    delegate: Delegates.TileDelegate {}

                    function resetCIndex(){
                        lview.currentIndex = 0
                    }

                    onModelChanged: {
                        lview.update()
                        lview.currentIndex = 0
                    }

                    function setItem() {
                        installerBox.skillInfo = lview.currentItem.skillInfo
                        if(lview.currentItem.skillInfo){
                            mbranch = lview.currentItem.skillInfo.branch
                            mfolderName = String(lview.currentItem.skillInfo.folderName).toLowerCase()
                            mskillName = String(lview.currentItem.skillInfo.skillName).toLowerCase()
                            mauthorName = String(lview.currentItem.skillInfo.authorName).toLowerCase()
                            mskillUrl = lview.currentItem.skillInfo.skillUrl
                            mskillFolderPath = lview.currentItem.skillInfo.skillFolderPath
                            mdesktopFile = lview.currentItem.skillInfo.desktopFile
                            mskillInstalled = lview.currentItem.skillInfo.skillInstalled
                            mSystemDeps = lview.currentItem.skillInfo.systemDeps

                            console.log("Check Upper Case Issue " + mauthorName)
                        }
                    }

                    navigationUp: categorySelector
                    navigationDown: footerArea
                }
            }

            Kirigami.ShadowedRectangle {
                id: rightArrow
                color: Kirigami.Theme.backgroundColor
                width: Kirigami.Units.iconSizes.large
                height: Kirigami.Units.iconSizes.large
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: Kirigami.Units.largeSpacing
                anchors.right: parent.right
                radius: width
                enabled: lview.currentIndex != (lview.view.count - 1) ? 1 : 0
                opacity: lview.currentIndex != (lview.view.count - 1) ? 1 : 0.4

                shadow {
                    size: Kirigami.Units.largeSpacing * 2
                }

                Kirigami.Icon {
                    source: "arrow-right"
                    width: Kirigami.Units.iconSizes.medium
                    height: Kirigami.Units.iconSizes.medium
                    anchors.centerIn: parent
                    enabled: lview.currentIndex != (lview.view.count - 1) ? 1 : 0
                    opacity: lview.currentIndex != (lview.view.count - 1) ? 1 : 0.4
                }
            }
        }
    }

    InstallerBox {
        id: installerBox
    }

    InstallerArea {
        id: installerArea
    }
}
