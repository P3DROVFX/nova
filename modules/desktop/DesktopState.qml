pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property bool searchActive: false
    property var surfaces: []

    signal searchFocusRequested

    function registerSurface(surface) {
        surfaces = surfaces.concat([surface]);
    }

    function openSearch() {
        searchActive = true;
        searchFocusRequested();
    }

    function closeSearch() {
        searchActive = false;
    }

    function toggleSearch() {
        if (searchActive)
            closeSearch();
        else
            openSearch();
    }
}
