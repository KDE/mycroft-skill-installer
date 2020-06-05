import QtQuick 2.9
import org.kde.kirigami 2.12 as Kirigami
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    property var currentURL
    property var orignalFolder
    property var skillFolderName
    property var skillFolder
    property var branch
    property bool hasOrginal
    property bool hasSystemDeps
    property var supportedPlatforms
    property bool hasDesktopFile
    property Component highlighter: PlasmaComponents.Highlight{}
    property Component emptyHighlighter: Item{}
    property string categoryURL: "https://api.kde-look.org/ocs/v1/content/data?categories=608"
    property var jlist: []
    property var fntSize: Kirigami.Units.gridUnit * 2
    signal skillModelChanged
}