pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common
import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property string configuredPath: Config.options.background.wallpaperPath
    readonly property string path: configuredPath.length > 0 ? configuredPath : Directories.defaultWallpaper
    readonly property url source: `file://${path}`

    function set(newPath: string): void {
        Config.options.background.wallpaperPath = newPath;
    }

    function reset(): void {
        Config.options.background.wallpaperPath = "";
    }
}
