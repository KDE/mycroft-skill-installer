import QtQuick 2.9
import QtQml.Models 2.3
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.12 as Kirigami
import QMLTermWidget 1.0

import "code/Installer.js" as Installer
import "code/SkillUtils.js" as SkillUtils

Drawer {
    id: mainInstallerDrawer
    edge: Qt.BottomEdge
    width: window.width
    height: window.height / 2
    dragMargin: 0
    interactive: true
    dim: false

    property var currentPos
    property bool hasSystemDeps

    function initializeInstaller() {
        Installer.initInstallation()
    }

    ColumnLayout {
        anchors.fill: parent

        Rectangle {
            id: pBarRect
            visible: true
            color: Kirigami.Theme.backgroundColor
            Layout.fillWidth: true
            Layout.preferredHeight: Kirigami.Units.gridUnit * 4

            Label {
                id: installStep
                visible: text.length > 0
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: Kirigami.Units.largeSpacing
                anchors.rightMargin: Kirigami.Units.largeSpacing
                height: Kirigami.Units.gridUnit * 2
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignLeft
                maximumLineCount: 1
                elide: Text.ElideRight
                color: Kirigami.Theme.textColor
            }

            ProgressBar {
                id: pBar
                anchors.top: installStep.bottom
                anchors.topMargin: Kirigami.Units.largeSpacing
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: Kirigami.Units.largeSpacing
                anchors.rightMargin: Kirigami.Units.largeSpacing
                anchors.bottom: parent.bottom
            }
        }

        Kirigami.Separator {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
        }

        Rectangle {
            id: terminalArea
            Layout.fillWidth: true
            Layout.preferredHeight: parent.height - (pBarRect.height + Kirigami.Units.largeSpacing)
            visible: true
            color: Kirigami.Theme.backgroundColor

            // @disable-check M300
            QMLTermWidget {
                id: terminal
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 8
                font.family: "Monospace"
                font.pointSize: 8
                colorScheme: "cool-retro-term"
                // @disable-check M300
                session: QMLTermSession{
                    id: mainsession
                    property bool hasFinished: false
                    initialWorkingDirectory: "$HOME"
                    onMatchFound: {
                        console.log("found at: %1 %2 %3 %4".arg(startColumn).arg(startLine).arg(endColumn).arg(endLine));
                    }
                    onNoMatchFound: {
                        console.log("not found");
                    }
                    onFinished: {
                        switch(currentPos){
                        case "cleanInstallerCompleted":
                            hasFinished = true;
                            if(hasSystemDeps){
                                Installer.getSysDepInstallerOne()
                            }
                            else {
                                Installer.getInstallers()
                            }
                            break;
                        case "cleanInstallerSysDepOneCompleted":
                            hasFinished = true;
                            Installer.cleanSysDepInstallerFileTwo()
                            break
                        case "cleanInstallerSysDepTwoCompleted":
                            hasFinished = true;
                            Installer.cleanSysDepInstallerFileThree()
                            break
                        case "installerOneDownloaded":
                            hasFinished = true;
                            Installer.getSysDepInstallerTwo()
                            break
                        case "installerTwoDownloaded":
                            hasFinished = true;
                            Installer.getSysDepInstallerThree()
                            break
                        case "installerDownloaded":
                            hasFinished = true;
                            if(hasSystemDeps){
                                Installer.setPermissionSysDepInstallerOne()
                            } else {
                                Installer.setPermission()
                            }
                            break;

                        case "permissionOneSet":
                            hasFinished = true;
                            Installer.setPermissionSysDepInstallerTwo()
                            break

                        case "permissionTwoSet":
                            hasFinished = true;
                            Installer.setPermissionSysDepInstallerThree()
                            break

                        case "permissionSet":
                            hasFinished = true;
                            if(hasSystemDeps){
                                Installer.runSysDepInstallerOne()
                            } else {
                                Installer.runInstallers()
                            }
                            break;

                        case "installerOneFinished":
                            hasFinished = true;
                            Installer.runSysDepInstallerTwo()
                            break;

                        case "installerFinished":
                            hasFinished = true
                            //getSkillStatus()
                            Installer.cleanBranchInstaller()
                            break;
                        case "cleanBranchInstallerCompleted":
                            hasFinished = true
                            Installer.getBranchInstaller()
                            break;
                        case "branchInstallerDownloaded":
                            hasFinished = true
                            Installer.setPermissionBranchInstaller()
                            break;
                        case "branchPermissionSet":
                            hasFinished = true
                            Installer.runBranchInstallers()
                            break;
                        case "branchInstallerFinished":
                            hasFinished = true
                            installStep.text = "INFO - Installation Completed"
                            SkillUtils.delay(3000, function() {
                                installerView.updateXMLModel()
                                mainInstallerDrawer.close()
                            })
                            break;
                        case "installDesktopFile":
                            hasFinished = true
                            Installer.cleanDesktopFileInstaller()
                            break;
                        case "cleanDesktopInstallerCompleted":
                            hasFinished = true
                            Installer.getDesktopFileInstaller()
                            break;
                        case "desktopFileInstallerDownloaded":
                            hasFinished = true
                            Installer.setPermissionDesktopFileInstaller()
                            break;
                        case "desktopFilePermissionSet":
                            hasFinished = true
                            Installer.runDesktopFileInstallers();
                            break;
                        case "desktopFileInstallerFinished":
                            hasFinished = true
                            installStep.text = "INFO - Installation Completed"
                            SkillUtils.delay(3000, function() {
                                installerView.updateXMLModel()
                                mainInstallerDrawer.close()
                            })
                            break;
                            //RemoverLogic
                        case "cleanRemoverCompleted":
                            hasFinished = true
                            Installer.getRemovers()
                            break;
                        case "cleanRemoverOneCompleted":
                            hasFinished = true
                            Installer.cleanRemoverTwo()
                            break;
                        case "removerDownloaded":
                            hasFinished = true
                            Installer.setPermissionRemover()
                            break;
                        case "permissionSetRemover":
                            hasFinished = true
                            Installer.runRemover()
                            break;
                        case "getRemoveDesktopFile":
                            hasFinished = true
                            Installer.getRemoveDesktopFile()
                            break;
                        case "setRemoveDesktopFilePerm":
                            hasFinished = true
                            Installer.setRemoveDesktopFilePerm()
                            break;
                        case "removerDesktopFilePermsSet":
                            hasFinished = true
                            Installer.runRemoverDesktopFile()
                            break;
                        case "removerFinished":
                            hasFinished = true
                            installStep.text = "INFO - Uninstall Completed"
                            SkillUtils.delay(3000, function() {
                                installerView.updateXMLModel()
                                mainInstallerDrawer.close()
                            })
                            break;
                        }
                    }
                }

                QMLTermScrollbar {
                    terminal: terminal
                    width: 20
                    Rectangle {
                        opacity: 0.4
                        anchors.margins: 5
                        radius: width * 0.5
                        anchors.fill: parent
                    }
                }
            }
        }
    }
}
