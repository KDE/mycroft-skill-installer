import QtQuick 2.9
import QtQml.Models 2.3
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.11 as Kirigami
import org.kde.plasma.components 2.0 as PlasmaComponents
import QtGraphicalEffects 1.0
import QtQuick.XmlListModel 2.13
import QMLTermWidget 1.0
import FileReader 1.0

import "delegates" as Delegates
import "views" as Views

Kirigami.ApplicationWindow {
    id: window
    visibility: "Maximized"
    // @disable-check M17
    pageStack.initialPage: mainPageComponent
    color: Qt.rgba(0,0,0,0)
    property string currentPos
    property var currentURL
    property var orignalFolder
    property var skillFolderName
    property var skillFolder
    property var branch
    property bool hasOrginal
    property bool hasDesktopFile
    property Component highlighter: PlasmaComponents.Highlight{}
    property Component emptyHighlighter: Item{}
    property var jlist: []
    signal skillModelChanged

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
        height: window.width >= 1500 ? 150 : 30
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
                        //xmlModel.reload()
                        getSkills()
                    }
                    KeyNavigation.up: lview
                    Keys.onReturnPressed: {
                        //xmlModel.reload()
                        getSkills()
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        getSkills()
        lview.forceActiveFocus()
    }

    FileReader {
        id: fileReader
    }

    Timer {
        id: delayTimer
    }

    function initInstallation(){
        pBar.value = 0
        window.branch = lview.mbranch
        console.log(branch)
        if(lview.mfolderName !== ""){
            hasOrginal = true
            skillFolderName = lview.mfolderName
            console.log(skillFolderName)
        } else {
            hasOrginal = false
            skillFolderName = lview.mskillName + "." + lview.mauthorName
            console.log(skillFolderName)
        }

        if(lview.mdesktopFile){
            hasDesktopFile = true
        } else {
            hasDesktopFile = false
        }

        currentURL = lview.mskillUrl
        orignalFolder = lview.mfolderName
        skillFolder = lview.mskillFolderPath
        mainInstallerDrawer.open()

        if(!lview.mskillInstalled){
            cleanInstaller()
        }
        else{
            cleanRemover()
        }
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
                    skillObj = {displayName: checkModel.name, skillName: checkModel.skillname, authorName: checkModel.authorname, folderName: checkModel.foldername, skillUrl: checkModel.url, skillInstalled: true, branch: checkModel.branch, skillFolderPath: skillPath, warning: checkModel.warning, desktopFile: checkModel.desktopFile}
                    return skillObj
                }
                else {
                    console.log("false")
                    skillObj = {displayName: checkModel.name, skillName: checkModel.skillname, authorName: checkModel.authorname, folderName: checkModel.foldername, skillUrl: checkModel.url, skillInstalled: false, branch: checkModel.branch, skillFolderPath: skillPath, warning: checkModel.warning, desktopFile: checkModel.desktopFile}
                    return skillObj
                }
            }
        }
    }

    function getSkills(){
        var xhr = new XMLHttpRequest()
        var url = 'https://api.kde-look.org/ocs/v1/content/data?categories=415' ;
        xhr.open("GET",url,true);
        xhr.setRequestHeader('Content-Type',  'application/xml');
        xhr.send();

        xhr.onreadystatechange = function()
        {
            if ( xhr.readyState == xhr.DONE )
            {
                if ( xhr.status == 200 )
                {
                    var a = xhr.responseXML.documentElement;
                    xmlModel.xml = xhr.responseText
                    lview.model = xmlModel
                }
                else
                {
                    item.error();
                }
            }
        }
    }
    
    function cleanInstaller(){
        installStep.text = "INFO - Cleaning Installer"
        pBar.value = 0.1
        mainsession.hasFinished = false
        currentPos = ""
        var cleaninstallerfiles = ["-c", "rm -rf /tmp/newskiller.sh"]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(cleaninstallerfiles)
        mainsession.startShellProgram();
        currentPos = "cleanInstallerCompleted"
    }

    function getInstallers(){
        installStep.text = "INFO - Getting Installer"
        pBar.value = 0.2
        mainsession.hasFinished = false
        currentPos = ""
        var getinstallersarg = ["-c", "wget https://raw.githubusercontent.com/AIIX/gui-skills/master/newskiller.sh -P /tmp"]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        currentPos = "installerDownloaded"
    }

    function setPermission(){
        installStep.text = "INFO - Setting Installer Permissions"
        pBar.value = 0.3
        mainsession.hasFinished = false
        currentPos = ""
        var getinstallersarg = ["-c", "chmod a+x /tmp/newskiller.sh"]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        currentPos = "permissionSet"
    }

    function runInstallers(){
        installStep.text = "INFO - Running Installer"
        pBar.value = 0.4
        console.log(currentURL)
        mainsession.hasFinished = false
        currentPos = ""
        var getinstallersarg = ["-c", "/tmp/newskiller.sh" + ' ' + currentURL + ' ' + orignalFolder]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        currentPos = "installerFinished"
    }

    function cleanBranchInstaller(){
        installStep.text = "INFO - Cleaning Branch Installer"
        pBar.value = 0.5
        mainsession.hasFinished = false
        currentPos = ""
        var cleaninstallerfiles = ["-c", "rm -rf /tmp/brancher.sh"]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(cleaninstallerfiles)
        mainsession.startShellProgram();
        currentPos = "cleanBranchInstallerCompleted"
    }

    function getBranchInstaller(){
        installStep.text = "INFO - Getting Branch Installer"
        pBar.value = 0.6
        mainsession.hasFinished = false
        currentPos = ""
        var getinstallersarg = ["-c", "wget https://raw.githubusercontent.com/AIIX/gui-skills/master/brancher.sh -P /tmp"]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        currentPos = "branchInstallerDownloaded"
    }

    function setPermissionBranchInstaller(){
        installStep.text = "INFO - Setting Branch Installer Permissions"
        pBar.value = 0.7
        mainsession.hasFinished = false
        currentPos = ""
        var getinstallersarg = ["-c", "chmod a+x /tmp/brancher.sh"]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        currentPos = "branchPermissionSet"
    }

    function runBranchInstallers(){
        installStep.text = "INFO - Running Branch Installer"
        mainsession.hasFinished = false
        currentPos = ""
        console.log("branch:" + branch)
        var getinstallersarg = ["-c", "/tmp/brancher.sh" + ' ' + skillFolder + ' ' + branch]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        if(hasDesktopFile){
            pBar.value = 0.8
            currentPos = "installDesktopFile"
        } else {
            pBar.value = 1
            currentPos = "branchInstallerFinished"
        }
    }

    function cleanDesktopFileInstaller(){
        installStep.text = "INFO - Cleaning DesktopFile Installer"
        pBar.value = 0.9
        mainsession.hasFinished = false
        currentPos = ""
        var cleaninstallerfiles = ["-c", "rm -rf /tmp/desktopFileInstaller.sh"]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(cleaninstallerfiles)
        mainsession.startShellProgram();
        currentPos = "cleanDesktopInstallerCompleted"
    }

    function getDesktopFileInstaller(){
        installStep.text = "INFO - Getting DesktopFile Installer"
        pBar.value = 0.9
        mainsession.hasFinished = false
        currentPos = ""
        var getinstallersarg = ["-c", "wget https://raw.githubusercontent.com/AIIX/gui-skills/master/desktopFileInstaller.sh -P /tmp"]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        currentPos = "desktopFileInstallerDownloaded"
    }

    function setPermissionDesktopFileInstaller() {
        installStep.text = "INFO - Setting DesktopFile Installer Permissions"
        pBar.value = 0.95
        mainsession.hasFinished = false
        currentPos = ""
        var getinstallersarg = ["-c", "chmod a+x /tmp/desktopFileInstaller.sh"]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        currentPos = "desktopFilePermissionSet"
    }

    function runDesktopFileInstallers(){
        installStep.text = "INFO - Running DesktopFile Installer"
        pBar.value = 0.98
        mainsession.hasFinished = false
        currentPos = ""
        var getinstallersarg = ["-c", "/tmp/desktopFileInstaller.sh" + ' ' + skillFolder]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        currentPos = "desktopFileInstallerFinished"
    }

    function cleanRemover(){
        installStep.text = "INFO - Cleaning Uninstaller"
        pBar.value = 0.25
        mainsession.hasFinished = false
        currentPos = ""
        var cleaninstallerfiles = ["-c", "rm -rf /tmp/remover.sh"]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(cleaninstallerfiles)
        mainsession.startShellProgram();
        currentPos = "cleanRemoverCompleted"
    }

    function getRemovers(){
        installStep.text = "INFO - Getting Uninstaller"
        pBar.value = 0.5
        mainsession.hasFinished = false
        currentPos = ""
        var getinstallersarg = ["-c", "wget https://raw.githubusercontent.com/AIIX/gui-skills/master/remover.sh -P /tmp"]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        currentPos = "removerDownloaded"
    }

    function setPermissionRemover(){
        installStep.text = "INFO - Setting Uninstaller Permissions"
        pBar.value = 0.75
        mainsession.hasFinished = false
        currentPos = ""
        var getinstallersarg = ["-c", "chmod a+x /tmp/remover.sh"]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        currentPos = "permissionSetRemover"
    }

    function runRemover(){
        installStep.text = "INFO - Running Uninstaller"
        pBar.value = 1
        mainsession.hasFinished = false
        currentPos = ""
        var getinstallersarg = ["-c", "/tmp/remover.sh" + ' ' + orignalFolder + ' ' + skillFolderName]
        mainsession.setShellProgram("bash");
        mainsession.setArgs(getinstallersarg)
        mainsession.startShellProgram();
        currentPos = "removerFinished"
    }

    Kirigami.Page{
        id: mainPageComponent
        title: "Mycroft Skills Installer"
        background: Rectangle {
            color: Qt.rgba(0,0,0,0.5)
        }

        XmlListModel {
            id: xmlModel
            query: "/ocs/data/content"
            XmlRole { name: "id"; query: "id/string()" }
            XmlRole { name: "name"; query: "name/string()" }
            XmlRole { name: "description"; query: "description/string()" }
            XmlRole { name: "downloadlink1"; query: "downloadlink1/string()" }
            XmlRole { name: "previewpic1"; query: "previewpic1/string()" }
        }

        ColumnLayout {
            anchors.fill: parent

            Views.TileView {
                id: lview
                clip: true
                focus: true
                highlight: focus ? highlighter : emptyHighlighter
                highlightMoveDuration: 0
                //anchors.fill: parent
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
                property int lastIndex

                delegate: Delegates.TileDelegate {
                }

                onModelChanged: {
                    lview.update()
                    lview.currentIndex = 0
                }

                function setItem() {
                    if(lview.currentItem.skillInfo){
                        mbranch = lview.currentItem.skillInfo.branch
                        mfolderName = lview.currentItem.skillInfo.folderName
                        mskillName = lview.currentItem.skillInfo.skillName
                        mauthorName = lview.currentItem.skillInfo.authorName
                        mskillUrl = lview.currentItem.skillInfo.skillUrl
                        mskillFolderPath = lview.currentItem.skillInfo.skillFolderPath
                        mdesktopFile = lview.currentItem.skillInfo.desktopFile
                        mskillInstalled = lview.currentItem.skillInfo.skillInstalled
                    }
                }

                Keys.onReturnPressed: {
                    setItem()
                    initInstallation()
                }
                KeyNavigation.down: refreshButton
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

        ColumnLayout {
            anchors.fill: parent

            Rectangle {
                id: pBarRect
                visible: true
                color: Kirigami.Theme.backgroundColor
                Layout.fillWidth: true
                Layout.preferredHeight: Kirigami.Units.gridUnit * 4

                PlasmaComponents.Label {
                    id: installStep
                    visible: text.length > 0
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
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: Kirigami.Units.largeSpacing
                    anchors.rightMargin: Kirigami.Units.largeSpacing
                    anchors.verticalCenter: parent.verticalCenter
                    height: Kirigami.Units.gridUnit * 2
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
                //Layout.alignment: Qt.AlignBottom
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
                                //getSkillStatus()
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
                                installStep.text = "INFO - Installation Completed"
                                xmlModel.reload()
                                getSkills()
                                delay(4000, function() {
                                    mainInstallerDrawer.close()
                                })
                                break;
                            case "installDesktopFile":
                                hasFinished = true
                                cleanDesktopFileInstaller()
                                break;
                            case "cleanDesktopInstallerCompleted":
                                hasFinished = true
                                getDesktopFileInstaller()
                                break;
                            case "desktopFileInstallerDownloaded":
                                hasFinished = true
                                setPermissionDesktopFileInstaller()
                                break;
                            case "desktopFilePermissionSet":
                                hasFinished = true
                                runDesktopFileInstallers();
                                break;
                            case "desktopFileInstallerFinished":
                                hasFinished = true
                                installStep.text = "INFO - Installation Completed"
                                xmlModel.reload()
                                getSkills()
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
                                installStep.text = "INFO - Uninstall Completed"
                                xmlModel.reload()
                                getSkills()
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
}
