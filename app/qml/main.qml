import QtQuick 2.9
import QtQml.Models 2.3
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.WebSockets 1.0
import org.kde.kirigami 2.2 as Kirigami
import QtGraphicalEffects 1.0
import QMLTermWidget 1.0

Kirigami.ApplicationWindow {
    id: window
    visible: true
    pageStack.initialPage: mainPageComponent
    property string currentPos
    property var currentURL
    property var orignalFolder

    header: Rectangle {
        id: headerRect
        anchors.left: parent.left
        anchors.right: parent.right
        height: 150
        color: "#211e1e"
        layer.enabled: true
        layer.effect: DropShadow {
            horizontalOffset: 0
            verticalOffset: 1
            radius: 10
            samples: 32
            spread: 0.1
            color: Qt.rgba(0, 0, 0, 0.3)
        }

        Loader{
            id: bgldr
            anchors.fill: parent
            source: "CanBackground.qml"
        }
    }

    Component.onCompleted: {
        getSkills()
    }

    function getSkills(){
        var doc = new XMLHttpRequest()
        doc.open("GET", "https://raw.githubusercontent.com/AIIX/gui-skills/master/skills.json", true);
        doc.send();

        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                var path, list;
                var tempRes = doc.responseText
                var skillmodel = JSON.parse(tempRes)
                listView.model = skillmodel.skills
            }
        }
    }

    function cleanInstaller(){
        mainsession.hasFinished = false
        currentPos = ""
        var cleaninstallerfiles = ["-c", "rm -rf /tmp/skiller.sh"]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(cleaninstallerfiles)
        mainsession.startShellProgram();
        currentPos = "cleanInstallerCompleted"
    }

    function getInstallers(){
        mainsession.hasFinished = false
        currentPos = ""
        var getinstallersarg = ["-c", "wget https://raw.githubusercontent.com/AIIX/gui-skills/master/skiller.sh -P /tmp"]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        currentPos = "installerDownloaded"
    }

    function setPermission(){
        mainsession.hasFinished = false
        currentPos = ""
        var getinstallersarg = ["-c", "chmod a+x /tmp/skiller.sh"]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        currentPos = "permissionSet"
    }

    function runInstallers(){
        mainsession.hasFinished = false
        currentPos = ""
        var getinstallersarg = ["-c", "/tmp/skiller.sh" + ' ' + currentURL + ' ' + orignalFolder]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        currentPos = "installerFinished"
    }

    Kirigami.ScrollablePage{
        id: mainPageComponent
        title: "Mycroft Skill Installer"

        ListView {
            id: listView
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing:  5
            delegate: Rectangle {
                width: window.width
                height: Kirigami.Units.gridUnit * 4
                color: Kirigami.Theme.backgroundColor

                Item {
                    anchors.fill: parent
                    Label{
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.right: btnRect.left
                        anchors.margins: 12
                        text: modelData.name
                        font.pixelSize: 14
                        color: Kirigami.Theme.textColor
                    }
                    Rectangle {
                        id: btnRect
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        width: Kirigami.Units.gridUnit * 4
                        height: Kirigami.Units.gridUnit * 4
                        color: "#222"

                        Label {
                            anchors.centerIn: parent
                            text: "Install"
                            font.pixelSize: 14
                            color: Kirigami.Theme.textColor
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                currentURL = modelData.url
                                orignalFolder = modelData.foldername
                                mainInstallerDrawer.open()
                                cleanInstaller()
                            }
                        }
                    }
                }
            }
            onModelChanged: {
                listView.update()
            }
        }

        Drawer{
           id: mainInstallerDrawer
           edge: Qt.BottomEdge
           width: window.width
           height: window.height / 2
           dragMargin: 0
           interactive: true
           dim: false

           Rectangle {
               anchors.fill: parent
               color: Kirigami.Theme.backgroundColor

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
                           console.log("finished")
                               switch(currentPos){
                               case "cleanInstallerCompleted":
                                   hasFinished = true;
                                   getInstallers()
                                   break;
                               case "installerDownloaded":
                                   hasFinished = true;
                                   setPermission()
                                   break;
                               case "permissionSet":
                                   hasFinished = true;
                                   runInstallers()
                                   break;
                              case "installerFinished":
                                  hasFinished = true
                                  //mainInstallerDrawer.close();
                                  break;
                            }
                       }
                   }
                   //onTerminalUsesMouseChanged: console.log(terminalUsesMouse);
                   //onTerminalSizeChanged: console.log(terminalSize);
                   Component.onCompleted: {}

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
    }
