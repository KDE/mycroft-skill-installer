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
    for (n=0; n < xmlModel.count; n++) {
        sortModel.append({"typename": xmlModel.get(n).typename, "name": xmlModel.get(n).name, "description": xmlModel.get(n).description, "downloadlink1": xmlModel.get(n).downloadlink1, "previewpic1": xmlModel.get(n).previewpic1, "personid": xmlModel.get(n).personid, "id": xmlModel.get(n).id, "downloads": xmlModel.get(n).downloads})
    }
}

function getSkills(){
    var xhr = new XMLHttpRequest()
    var url = informationModel.categoryURL //'https://api.kde-look.org/ocs/v1/content/data?categories=608' ;
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
                //lview.model = xmlModel
            }
            else
            {
                item.error();
            }
        }
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
            var skillObj = {}
            var skillPlatforms = []
            var skillAuthorName = checkModel.authorname.toLowerCase()
            var systemDeps = false
            var skillPath = defaultFold + "/" + checkModel.skillname + "." + skillAuthorName
            if (checkModel.platforms){
                skillPlatforms = checkModel.platforms
            } else {
                skillPlatforms = ["all"]
            }

            if (checkModel.systemDeps === true || checkModel.systemDeps === "true") {
                systemDeps = true
            } else if (checkModel.systemDeps === false || checkModel.systemDeps === "false") {
                systemDeps = false
            } else {
                systemDeps = false
            }

            if(fileReader.file_exists_local(skillPath)){
                skillObj = {itemDescription: description, itemPreviewPic: previewpic1, itemInstallStatus: true, displayName: checkModel.name, skillName: checkModel.skillname, authorName: skillAuthorName, folderName: checkModel.foldername, skillUrl: checkModel.url, skillInstalled: true, branch: checkModel.branch, skillFolderPath: skillPath, warning: checkModel.warning, desktopFile: checkModel.desktopFile, examples: checkModel.examples, platforms: skillPlatforms, systemDeps: systemDeps}
                skillInfo = skillObj
            }
            else {
                skillObj = {itemDescription: description, itemPreviewPic: previewpic1, itemInstallStatus: false, displayName: checkModel.name, skillName: checkModel.skillname, authorName: skillAuthorName, folderName: checkModel.foldername, skillUrl: checkModel.url, skillInstalled: false, branch: checkModel.branch, skillFolderPath: skillPath, warning: checkModel.warning, desktopFile: checkModel.desktopFile, examples: checkModel.examples, platforms: skillPlatforms, systemDeps: systemDeps}
                skillInfo = skillObj
            }
        }
    }
}
