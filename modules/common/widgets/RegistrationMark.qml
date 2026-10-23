import QtQuick
import qs.modules.common

Item {
    id: root

    property real size: Theme.metrics.markSize
    property color color: Theme.color.borderControl
    property real thickness: 1

    implicitWidth: size
    implicitHeight: size
    width: implicitWidth
    height: implicitHeight

    Rectangle {
        anchors.centerIn: parent
        width: root.size
        height: root.thickness
        color: root.color
    }

    Rectangle {
        anchors.centerIn: parent
        width: root.thickness
        height: root.size
        color: root.color
    }
}
