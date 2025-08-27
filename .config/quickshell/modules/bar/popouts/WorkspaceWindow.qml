import qs.modules.common
import qs.services

import QtQuick
import Quickshell
import Quickshell.Wayland

Item {
    property var hoveredWindow: ShellState.bar.workspaces.hoveredWindow
    property real posX: 10

    implicitWidth: title.implicitWidth + preview.implicitWidth
    implicitHeight: title.implicitHeight + preview.implicitHeight

    anchors.fill: parent

    // visible: !!hoveredWindow

    StyledText {
        id: title
        anchors.fill: parent
        animate: true
        animateDuration: 100
        animateProp: "opacity"
        text: {
            return `Go to ${ShellState.bar.workspaces.hoveredWindow?.title}`;
        }
    }

    ScreencopyView {
        id: preview

        captureSource: {
            return null;
        }
        live: false

        constraintSize.width: 10
        constraintSize.height: 10
    }

    Connections {
        target: Hyprland.activeToplevel

        function onWaylandHandleChanged() {
            console.log("it's changed");
        }
    }

    // Loader {
    //     // id: title
    //
    //     readonly property Component titleText: StyledText {
    //         animate: true
    //         text: {
    //             console.log(hoveredWindow.title);
    //             return `Go to ${hoveredWindow.title}`;
    //         }
    //     }
    //
    //     sourceComponent: hoveredWindow && titleText
    // }
}
