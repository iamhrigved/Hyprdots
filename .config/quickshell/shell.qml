import "services"
import "utils"
import "modules/bar"

import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland

ShellRoot {
    id: root

    BarWrapper {}
}
