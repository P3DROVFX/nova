import QtQuick
import qs.modules.common

Item {
    id: root

    required property Item source
    property int slices: 7
    property real amplitude: 28
    property int interval: 36
    property bool active: false
    property var offsets: []

    visible: active
    width: source ? source.width : 0
    height: source ? source.height : 0

    function burst(duration) {
        if (Theme.reducedMotion)
            return;
        randomize();
        active = true;
        stopTimer.interval = duration ?? 160;
        stopTimer.restart();
        shuffleTimer.restart();
    }

    function randomize() {
        const next = [];
        for (let i = 0; i < slices; i++)
            next.push(Math.random() < 0.45 ? 0 : (Math.random() * 2 - 1) * amplitude);
        offsets = next;
    }

    Timer {
        id: shuffleTimer
        interval: root.interval
        repeat: true
        onTriggered: root.randomize()
    }

    Timer {
        id: stopTimer
        onTriggered: {
            shuffleTimer.stop();
            root.active = false;
        }
    }

    Repeater {
        model: root.slices

        ShaderEffectSource {
            required property int index
            readonly property real sliceHeight: root.height / root.slices
            sourceItem: root.source
            sourceRect: Qt.rect(0, index * sliceHeight, root.width, sliceHeight)
            hideSource: root.active
            live: true
            x: root.offsets[index] ?? 0
            y: index * sliceHeight
            width: root.width
            height: sliceHeight
        }
    }
}
