import QtQuick
import qs.modules.common

FocusScope {
    id: root

    property string text: ""
    property string variant: "primary"
    property bool large: false
    property bool keyPressed: false

    readonly property bool hovered: mouse.containsMouse
    readonly property bool pressed: mouse.pressed || keyPressed
    readonly property bool primary: variant === "primary"
    readonly property bool destructive: variant === "destructive"

    signal clicked

    activeFocusOnTab: true
    implicitHeight: large ? Theme.metrics.authControlHeight : Theme.metrics.controlHeight
    implicitWidth: label.implicitWidth + Theme.metrics.padding * 2
    width: implicitWidth
    height: implicitHeight
    opacity: 1

    readonly property color fillColor: {
        if (!enabled)
            return Theme.color.bgRaised;
        if (primary)
            return pressed ? Theme.color.actionPrimaryPressed : hovered ? Theme.color.actionPrimaryHover : Theme.color.actionPrimary;
        if (destructive)
            return pressed ? Theme.color.destructivePressed : hovered ? Theme.color.destructiveHover : Theme.color.destructive;
        return pressed ? Theme.color.bgCanvas : hovered ? Theme.color.bgHover : Theme.color.bgSurface;
    }

    readonly property color textColor: {
        if (!enabled)
            return Theme.color.textMuted;
        if (primary)
            return Theme.color.actionOnPrimary;
        if (destructive)
            return Theme.color.actionOnDestructive;
        return Theme.color.textPrimary;
    }

    Rectangle {
        anchors.fill: parent
        color: root.fillColor
        border.width: root.primary || root.destructive ? 0 : Theme.metrics.borderWidth
        border.color: root.enabled ? Theme.color.borderControl : Theme.color.borderSubtle

        Behavior on color {
            ColorAnimation {
                duration: Theme.motion.fast
            }
        }
    }

    NovaText {
        id: label
        anchors.centerIn: parent
        text: root.text
        role: root.large ? "actionLarge" : "action"
        color: root.textColor
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
        onClicked: {
            root.forceActiveFocus();
            root.clicked();
        }
    }

    Keys.onPressed: event => {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            root.clicked();
            event.accepted = true;
        } else if (event.key === Qt.Key_Space && !event.isAutoRepeat) {
            root.keyPressed = true;
            event.accepted = true;
        }
    }

    Keys.onReleased: event => {
        if (event.key === Qt.Key_Space && !event.isAutoRepeat && root.keyPressed) {
            root.keyPressed = false;
            root.clicked();
            event.accepted = true;
        }
    }
}
