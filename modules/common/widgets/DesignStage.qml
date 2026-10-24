import QtQuick

Item {
    id: root

    property real designWidth: 1920
    property real designHeight: 1080
    readonly property real factor: Math.min(width / designWidth, height / designHeight)
    default property alias content: stage.data

    Item {
        id: stage
        anchors.centerIn: parent
        width: root.designWidth
        height: root.designHeight
        scale: root.factor
    }
}
