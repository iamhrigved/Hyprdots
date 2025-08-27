pragma Singleton

import Quickshell

Singleton {
    id: root

    readonly property string desktopIcon: "󰇄"
    readonly property string osIcon: ""
    readonly property string webIcon: "󰖟"
    readonly property string youtubeIcon: ""
    readonly property string githubIcon: ""
    readonly property string xIcon: ""
    readonly property string googleIcon: ""
    readonly property string terminalIcon: ""
    readonly property string nvimIcon: ""
    readonly property string folderIcon: "󰉋"
    readonly property string homeFolderIcon: "󱂵"
    readonly property string documentsFolderIcon: "󱧶"
    readonly property string downloadsFolderIcon: "󰉍"
    readonly property string musicFolderIcon: "󱍙"
    readonly property string picturesFolderIcon: "󰉏"
    readonly property string videosFolderIcon: "󱧺"
    readonly property string windowIcon: "󱂬"

    readonly property string ethernetIcon: ""
    readonly property string wifiOff: "󰤭"
    readonly property string wifiStrength0: "󰤯"
    readonly property string wifiStrength1: "󰤟"
    readonly property string wifiStrength2: "󰤢"
    readonly property string wifiStrength3: "󰤥"
    readonly property string wifiStrength4: "󰤨"

    function getWifiIcon(strength: int): string {
        const strengthNum = strength >= 80 ? 4 : strength >= 60 ? 3 : strength >= 40 ? 2 : strength >= 20 ? 1 : 0;

        return root[`wifiStrength${strengthNum}`];
    }

    function getWindowIcon(windowTitle: string, windowClass: string): string {
        const r = {
            // titles
            desktop: /Desktop/,
            arch: /Arch/,
            youtube: /YouTube/,
            x: /(\w+ (\w+|\/) )?X /,
            nvim: /vi/,
            google: /Google( Search)?/,
            dolphinHome: /Home — Dolphin/,
            dolphinDocuments: /Documents — Dolphin/,
            dolphinDownloads: /Downloads — Dolphin/,
            dolphinMusic: /Music — Dolphin/,
            dolphinPictures: /Pictures — Dolphin/,
            dolphinVideos: /Videos — Dolphin/,

            // classes
            brave: /brave-browser/,
            kitty: /kitty/,
            dolphin: /org\.kde\.dolphin/
        };

        const t = windowTitle;
        const c = windowClass;

        if (t.match(r.desktop))
            return root.desktopIcon;
        if (c.match(r.brave)) {
            if (t.match(r.arch))
                return root.osIcon;
            if (t.match(r.youtube))
                return root.youtubeIcon;
            if (t.match(r.x))
                return root.xIcon;
            if (t.match(r.google))
                return root.googleIcon;
            return root.webIcon;
        }
        if (c.match(r.kitty)) {
            if (t.match(r.nvim))
                return root.nvimIcon;
            return root.terminalIcon;
        }
        if (c.match(r.dolphin)) {
            if (t.match(r.dolphinHome))
                return root.homeFolderIcon;
            if (t.match(r.dolphinDocuments))
                return root.documentsFolderIcon;
            if (t.match(r.dolphinDownloads))
                return root.downloadsFolderIcon;
            if (t.match(r.dolphinMusic))
                return root.musicFolderIcon;
            if (t.match(r.dolphinPictures))
                return root.picturesFolderIcon;
            if (t.match(r.dolphinVideos))
                return root.videosFolderIcon;
            return root.folderIcon;
        }

        return root.windowIcon;
    }
}
