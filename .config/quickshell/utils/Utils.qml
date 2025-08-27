pragma Singleton

import Quickshell

Singleton {
    function getIconPath(windowClass: string): string {
        if (windowClass === "Tor Browser")
            return "tor-browser";

        return windowClass;
    }
}
