import QtQuick
import qs.modules.common

FocusScope {
    id: root

    property string iconName: ""
    property string title: ""
    property string subtitle: ""
    property string tag: ""
    property bool monospace: false
    property bool highlighted: false
    readonly property bool hovered: mouse.containsMouse

    signal activated

    implicitHeight: Theme.metrics.controlHeight + Theme.metrics.gap
    implicitWidth: 360
    width: implicitWidth
    height: implicitHeight

    Rectangle {
        anchors.fill: parent
        color: root.highlighted ? Theme.color.actionPrimary : root.hovered ? Theme.color.bgHover : "transparent"

        Behavior on color {
            ColorAnimation {
                duration: Theme.motion.fast
            }
        }
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: Theme.metrics.padding
        anchors.rightMargin: Theme.metrics.padding
        spacing: Theme.metrics.padding

        NovaAppIcon {
            anchors.verticalCenter: parent.verticalCenter
            size: 28
            source: root.iconName
            fallback: "application-x-executable"
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - 28 - tagText.implicitWidth - Theme.metrics.padding * 2

            NovaText {
                width: parent.width
                text: root.title
                role: root.monospace ? "mono" : "label"
                elide: Text.ElideRight
                color: root.highlighted ? Theme.color.actionOnPrimary : Theme.color.textPrimary
            }

            NovaText {
                width: parent.width
                visible: text.length > 0
                text: root.subtitle
                role: "mono"
                elide: Text.ElideRight
                color: root.highlighted ? Theme.color.actionOnPrimary : Theme.color.textSecondary
            }
        }

        NovaText {
            id: tagText
            anchors.verticalCenter: parent.verticalCenter
            text: root.tag
            role: "caption"
            color: root.highlighted ? Theme.color.actionOnPrimary : Theme.color.textMuted
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.activated()
    }
}
