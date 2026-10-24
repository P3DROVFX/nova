import QtQuick
import qs.modules.common

Item {
    id: root

    property string tone: "normal"
    readonly property bool danger: tone === "danger"

    property color canvasColor: danger ? Theme.color.dangerCanvas : Theme.color.bgCanvas
    property color surfaceColor: danger ? Theme.color.dangerSurface : Theme.color.bgSurface
    property color raisedColor: danger ? Theme.color.dangerRaised : Theme.color.bgRaised
    property color markColor: Theme.color.borderControl
    property real jitterTop: 0
    property real jitterLeft: 0
    property real jitterBottom: 0

    width: 1920
    height: 1080

    Behavior on canvasColor {
        ColorAnimation { duration: Theme.motion.fast }
    }
    Behavior on surfaceColor {
        ColorAnimation { duration: Theme.motion.fast }
    }
    Behavior on raisedColor {
        ColorAnimation { duration: Theme.motion.fast }
    }

    function glitch() {
        if (Theme.reducedMotion)
            return;
        jitter.restart();
    }

    SequentialAnimation {
        id: jitter

        ScriptAction {
            script: {
                root.jitterTop = (Math.random() < 0.5 ? -1 : 1) * (40 + Math.random() * 90);
                root.jitterLeft = (Math.random() < 0.5 ? -1 : 1) * (30 + Math.random() * 60);
                root.jitterBottom = (Math.random() < 0.5 ? -1 : 1) * (40 + Math.random() * 80);
            }
        }
        PauseAnimation { duration: 48 }
        ScriptAction {
            script: {
                root.jitterTop = -root.jitterTop * 0.4;
                root.jitterLeft = 0;
                root.jitterBottom = -root.jitterBottom * 0.5;
            }
        }
        PauseAnimation { duration: 40 }
        ScriptAction {
            script: {
                root.jitterTop = 0;
                root.jitterLeft = 0;
                root.jitterBottom = 0;
            }
        }
    }

    Rectangle {
        x: -2000
        y: -2000
        width: root.width + 4000
        height: root.height + 4000
        color: root.canvasColor
    }

    NovaSurface {
        x: 40
        y: 40
        width: 1840
        height: 1000
        fill: root.surfaceColor
        notchWidth: 128
        notchHeight: 100

        Rectangle {
            x: 600 + root.jitterTop
            y: 0
            width: 640
            height: 320
            color: root.raisedColor
        }

        Rectangle {
            x: 0
            y: 320 + root.jitterLeft
            width: 600
            height: 580
            color: root.raisedColor
        }

        NovaSurface {
            x: 1240 + root.jitterBottom
            y: 680
            width: 600
            height: 320
            fill: root.raisedColor
            notchWidth: 128
            notchHeight: 100
            notchTopLeft: false
            notchTopRight: false
            notchBottomLeft: false
        }
    }

    RegistrationMark {
        x: 94 - width / 2
        y: 66 - height / 2
        size: 56
        color: root.markColor
    }

    RegistrationMark {
        x: 1826 - width / 2
        y: 66 - height / 2
        size: 56
        color: root.markColor
    }

    RegistrationMark {
        x: 94 - width / 2
        y: 1014 - height / 2
        size: 56
        color: root.markColor
    }

    RegistrationMark {
        x: 1826 - width / 2
        y: 1014 - height / 2
        size: 56
        color: root.markColor
    }
}
