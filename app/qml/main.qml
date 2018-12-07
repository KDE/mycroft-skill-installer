import QtQuick 2.9
import QtQml.Models 2.3
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.4 as Kirigami
import QtGraphicalEffects 1.0
import QMLTermWidget 1.0
import FileReader 1.0

Kirigami.ApplicationWindow {
    id: window
    visible: true
    pageStack.initialPage: mainPageComponent
    property string currentPos
    property var currentURL
    property var orignalFolder
    property var skillFolderName
    property bool hasOrginal

    function delay(delayTime, cb) {
        delayTimer.interval = delayTime;
        delayTimer.repeat = false;
        delayTimer.triggered.connect(cb);
        delayTimer.start();
    }

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

    footer: Item {
        anchors.left: parent.left
        anchors.right: parent.right
        height: Kirigami.Units.gridUnit * 2.4

        Kirigami.Separator {
            id: footerSeparator
            anchors.left: parent.left
            anchors.right: parent.right
        }

        Rectangle {
            anchors.top: footerSeparator.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            color: "#211e1e"

            RowLayout{
                anchors.fill: parent

                Button {
                    id: refreshButton
                    Layout.preferredWidth: parent.width
                    Layout.fillHeight: true
                    anchors.margins: Kirigami.Units.smallSpacing
                    text: "Refresh"
                    onClicked: {
                        skillCheckModel.clear()
                        getSkillStatus()
                        refreshButton.focus = false
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        getSkillStatus()
    }

    FileReader {
        id: fileReader
    }

    Timer {
        id: delayTimer
    }

    ListModel {
        id: skillCheckModel
    }

    function getSkillStatus(){
        var doc = new XMLHttpRequest()
        doc.open("GET", "https://raw.githubusercontent.com/AIIX/gui-skills/master/skillsNewApi.json", true);
        doc.send();

        doc.onreadystatechange = function() {
            if (doc.readyState === XMLHttpRequest.DONE) {
                skillCheckModel.clear()
                var tempRes = doc.responseText
                var checkModel = JSON.parse(tempRes)
                var skillsCount = checkModel.skills.length;
                for (var i=0; i < skillsCount; i++){
                    var defaultFold = '/opt/mycroft/skills'
                    var skillPath = defaultFold + "/" + checkModel.skills[i].skillname + "." + checkModel.skills[i].authorname
                    if(fileReader.file_exists_local(skillPath)){
                        skillCheckModel.append({displayName: checkModel.skills[i].name, skillName: checkModel.skills[i].skillname, authorName: checkModel.skills[i].authorname, folderName: checkModel.skills[i].foldername, skillUrl: checkModel.skills[i].url, skillInstalled: true})
                    }
                    else {
                        skillCheckModel.append({displayName: checkModel.skills[i].name, skillName: checkModel.skills[i].skillname, authorName: checkModel.skills[i].authorname, folderName: checkModel.skills[i].foldername, skillUrl: checkModel.skills[i].url, skillInstalled: false})
                    }
                }
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
        var getinstallersarg = ["-c", "wget https://raw.githubusercontent.com/AIIX/gui-skills/master/newskiller.sh -P /tmp"]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        currentPos = "installerDownloaded"
    }

    function setPermission(){
        mainsession.hasFinished = false
        currentPos = ""
        var getinstallersarg = ["-c", "chmod a+x /tmp/newskiller.sh"]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        currentPos = "permissionSet"
    }

    function runInstallers(){
        mainsession.hasFinished = false
        currentPos = ""
        var getinstallersarg = ["-c", "/tmp/newskiller.sh" + ' ' + currentURL + ' ' + orignalFolder]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        currentPos = "installerFinished"
    }


    function cleanRemover(){
        mainsession.hasFinished = false
        currentPos = ""
        var cleaninstallerfiles = ["-c", "rm -rf /tmp/remover.sh"]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(cleaninstallerfiles)
        mainsession.startShellProgram();
        currentPos = "cleanRemoverCompleted"
    }

    function getRemovers(){
        mainsession.hasFinished = false
        currentPos = ""
        var getinstallersarg = ["-c", "wget https://raw.githubusercontent.com/AIIX/gui-skills/master/remover.sh -P /tmp"]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        currentPos = "removerDownloaded"
    }

    function setPermissionRemover(){
        mainsession.hasFinished = false
        currentPos = ""
        var getinstallersarg = ["-c", "chmod a+x /tmp/remover.sh"]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        currentPos = "permissionSetRemover"
    }

    function runRemover(){
        mainsession.hasFinished = false
        currentPos = ""
        var getinstallersarg = ["-c", "/tmp/remover.sh" + ' ' + orignalFolder + ' ' + skillFolderName]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        currentPos = "removerFinished"
    }

    Kirigami.ScrollablePage{
        id: mainPageComponent
        title: "Mycroft Skill Installer"

        Kirigami.CardsListView {
            id: listView
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing:  5
            model: skillCheckModel

            delegate: Kirigami.AbstractCard {
                contentItem: Item {
                    implicitWidth: parent.width
                    implicitHeight: skillNameLabel.height

                    Label{
                        id: skillNameLabel
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.right: btnRect.left
                        anchors.margins: 12
                        text: model.displayName
                        font.pointSize: 10
                        color: Kirigami.Theme.textColor
                    }

                    Button {
                        id: btnRect
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        width: Kirigami.Units.gridUnit * 4.5
                        height: Kirigami.Units.gridUnit * 2
                        text: model.skillInstalled ? "Remove" : "Install"
                        onClicked: {
                            if(model.folderName !== ""){
                                hasOrginal = true
                                skillFolderName = model.folderName
                                console.log(skillFolderName)
                            }
                            else{
                                hasOrginal = false
                                skillFolderName = model.skillName + "." + model.authorName
                                console.log(skillFolderName)
                            }
                            currentURL = model.skillUrl
                            orignalFolder = model.folderName
                            mainInstallerDrawer.open()

                            if(!model.skillInstalled){
                                cleanInstaller()
                            }
                            else{
                                cleanRemover()
                            }
                        }

                    }
                }
            }
            onModelChanged: {
                listView.update()
            }
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
                            //InstallerLogic
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
                            getSkillStatus()
                            delay(4000, function() {
                                mainInstallerDrawer.close()
                            })
                            break;
                            //RemoverLogic
                        case "cleanRemoverCompleted":
                            hasFinished = true
                            getRemovers()
                            break;
                        case "removerDownloaded":
                            hasFinished = true
                            setPermissionRemover()
                            break;
                        case "permissionSetRemover":
                            hasFinished = true
                            runRemover()
                            break;
                        case "removerFinished":
                            hasFinished = true
                            getSkillStatus()
                            delay(4000, function() {
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
