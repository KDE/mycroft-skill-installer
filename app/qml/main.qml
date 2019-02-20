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
    // @disable-check M17
    pageStack.initialPage: mainPageComponent
    property string currentPos
    property var currentURL
    property var orignalFolder
    property var skillFolderName
    property var skillFolder
    property var branch
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
                        skillCheckModel.append({displayName: checkModel.skills[i].name, skillName: checkModel.skills[i].skillname, authorName: checkModel.skills[i].authorname, folderName: checkModel.skills[i].foldername, skillUrl: checkModel.skills[i].url, skillInstalled: true, branch: checkModel.skills[i].branch, skillFolderPath: skillPath, warning: checkModel.skills[i].warning})
                    }
                    else {
                        skillCheckModel.append({displayName: checkModel.skills[i].name, skillName: checkModel.skills[i].skillname, authorName: checkModel.skills[i].authorname, folderName: checkModel.skills[i].foldername, skillUrl: checkModel.skills[i].url, skillInstalled: false, branch: checkModel.skills[i].branch, skillFolderPath: skillPath, warning: checkModel.skills[i].warning})
                    }
                }
            }
        }
    }
    
    function cleanInstaller(){
        mainsession.hasFinished = false
        currentPos = ""
        var cleaninstallerfiles = ["-c", "rm -rf /tmp/newskiller.sh"]
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

    function cleanBranchInstaller(){
        mainsession.hasFinished = false
        currentPos = ""
        var cleaninstallerfiles = ["-c", "rm -rf /tmp/brancher.sh"]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(cleaninstallerfiles)
        mainsession.startShellProgram();
        currentPos = "cleanBranchInstallerCompleted"
    }

    function getBranchInstaller(){
        mainsession.hasFinished = false
        currentPos = ""
        var getinstallersarg = ["-c", "wget https://raw.githubusercontent.com/AIIX/gui-skills/master/brancher.sh -P /tmp"]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        currentPos = "branchInstallerDownloaded"
    }

    function setPermissionBranchInstaller(){
        mainsession.hasFinished = false
        currentPos = ""
        var getinstallersarg = ["-c", "chmod a+x /tmp/brancher.sh"]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        currentPos = "branchPermissionSet"
    }

    function runBranchInstallers(){
        mainsession.hasFinished = false
        currentPos = ""
        console.log("branch:" + branch)
        var getinstallersarg = ["-c", "/tmp/brancher.sh" + ' ' + skillFolder + ' ' + branch]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        currentPos = "branchInstallerFinished"
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

                    RowLayout {
                        anchors.fill:  parent

                        ColumnLayout{
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignLeft

                            Kirigami.Heading {
                                id: skillNameLabel
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignTop
                                text: model.displayName
                                level: 3
                                color: Kirigami.Theme.textColor
                            }
                            Label {
                                id: skillWarningLabel
                                text: "Note: " + model.warning
                                color: Kirigami.Theme.linkColor
                                visible: !model.warning ? false : true
                            }
                        }

                        Label {
                            id: skillBranchLabel
                            text: "Branch: " + model.branch
                            color: Kirigami.Theme.textColor
                        }

                        Button {
                            id: btnRect
                            Layout.preferredHeight: Kirigami.Units.gridUnit * 2
                            Layout.preferredWidth: Kirigami.Units.gridUnit * 4.5
                            Layout.alignment: Qt.AlignRight
                            text: model.skillInstalled ? "Remove" : "Install"
                            onClicked: {
                                window.branch = model.branch
                                console.log(branch)
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
                                skillFolder = model.skillFolderPath
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
                            cleanBranchInstaller()
                            break;
                        case "cleanBranchInstallerCompleted":
                            hasFinished = true
                            getBranchInstaller()
                            break;
                        case "branchInstallerDownloaded":
                            hasFinished = true
                            setPermissionBranchInstaller()
                            break;
                        case "branchPermissionSet":
                            hasFinished = true
                            runBranchInstallers()
                            break;
                        case "branchInstallerFinished":
                            hasFinished = true
                            getSkillStatus()
                            delay(4000, function() {
                                //mainInstallerDrawer.close()
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
                                //mainInstallerDrawer.close()
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
