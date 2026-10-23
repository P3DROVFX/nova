pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common.functions
import QtCore
import QtQuick
import Quickshell

Singleton {
    readonly property string home: FileUtils.trimFileProtocol(StandardPaths.standardLocations(StandardPaths.HomeLocation)[0])
    readonly property string xdgConfig: Quickshell.env("XDG_CONFIG_HOME") || `${home}/.config`
    readonly property string xdgState: Quickshell.env("XDG_STATE_HOME") || `${home}/.local/state`
    readonly property string xdgCache: Quickshell.env("XDG_CACHE_HOME") || `${home}/.cache`

    readonly property string config: `${xdgConfig}/nova`
    readonly property string state: `${xdgState}/nova`
    readonly property string cache: `${xdgCache}/nova`

    readonly property string configFilePath: `${config}/config.json`
    readonly property string statesFilePath: `${state}/states.json`
    readonly property string activeShellPath: `${state}/active-shell`
    readonly property string notificationsPath: `${cache}/notifications/notifications.json`
    readonly property string coverArt: `${cache}/media/coverart`
    readonly property string tempImages: "/tmp/quickshell/nova/images"

    readonly property string assets: FileUtils.trimFileProtocol(Quickshell.shellPath("assets"))
    readonly property string scripts: FileUtils.trimFileProtocol(Quickshell.shellPath("scripts"))
    readonly property string defaultWallpaper: `${assets}/wallpapers/default.png`

    Component.onCompleted: {
        Quickshell.execDetached(["mkdir", "-p", config, state, cache, `${cache}/notifications`, coverArt]);
    }
}
