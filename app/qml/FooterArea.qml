import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
import org.kde.kirigami 2.12 as Kirigami
import org.kde.plasma.components 3.0 as PlasmaComponents3

import "code/SkillUtils.js" as SkillUtils

Item {
    anchors.left: parent.left
    anchors.right: parent.right
    height: Kirigami.Units.gridUnit * 2.4

    onFocusChanged: {
        if(focus){
            refreshButton.forceActiveFocus()
        }
    }

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

        PlasmaComponents3.Button {
            id: refreshButton
            anchors.fill: parent

            contentItem: Item {
                RowLayout {
                    anchors.centerIn: parent
                    Kirigami.Icon {
                        Layout.preferredWidth: Kirigami.Units.iconSizes.small
                        Layout.preferredHeight: Kirigami.Units.iconSizes.small
                        Layout.alignment: Qt.AlignHCenter
                        source: "refactor"
                    }
                    Label {
                        text: "Refresh"
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            onClicked: {
                installerView.updateXMLModel()
            }
            KeyNavigation.up: installerView
            Keys.onReturnPressed: {
                clicked()
            }
        }
    }
}
