import QtQuick
import qs.modules.common

FocusScope {
    id: root

    property string text: ""
    property bool selected: false
    readonly property bool hovered: mouse.containsMouse

    signal clicked

    activeFocusOnTab: false
    implicitWidth: label.implicitWidth
    implicitHeight: Theme.metrics.hitArea
    width: implicitWidth
    height: implicitHeight

    NovaText {
        id: label
        anchors.verticalCenter: parent.verticalCenter
        text: root.text
        role: "action"
        font.letterSpacing: 0
        font.weight: Font.Normal
        color: !root.enabled ? Theme.color.textMuted : root.selected ? Theme.color.actionPrimary : root.hovered ? Theme.color.actionPrimaryHover : Theme.color.textPrimary

        Behavior on color {
            ColorAnimation {
                duration: Theme.motion.fast
            }
        }
    }

    Rectangle {
        anchors.top: label.bottom
        anchors.topMargin: 2
        width: label.width
        height: 2
        color: Theme.color.actionPrimary
        visible: root.selected
    }

    NovaFocusRing {
        active: root.activeFocus && root.enabled
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.enabled
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
