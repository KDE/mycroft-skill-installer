import QtQuick 2.9
import org.kde.kirigami 2.12 as Kirigami
import FileReader 1.0

Kirigami.ApplicationWindow {
    id: window
    visibility: "Maximized"
    color: Qt.rgba(0,0,0,0)

    header: HeaderArea{
        id: headerArea
    }
    footer: FooterArea{
        id: footerArea
    }

    // @disable-check M17
    pageStack.initialPage: InstallerView{
        id: installerView
    }

    FileReader {
        id: fileReader
    }

    Timer {
        id: delayTimer
    }

    ListModel {
        id: informationListModel
    }

    InformationModel {
        id: informationModel
    }

    Component.onCompleted: {
        installerView.updateXMLModel()
        installerView.skillView.forceActiveFocus()
    }
}
