import QtQuick
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root

    property bool active: false
    signal finished

    readonly property var checkCells: [[0, 2], [1, 3], [2, 4], [3, 3], [4, 2], [5, 1], [6, 0]]
    property real barScaleX: 0.983
    property real barScaleY: 0.113
    property real barShiftY: 31
    property real marks: 0
    property real checkReveal: 0
    property real panelOpacity: 1

    width: 1920
    height: 1080
    visible: active && panelOpacity > 0

    onActiveChanged: {
        if (active)
            sequence.restart();
        else
            reset();
    }

    function reset() {
        sequence.stop();
        barScaleX = 0.983;
        barScaleY = 0.113;
        barShiftY = 31;
        marks = 0;
        checkReveal = 0;
        panelOpacity = 1;
    }

    SequentialAnimation {
        id: sequence

        ParallelAnimation {
            NumberAnimation { target: root; property: "barScaleX"; to: 1.106; duration: 120; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.ease.enter }
            NumberAnimation { target: root; property: "barScaleY"; to: 0.194; duration: 120; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.ease.enter }
            NumberAnimation { target: root; property: "barShiftY"; to: 0; duration: 120; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.ease.enter }
        }
        PauseAnimation { duration: 40 }
        ParallelAnimation {
            NumberAnimation { target: root; property: "barScaleX"; to: 1; duration: Theme.motion.window; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.ease.enter }
            NumberAnimation { target: root; property: "barScaleY"; to: 1; duration: Theme.motion.window; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.ease.enter }
        }
        SequentialAnimation {
            NumberAnimation { target: root; property: "marks"; to: 1; duration: 24 }
            NumberAnimation { target: root; property: "marks"; to: 0.2; duration: 24 }
            NumberAnimation { target: root; property: "marks"; to: 1; duration: 36 }
        }
        NumberAnimation {
            target: root
            property: "checkReveal"
            from: 0
            to: root.checkCells.length
            duration: root.checkCells.length * 44
        }
        PauseAnimation { duration: 340 }
        ParallelAnimation {
            NumberAnimation { target: root; property: "barScaleY"; to: 0.012; duration: 130; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.ease.exit }
            NumberAnimation { target: root; property: "barScaleX"; to: 1.06; duration: 130; easing.type: Easing.BezierSpline; easing.bezierCurve: Theme.ease.exit }
            NumberAnimation { target: root; property: "marks"; to: 0; duration: 70 }
            NumberAnimation { target: root; property: "checkReveal"; to: 0; duration: 70 }
        }
        NumberAnimation { target: root; property: "panelOpacity"; to: 0; duration: 70 }
        ScriptAction { script: root.finished() }
    }

    Rectangle {
        id: panel
        x: 450
        y: 141
        width: 1025
        height: 797
        color: Theme.color.actionPrimary
        radius: 8
        opacity: root.panelOpacity
        transform: [
            Translate { y: root.barShiftY },
            Scale {
                origin.x: panel.width / 2
                origin.y: panel.height / 2
                xScale: root.barScaleX
                yScale: root.barScaleY
            }
        ]
    }

    Item {
        x: 450
        y: 141
        width: 1025
        height: 797
        opacity: root.panelOpacity
        transform: Scale {
            origin.x: 512
            origin.y: 398
            xScale: root.barScaleX
            yScale: root.barScaleY
        }

        Repeater {
            model: [[47, 39], [916, 39], [47, 698], [916, 698]]

            RegistrationMark {
                required property var modelData
                x: modelData[0]
                y: modelData[1]
                size: 62
                thickness: 4
                color: Theme.color.actionOnPrimary
                opacity: root.marks
            }
        }

        PixelIcon {
            anchors.centerIn: parent
            cell: 79
            cells: root.checkCells
            revealed: root.checkReveal
            color: Theme.color.actionOnPrimary
        }
    }
}
