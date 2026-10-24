import QtQuick
import qs.modules.common

NovaText {
    id: root

    property string message: ""
    property bool ambient: false
    property real ambientRate: 0.06
    property int resolved: message.length
    readonly property bool scrambling: resolved < message.length
    readonly property string glyphs: "0123456789ABCDEF#%/<>_"

    function glyph() {
        return glyphs.charAt(Math.floor(Math.random() * glyphs.length));
    }

    function compose() {
        let out = "";
        for (let i = 0; i < message.length; i++) {
            const c = message.charAt(i);
            if (c === " " || c === "\n") {
                out += c;
            } else if (i >= resolved) {
                out += glyph();
            } else if (ambient && Math.random() < ambientRate) {
                out += glyph();
            } else {
                out += c;
            }
        }
        return out;
    }

    function scramble() {
        if (Theme.reducedMotion) {
            text = message;
            return;
        }
        resolved = 0;
        timer.restart();
    }

    onMessageChanged: scramble()
    Component.onCompleted: {
        text = message;
        if (ambient)
            timer.restart();
    }
    onAmbientChanged: if (ambient)
        timer.restart()

    Timer {
        id: timer
        interval: 34
        repeat: true
        onTriggered: {
            if (root.scrambling)
                root.resolved = Math.min(root.message.length, root.resolved + 1);
            root.text = root.compose();
            if (!root.scrambling && !root.ambient) {
                stop();
                root.text = root.message;
            }
        }
    }
}
