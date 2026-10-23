import QtQuick
import qs.modules.common

FocusScope {
    id: root

    property bool checked: false
    readonly property bool hovered: mouse.containsMouse

    signal toggled(bool checked)

    activeFocusOnTab: true
    implicitWidth: 52
    implicitHeight: Theme.metrics.hitArea
    width: implicitWidth
    height: implicitHeight

    function toggle() {
        checked = !checked;
        toggled(checked);
    }

    Rectangle {
        id: track
        anchors.centerIn: parent
        width: 48
        height: 24
        color: !root.enabled ? Theme.color.bgRaised : root.checked ? Theme.color.actionPrimary : root.hovered ? Theme.color.bgHover : Theme.color.bgSurface
        border.width: Theme.metrics.borderWidth
        border.color: root.checked && root.enabled ? Theme.color.actionPrimary : root.enabled ? Theme.color.borderControl : Theme.color.borderSubtle

        Behavior on color {
            ColorAnimation {
                duration: Theme.motion.fast
            }
        }

        NovaFocusRing {
            active: root.activeFocus && root.enabled
        }

        Rectangle {
            id: handle
            width: 16
            height: 16
            y: 4
            x: root.checked ? track.width - width - 4 : 4
            color: !root.enabled ? Theme.color.textMuted : root.checked ? Theme.color.actionOnPrimary : Theme.color.textPrimary

            Behavior on x {
                NumberAnimation {
                    duration: Theme.motion.fast
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Theme.ease.standard
                }
            }
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.enabled
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.forceActiveFocus();
            root.toggle();
        }
    }

    Keys.onPressed: event => {
        if (event.key === Qt.Key_Space || event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            root.toggle();
            event.accepted = true;
        }
    }
}
