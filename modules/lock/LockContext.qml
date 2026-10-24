import QtQuick
import Quickshell

Scope {
    id: root

    signal shouldReFocus
    signal authRequested(string password)
    signal authenticated(string action)

    property string currentText: ""
    property string state: "idle"
    property string pendingAction: "unlock"
    property int failedLength: 0
    readonly property bool busy: state === "verifying" || state === "success"

    function touch() {
        clearTimer.restart();
    }

    function type(text) {
        if (busy)
            return;
        if (state === "failed")
            state = "idle";
        currentText += text;
        touch();
    }

    function backspace() {
        if (busy)
            return;
        if (state === "failed")
            state = "idle";
        currentText = currentText.slice(0, -1);
        touch();
    }

    function clear() {
        if (busy)
            return;
        state = "idle";
        currentText = "";
    }

    function selectAction(action) {
        pendingAction = pendingAction === action ? "unlock" : action;
    }

    function submit() {
        if (busy || currentText.length === 0)
            return;
        state = "verifying";
        authRequested(currentText);
    }

    function authSucceeded() {
        if (pendingAction === "unlock") {
            state = "success";
        } else {
            state = "idle";
            currentText = "";
        }
        authenticated(pendingAction);
    }

    function authFailed() {
        failedLength = currentText.length;
        currentText = "";
        state = "failed";
        failTimer.restart();
    }

    function reset() {
        currentText = "";
        state = "idle";
        pendingAction = "unlock";
        failedLength = 0;
    }

    Timer {
        id: failTimer
        interval: 1800
        onTriggered: {
            if (root.state === "failed") {
                root.state = "idle";
                root.failedLength = 0;
            }
        }
    }

    Timer {
        id: clearTimer
        interval: 10000
        onTriggered: {
            if (root.state === "idle")
                root.currentText = "";
        }
    }
}
