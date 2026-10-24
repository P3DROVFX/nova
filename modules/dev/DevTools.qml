import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.modules.common
import qs.modules.desktop
import qs.modules.lock
import qs.services

Scope {
    id: root

    property bool previewActive: false
    property var previewItem: null
    property int frameIndex: 0
    property int frameCount: 0
    property string framePrefix: ""

    function grab(item, path) {
        if (item)
            item.grabToImage(result => result.saveToFile(path));
    }

    IpcHandler {
        target: "dev"

        function snapshot(path: string): void {
            root.grab(DesktopState.surfaces[0], path);
        }

        function search(query: string): void {
            DesktopState.openSearch();
            LauncherSearch.query = query;
        }

        function lockOpen(): void {
            DesktopState.revealed = false;
            root.previewActive = true;
        }

        function lockClose(): void {
            root.previewActive = false;
        }

        function lockSnapshot(path: string): void {
            root.grab(root.previewItem, path);
        }

        function type(text: string): void {
            mock.type(text);
        }

        function backspace(): void {
            mock.backspace();
        }

        function clear(): void {
            mock.clear();
        }

        function submit(): void {
            mock.submit();
        }

        function record(prefix: string, count: int, interval: int): void {
            root.framePrefix = prefix;
            root.frameCount = count;
            root.frameIndex = 0;
            recorder.interval = interval;
            recorder.start();
        }

        function reveal(): void {
            DesktopState.revealed = false;
            revealTimer.restart();
        }
    }

    Timer {
        id: revealTimer
        interval: 300
        onTriggered: DesktopState.revealed = true
    }

    Timer {
        id: recorder
        repeat: true
        onTriggered: {
            if (root.frameIndex >= root.frameCount) {
                stop();
                return;
            }
            const target = root.previewActive ? root.previewItem : DesktopState.surfaces[0];
            root.grab(target, `${root.framePrefix}${String(root.frameIndex).padStart(3, "0")}.png`);
            root.frameIndex++;
        }
    }

    MockLockContext {
        id: mock
    }

    Loader {
        active: root.previewActive

        sourceComponent: PanelWindow {
            color: "black"
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.namespace: "nova:lock-preview"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }

            LockSurface {
                anchors.fill: parent
                context: mock
                Component.onCompleted: root.previewItem = this
                onUnlockFinished: {
                    mock.reset();
                    root.previewActive = false;
                    DesktopState.revealed = true;
                }
            }
        }
    }
}
