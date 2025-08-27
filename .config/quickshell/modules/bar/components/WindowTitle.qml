import qs.utils
import qs.services
import qs.modules.common

import QtQuick
import Quickshell
import Quickshell.Widgets

Item {
    id: root

    readonly property var activeWindow: Hyprland.activeToplevel

    readonly property var windowTitle: {
        if (!activeWindow) {
            return;
        }

        const title = activeWindow.title.slice(0, 30);

        if (activeWindow.title?.length <= 30)
            return title;

        return title + "…";
    }
    readonly property var windowClass: activeWindow?.lastIpcObject?.class

    implicitHeight: Math.max(titleIcon.implicitHeight, titleText.implicitHeight)
    implicitWidth: titleIcon.implicitWidth + titleText.implicitWidth + titleText.anchors.leftMargin

    StyledText {
        id: titleIcon
        animate: true

        anchors.verticalCenter: root.verticalCenter

        text: windowTitle ? Icons.getWindowIcon(activeWindow.title, windowClass) : Icons.desktopIcon

        color: Colors.palette.primary
        font.pointSize: 15
    }

    StyledText {
        id: titleText
        animate: true
        animateProp: "opacity"

        anchors.verticalCenter: root.verticalCenter
        anchors.left: titleIcon.right
        anchors.leftMargin: 15

        text: windowTitle || "Desktop"
        color: Colors.palette.primary
        font.pointSize: 13
    }
}
