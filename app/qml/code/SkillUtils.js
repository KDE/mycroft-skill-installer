function delay(delayTime, cb) {
    delayTimer.interval = delayTime;
    delayTimer.repeat = false;
    delayTimer.triggered.connect(cb);
    delayTimer.start();
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
                lview.model = xmlModel
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
            var skillPath = defaultFold + "/" + checkModel.skillname + "." + checkModel.authorname
            if (checkModel.platforms){
                skillPlatforms = checkModel.platforms
            } else {
                skillPlatforms = ["all"]
            }
            if(fileReader.file_exists_local(skillPath)){
                skillObj = {itemDescription: description, itemPreviewPic: previewpic1, itemInstallStatus: true, displayName: checkModel.name, skillName: checkModel.skillname, authorName: checkModel.authorname, folderName: checkModel.foldername, skillUrl: checkModel.url, skillInstalled: true, branch: checkModel.branch, skillFolderPath: skillPath, warning: checkModel.warning, desktopFile: checkModel.desktopFile, examples: checkModel.examples, platforms: skillPlatforms, systemDeps: checkModel.systemDeps}
                skillInfo = skillObj
            }
            else {
                skillObj = {itemDescription: description, itemPreviewPic: previewpic1, itemInstallStatus: false, displayName: checkModel.name, skillName: checkModel.skillname, authorName: checkModel.authorname, folderName: checkModel.foldername, skillUrl: checkModel.url, skillInstalled: false, branch: checkModel.branch, skillFolderPath: skillPath, warning: checkModel.warning, desktopFile: checkModel.desktopFile, examples: checkModel.examples, platforms: skillPlatforms, systemDeps: checkModel.systemDeps}
                skillInfo = skillObj
            }
        }
    }
}
