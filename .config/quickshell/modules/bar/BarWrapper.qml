import QtQuick
import Quickshell

PanelWindow {
    id: root

    color: "transparent"
    anchors {
        top: true
        right: true
        left: true
        bottom: true
    }

    mask: Region {
        x: 0
        y: bar.implicitHeight
        width: root.width
        height: root.height - bar.implicitHeight
        intersection: Intersection.Subtract

        regions: [popout.mask]
    }

    exclusionMode: ExclusionMode.Ignore

    Bar {
        id: bar
    }

    BarPopout {
        id: popout
        bar: bar
    }

    // push windows
    PanelWindow {
        color: "transparent"
        anchors {
            top: true
        }
        mask: Region {}
        exclusiveZone: bar.implicitHeight + 5
        implicitWidth: 1
        implicitHeight: 1
    }
}
