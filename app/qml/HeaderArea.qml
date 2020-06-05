import QtQuick 2.9
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Rectangle {
    id: headerRect
    anchors.left: parent.left
    anchors.right: parent.right
    height: 30
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
