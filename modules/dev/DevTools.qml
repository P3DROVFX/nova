import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.desktop
import qs.services

Scope {
    IpcHandler {
        target: "dev"

        function snapshot(path: string): void {
            const surface = DesktopState.surfaces[0];
            if (surface)
                surface.grabToImage(result => result.saveToFile(path));
        }

        function search(query: string): void {
            DesktopState.openSearch();
            LauncherSearch.query = query;
        }
    }
}
