pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property alias states: adapter
    property bool ready: false
    property string previousHyprlandInstanceSignature: ""
    property bool isNewHyprlandInstance: previousHyprlandInstanceSignature !== states.hyprlandInstanceSignature

    onReadyChanged: {
        previousHyprlandInstanceSignature = states.hyprlandInstanceSignature;
        states.hyprlandInstanceSignature = Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE") || "";
    }

    FileView {
        id: fileView
        path: Directories.statesFilePath
        watchChanges: true
        onFileChanged: reloadTimer.restart()
        onAdapterUpdated: writeTimer.restart()
        onLoaded: root.ready = true
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                writeTimer.restart();
                root.ready = true;
            }
        }

        adapter: JsonAdapter {
            id: adapter

            property string hyprlandInstanceSignature: ""

            property JsonObject idle: JsonObject {
                property bool inhibit: false
            }
        }
    }

    Timer {
        id: reloadTimer
        interval: 100
        onTriggered: fileView.reload()
    }

    Timer {
        id: writeTimer
        interval: 100
        onTriggered: fileView.writeAdapter()
    }
}

