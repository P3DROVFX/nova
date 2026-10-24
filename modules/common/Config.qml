pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property alias options: adapter
    property bool ready: false

    FileView {
        id: fileView
        path: Directories.configFilePath
        watchChanges: true
        onFileChanged: reloadTimer.restart()
        onAdapterUpdated: writeTimer.restart()
        onLoaded: root.ready = true
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                writeAdapter();
                root.ready = true;
            }
        }

        JsonAdapter {
            id: adapter

            property JsonObject appearance: JsonObject {
                property string palette: "nova-dark"
                property bool reducedMotion: false
            }

            property JsonObject background: JsonObject {
                property string wallpaperPath: ""
            }

            property JsonObject desktop: JsonObject {
                property real iconSize: 72
                property real iconCellWidth: 128
                property real iconCellHeight: 128
            }

            property JsonObject apps: JsonObject {
                property string terminal: "kitty -1"
            }

            property JsonObject lock: JsonObject {
                property bool requirePasswordToPower: true
            }

            property JsonObject audio: JsonObject {
                property JsonObject protection: JsonObject {
                    property bool enable: true
                    property real maxAllowedIncrease: 10
                    property real maxAllowed: 100
                }
            }

            property JsonObject sounds: JsonObject {
                property bool battery: false
                property string theme: "freedesktop"
            }

            property JsonObject battery: JsonObject {
                property int low: 20
                property int critical: 5
                property int suspend: 2
                property int full: 101
                property bool automaticSuspend: true
            }

            property JsonObject media: JsonObject {
                property bool filterDuplicatePlayers: true
            }

            property JsonObject time: JsonObject {
                property string format: "hh:mm"
                property string shortDateFormat: "dd/MM"
                property string dateFormat: "dddd, dd/MM"
                property string dateWithYearFormat: "dd/MM/yyyy"
                property bool secondPrecision: false
            }

            property JsonObject resources: JsonObject {
                property int updateInterval: 3000
            }

            property JsonObject tray: JsonObject {
                property bool filterPassive: true
                property bool invertPinnedItems: false
                property bool showItemId: false
                property list<string> pinnedItems: []
            }

            property JsonObject launcher: JsonObject {
                property list<string> pinnedApps: ["org.gnome.Nautilus", "kitty", "google-chrome", "code"]
            }

            property JsonObject search: JsonObject {
                property bool sloppy: false
                property int nonAppResultDelay: 30
                property string engineBaseUrl: "https://www.google.com/search?q="
                property JsonObject prefix: JsonObject {
                    property string app: ">"
                    property string math: "="
                    property string shellCommand: "$"
                    property string webSearch: "?"
                    property bool showDefaultActionsWithoutPrefix: true
                }
            }
        }
    }

    Timer {
        id: reloadTimer
        interval: 50
        onTriggered: fileView.reload()
    }

    Timer {
        id: writeTimer
        interval: 50
        onTriggered: fileView.writeAdapter()
    }
}

