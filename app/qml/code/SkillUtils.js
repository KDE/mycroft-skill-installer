var retryFetch = 0

function delay(delayTime, cb) {
    delayTimer.interval = delayTime;
    delayTimer.repeat = false;
    delayTimer.triggered.connect(cb);
    delayTimer.start();
}

function fillListModel()
{
    sortModel.clear()
    var n;
    var systemDeps = false;
    var skillPlatforms
    var warning = ""
    var examples
    for (n=0; n < modelInstaller.rowCount(); n++) {

        if (modelInstaller.get(n).systemDeps === true || modelInstaller.get(n).systemDeps === "true") {
            systemDeps = true
        } else if (modelInstaller.get(n).systemDeps === false || modelInstaller.get(n).systemDeps === "false") {
            systemDeps = false
        } else {
            systemDeps = false
        }

        if (modelInstaller.get(n).platforms){
            skillPlatforms = String(modelInstaller.get(n).platforms)
        } else {
            skillPlatforms = "all"
        }

        if (modelInstaller.get(n).warning){
            warning = modelInstaller.get(n).warning
        } else {
            warning = ""
        }

        if (modelInstaller.get(n).examples){
            examples = String(modelInstaller.get(n).examples)
        } else {
            examples = ""
        }

        sortModel.append({
         "id": modelInstaller.get(n).id,
         "name": modelInstaller.get(n).name,
         "description": modelInstaller.get(n).description,
         "downloadlink1": modelInstaller.get(n).downloadlink1,
         "previewpic1": modelInstaller.get(n).previewpic1,
         "typename": modelInstaller.get(n).typename,
         "personid": modelInstaller.get(n).personid,
         "downloads": modelInstaller.get(n).downloads,
         "itemInstallStatus": modelInstaller.get(n).itemInstallStatus,
         "itemUpdateStatus": modelInstaller.get(n).itemUpdateStatus,
         "url": modelInstaller.get(n).url,
         "branch": modelInstaller.get(n).branch,
         "warning": warning,
         "desktopFile": modelInstaller.get(n).desktopFile,
         "examples": examples,
         "platforms": skillPlatforms,
         "systemDeps": systemDeps,
         "authorname": modelInstaller.get(n).authorname,
         "skillname": modelInstaller.get(n).skillname,
         "foldername": modelInstaller.get(n).foldername
       })
    }
}

function populateSkillInfo()
{
    var defaultFold = '/opt/mycroft/skills'
    var skillAuthorName = authorname.toLowerCase()
    var skillPath = defaultFold + "/" + skillname + "." + personid
    var skillObj = {"itemDescription": description, "itemPreviewPic": previewpic1, "itemInstallStatus": itemInstallStatus, "displayName": name, "skillName": skillname.toLowerCase(), "authorName": authorname.toLowerCase(), "folderName": foldername, "skillUrl": url, "skillInstalled": itemInstallStatus, "branch": branch, "skillFolderPath": skillPath, "warning": warning, "desktopFile": desktopFile, "examples": examples, "platforms": platforms, "systemDeps": systemDeps, "itemUpdateStatus": itemUpdateStatus}
    skillInfo = skillObj
}
