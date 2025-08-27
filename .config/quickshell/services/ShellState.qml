pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property var bar: QtObject {
        property var workspaces: QtObject {
            property var hoveredWindow
        }
    }
}
