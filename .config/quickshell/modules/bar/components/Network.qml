import qs.utils
import qs.services
import qs.modules.bar.popouts

import QtQuick

Item {
    id: root

    readonly property var activeNetwork: Network.activeNetwork
    readonly property var networkSpeed: Network.networkSpeed
    property bool hovered

    implicitHeight: networkIcon.implicitHeight
    implicitWidth: networkIcon.implicitWidth

    Text {
        id: networkIcon

        text: activeNetwork?.type === "ethernet" ? Icons.ethernetIcon : Icons.getWifiIcon(activeNetwork?.strength)
        color: Colors.palette.on_surface
        font.family: "JetBrainsMono Nerd Font"
        font.pointSize: 13
    }

    Loader {
        anchors.top: root.bottom

        active: {
            return root.hovered;
        }

        sourceComponent: Network {
            x: 100
            y: 100
            anchors.top: parent.bottom
        }
    }

    MouseArea {
        anchors.fill: root
        hoverEnabled: true

        onEntered: {
            root.hovered = true;
        }

        onExited: {
            root.hovered = false;
        }
    }

    // Text {
    //     id: networkSpeedText
    //
    //     anchors.left: networkIcon.right
    //     anchors.leftMargin: 10
    //
    //     text: networkSpeed.down.replace(" ", "")
    //     color: Colors.palette.on_surface
    //     font.family: "JetBrainsMono Nerd Font"
    //     font.pointSize: 13
    // }
}
