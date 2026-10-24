pragma ComponentBehavior: Bound

import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import qs.services

FocusScope {
    id: root

    required property var context

    signal unlockFinished

    readonly property string phase: context.state
    readonly property bool failed: phase === "failed"
    readonly property bool verifying: phase === "verifying"
    readonly property bool success: phase === "success"
    readonly property bool formShown: shown && !leaving
    readonly property int maskCount: failed ? context.failedLength : context.currentText.length
    readonly property string accountName: SystemInfo.username.charAt(0).toUpperCase() + SystemInfo.username.slice(1)
    readonly property string authLine: failed ? "AUTH / DENIED" : verifying ? "AUTH / VERIFYING_" : success ? "AUTH / GRANTED" : context.pendingAction === "unlock" ? "AUTH / AWAITING_" : "AUTH / THEN " + actionLabel(context.pendingAction)

    property bool shown: false
    property bool leaving: false
    property bool overlayActive: false
    property real fill: 0
    property real shakeX: 0

    function actionLabel(action) {
        return action === "poweroff" ? "SHUT DOWN" : action === "reboot" ? "RESTART" : "SUSPEND";
    }

    function chooseAction(action) {
        if (action === "suspend") {
            Session.suspend();
            return;
        }
        if (!Config.options.lock.requirePasswordToPower) {
            if (action === "poweroff")
                Session.poweroff();
            else
                Session.reboot();
            return;
        }
        context.selectAction(action);
        forceActiveFocus();
    }

    focus: true
    Component.onCompleted: {
        forceActiveFocus();
        shown = true;
    }

    Connections {
        target: root.context
        function onShouldReFocus() {
            root.forceActiveFocus();
        }
    }

    onFailedChanged: {
        if (failed) {
            sweep.stop();
            fill = 0;
            frame.glitch();
            logoGlitch.burst(220);
            if (!Theme.reducedMotion)
                shake.restart();
        }
    }

    onVerifyingChanged: {
        if (verifying) {
            fill = 0;
            sweep.restart();
        }
    }

    onSuccessChanged: {
        if (success) {
            sweep.stop();
            finishFill.restart();
        }
    }

    Keys.onPressed: event => {
        context.touch();
        if (event.key === Qt.Key_Escape) {
            context.clear();
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            context.submit();
        } else if (event.key === Qt.Key_Backspace) {
            if (event.modifiers & Qt.ControlModifier)
                context.clear();
            else
                context.backspace();
        } else if (event.text.length > 0 && !(event.modifiers & (Qt.ControlModifier | Qt.AltModifier | Qt.MetaModifier)) && event.text.charCodeAt(0) >= 32 && event.text.charCodeAt(0) !== 127) {
            context.type(event.text);
        }
        event.accepted = true;
    }

    MouseArea {
        anchors.fill: parent
        onPressed: mouse => {
            root.forceActiveFocus();
            mouse.accepted = false;
        }
    }

    Rectangle {
        anchors.fill: parent
        color: frame.canvasColor
    }

    DesignStage {
        anchors.fill: parent

        NovaFrame {
            id: frame
            tone: root.failed ? "danger" : "normal"
        }

        NovaReveal {
            id: clockBlock
            x: 208
            y: 76
            width: 220
            height: 70
            shown: root.formShown
            delay: 80

            NovaText {
                text: DateTime.time
                role: "clock"
            }

            NovaText {
                y: 40
                text: Qt.locale("en_US").toString(DateTime.clock.date, "dddd, dd MMM yyyy")
                role: "caption"
                color: Theme.color.textSecondary
            }
        }

        NovaReveal {
            id: accountBlock
            x: 1451
            y: 76
            width: 260
            height: 60
            shown: root.formShown
            delay: 100

            NovaText {
                anchors.right: parent.right
                text: "ACCOUNT"
                role: "caption"
                color: Theme.color.textSecondary
            }

            NovaText {
                anchors.right: parent.right
                y: 24
                text: root.accountName
                role: "subtitle"
                font.capitalization: Font.MixedCase
            }
        }

        NovaReveal {
            id: logoBlock
            x: 960 - logo.width / 2
            y: 100
            width: logo.width
            height: logo.height
            shown: root.formShown
            delay: 0
            rise: 0
            fromScale: 0.96
            inPattern: [0.7, 0.05, 1, 0.3, 0.9, 0.5, 1]
            stepInterval: 32

            NovaLogo {
                id: logo
                size: 218
                color: root.failed ? Theme.color.dangerText : Theme.color.textPrimary
            }

            GlitchSlices {
                id: logoGlitch
                source: logo
                amplitude: 36
            }
        }

        Item {
            id: form
            x: 456 + root.shakeX
            width: 1008
            height: 400

            NovaReveal {
                y: 430
                width: parent.width
                height: 30
                shown: root.formShown
                delay: 140

                NovaText {
                    text: "SIGN IN"
                    role: "subtitle"
                }

                NovaText {
                    anchors.right: parent.right
                    y: 6
                    text: "LOCAL AUTH / 01"
                    role: "caption"
                    color: Theme.color.textSecondary
                }
            }

            NovaReveal {
                y: 474
                width: 300
                height: 24
                shown: root.formShown
                delay: 180

                NovaText {
                    text: "PASSWORD"
                    role: "fieldLabel"
                }
            }

            NovaReveal {
                y: 526
                width: parent.width
                height: 124
                shown: root.formShown || root.success && !root.overlayActive
                delay: 220

                NovaPasswordMask {
                    count: root.maskCount
                    fieldWidth: parent.width
                    danger: root.failed
                    active: !root.verifying
                    fillProgress: root.fill
                }

                Rectangle {
                    y: 120
                    width: parent.width
                    height: 3
                    color: root.failed ? Theme.color.dangerAccent : Theme.color.actionPrimary
                }
            }

            NovaReveal {
                y: 671
                width: parent.width
                height: 88
                shown: root.formShown && !root.verifying
                delay: root.verifying ? 0 : 260
                rise: 8

                NovaButton {
                    anchors.fill: parent
                    large: true
                    variant: root.failed ? "alert" : "primary"
                    text: root.failed ? "ERROR" : "ENTER"
                    labelRole: root.failed ? "alertLarge" : "actionLarge"
                    activeFocusOnTab: false
                    onClicked: {
                        root.context.submit();
                        root.forceActiveFocus();
                    }
                }
            }

            NovaReveal {
                y: 777
                width: parent.width
                height: 20
                shown: root.formShown
                delay: 300

                NovaText {
                    text: "ESC / CLEAR"
                    role: "caption"
                    color: Theme.color.textSecondary
                }

                NovaText {
                    anchors.right: parent.right
                    text: "ENTER / SIGN IN"
                    role: "caption"
                    color: Theme.color.textSecondary
                }
            }
        }

        NovaReveal {
            id: systemLines
            x: 88
            y: 820
            width: 420
            height: 80
            shown: root.formShown
            delay: 340

            Column {
                spacing: 8

                NovaText {
                    text: "NOVA / LOCAL SYSTEM"
                    role: "caption"
                    color: Theme.color.textMuted
                }

                NovaText {
                    text: "SESSION LOCKED"
                    role: "caption"
                    color: Theme.color.textMuted
                }

                ScrambleText {
                    message: root.authLine
                    role: "caption"
                    color: root.failed ? Theme.color.dangerAccent : root.verifying || root.success ? Theme.color.actionPrimary : Theme.color.textMuted
                }
            }
        }

        NovaReveal {
            id: keyboardLine
            x: 1418
            y: 862
            width: 300
            height: 24
            shown: root.formShown
            delay: 360

            NovaText {
                anchors.right: parent.right
                text: "KEYBOARD / " + (HyprlandXkb.currentLayoutCode.length > 0 ? HyprlandXkb.currentLayoutCode.toUpperCase() : "--")
                role: "caption"
                color: Theme.color.textMuted
            }
        }

        NovaReveal {
            id: batteryLine
            x: 208
            y: 970
            width: 400
            height: 34
            shown: root.formShown && Battery.available
            delay: 380

            Row {
                spacing: 16

                NovaText {
                    text: "BATTERY"
                    role: "body"
                }

                NovaText {
                    text: Math.round(Battery.percentage * 100) + "% / " + (Battery.isPluggedIn ? "CONNECTED" : "ON BATTERY")
                    role: "body"
                    color: Battery.isCriticalAndNotCharging ? Theme.color.statusError : Theme.color.textPrimary
                }
            }
        }

        NovaReveal {
            id: powerActions
            x: 1100
            y: 964
            width: 611
            height: 44
            shown: root.formShown
            delay: 400

            Row {
                anchors.right: parent.right
                spacing: 47

                NovaLinkButton {
                    text: "SUSPEND"
                    onClicked: root.chooseAction("suspend")
                }

                NovaLinkButton {
                    text: "RESTART"
                    selected: root.context.pendingAction === "reboot"
                    onClicked: root.chooseAction("reboot")
                }

                NovaLinkButton {
                    text: "SHUT DOWN"
                    selected: root.context.pendingAction === "poweroff"
                    onClicked: root.chooseAction("poweroff")
                }
            }
        }

        LockSuccess {
            active: root.overlayActive
            onFinished: root.unlockFinished()
        }
    }

    NumberAnimation {
        id: sweep
        target: root
        property: "fill"
        from: 0
        to: 0.86
        duration: 1400
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Theme.ease.standard
    }

    SequentialAnimation {
        id: finishFill

        NumberAnimation {
            target: root
            property: "fill"
            to: 1
            duration: 140
        }
        ScriptAction {
            script: {
                root.leaving = true;
                root.overlayActive = true;
            }
        }
    }

    SequentialAnimation {
        id: shake

        NumberAnimation { target: root; property: "shakeX"; to: -16; duration: 32 }
        NumberAnimation { target: root; property: "shakeX"; to: 13; duration: 40 }
        NumberAnimation { target: root; property: "shakeX"; to: -9; duration: 40 }
        NumberAnimation { target: root; property: "shakeX"; to: 5; duration: 40 }
        NumberAnimation { target: root; property: "shakeX"; to: 0; duration: 48 }
    }

    Timer {
        id: ambientTimer
        interval: 3500
        repeat: true
        running: root.shown && !root.verifying && !root.success
        onTriggered: {
            const targets = [systemLines, keyboardLine, clockBlock, accountBlock];
            targets[Math.floor(Math.random() * targets.length)].pulse();
            interval = 2500 + Math.random() * 5000;
        }
    }

    Timer {
        interval: 9000
        repeat: true
        running: root.shown && root.phase === "idle"
        onTriggered: {
            logoGlitch.burst(130);
            interval = 7000 + Math.random() * 8000;
        }
    }
}

