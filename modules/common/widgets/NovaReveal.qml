import QtQuick
import qs.modules.common

Item {
    id: root

    property bool shown: false
    property int delay: 0
    property real rise: 12
    property real fromScale: 1
    property var inPattern: [0.9, 0.1, 1, 0.45, 1]
    property var outPattern: [0.6, 1, 0.2, 0]
    property var pulsePattern: [0.25, 1, 0.5, 1]
    property int stepInterval: 24

    property real offsetY: rise
    property real scaleFactor: fromScale
    property var steps: []
    property int stepIndex: 0
    property real finalOpacity: 0

    opacity: 0

    transform: [
        Translate {
            y: root.offsetY
        },
        Scale {
            origin.x: root.width / 2
            origin.y: root.height / 2
            xScale: root.scaleFactor
            yScale: root.scaleFactor
        }
    ]

    function runSteps(pattern, final) {
        if (Theme.reducedMotion) {
            opacity = final;
            return;
        }
        steps = pattern;
        finalOpacity = final;
        stepIndex = 0;
        stepTimer.restart();
    }

    function pulse() {
        if (opacity > 0.5)
            runSteps(pulsePattern, 1);
    }

    function enter() {
        stepTimer.stop();
        if (Theme.reducedMotion) {
            offsetY = 0;
            scaleFactor = 1;
            fadeIn.restart();
            return;
        }
        offsetY = rise;
        scaleFactor = fromScale;
        riseAnimation.restart();
        scaleAnimation.restart();
        runSteps(inPattern, 1);
    }

    function leave() {
        stepTimer.stop();
        if (Theme.reducedMotion) {
            fadeOut.restart();
            return;
        }
        runSteps(outPattern, 0);
    }

    onShownChanged: delayTimer.restart()
    Component.onCompleted: if (shown)
        delayTimer.restart()

    Timer {
        id: delayTimer
        interval: root.delay
        onTriggered: root.shown ? root.enter() : root.leave()
    }

    Timer {
        id: stepTimer
        interval: root.stepInterval
        repeat: true
        onTriggered: {
            if (root.stepIndex >= root.steps.length) {
                stop();
                root.opacity = root.finalOpacity;
                return;
            }
            root.opacity = root.steps[root.stepIndex];
            root.stepIndex++;
        }
    }

    NumberAnimation {
        id: riseAnimation
        target: root
        property: "offsetY"
        to: 0
        duration: Theme.motion.base
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Theme.ease.enter
    }

    NumberAnimation {
        id: scaleAnimation
        target: root
        property: "scaleFactor"
        to: 1
        duration: Theme.motion.base
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Theme.ease.enter
    }

    NumberAnimation {
        id: fadeIn
        target: root
        property: "opacity"
        to: 1
        duration: Theme.motion.reduced
    }

    NumberAnimation {
        id: fadeOut
        target: root
        property: "opacity"
        to: 0
        duration: Theme.motion.reduced
    }
}
