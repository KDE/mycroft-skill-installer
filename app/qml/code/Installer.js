function initInstallation(){
    pBar.value = 0
    informationModel.branch = lview.mbranch
    console.log(informationModel.branch)
    if(lview.mfolderName !== ""){
        informationModel.hasOrginal = true
        informationModel.skillFolderName = lview.mfolderName
        console.log(informationModel.skillFolderName)
    } else {
        informationModel.hasOrginal = false
        informationModel.skillFolderName = lview.mskillName + "." + lview.mauthorName
        console.log(informationModel.skillFolderName)
    }

    if(lview.mdesktopFile){
        informationModel.hasDesktopFile = true
    } else {
        informationModel.hasDesktopFile = false
    }

    informationModel.currentURL = lview.mskillUrl
    informationModel.orignalFolder = lview.mfolderName
    informationModel.skillFolder = lview.mskillFolderPath
    mainInstallerDrawer.open()

    if(!lview.mskillInstalled){
        if (!lview.mSystemDeps) {
            cleanInstaller()
        } else {
            cleanSysDepInstaller()
        }
    }
    else{
        cleanRemover()
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

function cleanSysDepInstaller(){
    installStep.text = "INFO - Cleaning Installer"
    pBar.value = 0.1
    mainsession.hasFinished = false
    currentPos = ""
    var cleaninstallerfiles = ["-c", "rm -rf /tmp/alternativeskiller.sh"]
    mainsession.setShellProgram("bash");
    mainsession.setArgs(cleaninstallerfiles)
    mainsession.startShellProgram();
    var cleaninstallerfiles2 = ["-c", "rm -rf /tmp/systemDepsInstall.sh"]
    mainsession.setShellProgram("bash");
    mainsession.setArgs(cleaninstallerfiles2)
    mainsession.startShellProgram();
    var cleaninstallerfiles3 = ["-c", "rm -rf /tmp/handle_sys_deps.py"]
    mainsession.setShellProgram("bash");
    mainsession.setArgs(cleaninstallerfiles3)
    mainsession.startShellProgram();
    currentPos = "cleanInstallerCompleted"
}

function getInstallers() {
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

function getSysDepInstaller(){
    installStep.text = "INFO - Getting Installer"
    pBar.value = 0.2
    mainsession.hasFinished = false
    currentPos = ""
    var getinstallersarg = ["-c", "wget https://raw.githubusercontent.com/AIIX/gui-skills/master/systemDepsInstall.sh -P /tmp"]
    mainsession.setShellProgram("bash");
    mainsession.setArgs(getinstallersarg)
    mainsession.startShellProgram();
    var getinstallersarg2 = ["-c", "wget https://raw.githubusercontent.com/AIIX/gui-skills/master/handle_sys_deps.py -P /tmp"]
    mainsession.setShellProgram("bash");
    mainsession.setArgs(getinstallersarg2)
    var getinstallersarg3 = ["-c", "wget https://raw.githubusercontent.com/AIIX/gui-skills/master/alternativeskiller.sh -P /tmp"]
    mainsession.setShellProgram("bash");
    mainsession.setArgs(getinstallersarg3)
    mainsession.startShellProgram();
    currentPos = "installerDownloaded"
}

function setPermission() {
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

function setPermissionSysDepInstaller(){
    installStep.text = "INFO - Setting Installer Permissions"
    pBar.value = 0.3
    mainsession.hasFinished = false
    currentPos = ""
    var getinstallersarg = ["-c", "chmod a+x /tmp/systemDepsInstall.sh"]
    mainsession.setShellProgram("bash");
    mainsession.setArgs(getinstallersarg)
    mainsession.startShellProgram();
    var getinstallersarg2 = ["-c", "chmod a+x /tmp/alternativeskiller.sh"]
    mainsession.setShellProgram("bash");
    mainsession.setArgs(getinstallersarg2)
    mainsession.startShellProgram();
    var getinstallersarg3 = ["-c", "chmod a+x /tmp/handle_sys_deps.py"]
    mainsession.setShellProgram("bash");
    mainsession.setArgs(getinstallersarg3)
    mainsession.startShellProgram();
    currentPos = "permissionSet"
}

function runInstallers(){
    installStep.text = "INFO - Running Installer"
    pBar.value = 0.4
    mainsession.hasFinished = false
    currentPos = ""
    var getinstallersarg = ["-c", "/tmp/newskiller.sh" + ' ' + informationModel.currentURL + ' ' + informationModel.orignalFolder]
    mainsession.setShellProgram("bash");
    mainsession.setArgs(getinstallersarg)
    mainsession.startShellProgram();
    currentPos = "installerFinished"
}

function runSysDepInstallers(){
    installStep.text = "INFO - Running Installer"
    pBar.value = 0.4
    mainsession.hasFinished = false
    currentPos = ""
    var getinstallersarg = ["-c", "/tmp/alternativeskiller.sh" + ' ' + informationModel.currentURL + ' ' + informationModel.orignalFolder]
    mainsession.setShellProgram("bash");
    mainsession.setArgs(getinstallersarg)
    mainsession.startShellProgram();
    var getinstallersarg2 = ["-c", "/tmp/systemDepsInstall.sh" + ' ' + informationModel.skillFolderName]
    mainsession.setShellProgram("bash");
    mainsession.setArgs(getinstallersarg2)
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
    var getinstallersarg = ["-c", "/tmp/brancher.sh" + ' ' + informationModel.skillFolder + ' ' + informationModel.branch]
    mainsession.setShellProgram("bash");
    mainsession.setArgs(getinstallersarg)
    mainsession.startShellProgram();
    if(informationModel.hasDesktopFile){
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
    var getinstallersarg = ["-c", "/tmp/desktopFileInstaller.sh" + ' ' + informationModel.skillFolder]
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

    if(informationModel.hasDesktopFile){
        currentPos = "cleanRemoverOneCompleted"
    } else {
        currentPos = "cleanRemoverCompleted"
    }
}

function cleanRemoverTwo(){
    pBar.value = 0.25
    mainsession.hasFinished = false
    currentPos = ""
    var cleaninstallerfiles = ["-c", "rm -rf /tmp/removeDesktopFile.sh"]
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

    if(informationModel.hasDesktopFile){
        currentPos = "getRemoveDesktopFile"
    } else {
        pBar.value = 1
        currentPos = "permissionSetRemover"
    }
}

function getRemoveDesktopFile(){
    installStep.text = "INFO - Getting Desktop File Uninstaller"
    pBar.value = 0.5
    mainsession.hasFinished = false
    currentPos = ""
    var getinstallersarg = ["-c", "wget https://raw.githubusercontent.com/AIIX/gui-skills/master/removeDesktopFile.sh -P /tmp"]
    mainsession.setShellProgram("bash");
    mainsession.setArgs(getinstallersarg)
    mainsession.startShellProgram();
    currentPos = "setRemoveDesktopFilePerm"
}

function setRemoveDesktopFilePerm(){
    installStep.text = "INFO - Setting Uninstaller Permissions"
    pBar.value = 0.80
    mainsession.hasFinished = false
    currentPos = ""
    var getinstallersarg = ["-c", "chmod a+x /tmp/removeDesktopFile.sh"]
    mainsession.setShellProgram("bash");
    mainsession.setArgs(getinstallersarg)
    mainsession.startShellProgram();
    currentPos = "removerDesktopFilePermsSet"
}

function runRemoverDesktopFile(){
    installStep.text = "INFO - Remove Desktop File & Icon"
    pBar.value = 1
    mainsession.hasFinished = false
    currentPos = ""
    var getinstallersarg = ["-c", "/tmp/removeDesktopFile.sh" + ' ' + informationModel.orignalFolder + ' ' + informationModel.skillFolderName]
    mainsession.setShellProgram("bash");
    mainsession.setArgs(getinstallersarg)
    mainsession.startShellProgram();
    currentPos = "permissionSetRemover"
}

function runRemover(){
    installStep.text = "INFO - Running Uninstaller"
    pBar.value = 0.9
    mainsession.hasFinished = false
    currentPos = ""
    var getinstallersarg = ["-c", "/tmp/remover.sh" + ' ' + informationModel.orignalFolder + ' ' + informationModel.skillFolderName]
    mainsession.setShellProgram("bash");
    mainsession.setArgs(getinstallersarg)
    mainsession.startShellProgram();
    pBar.value = 1
    currentPos = "removerFinished"
}
