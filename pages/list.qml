import QtQuick
import QtQuick.Controls
import QtQuick.Window
import RinUI


Item {
    SettingCard {
        anchors.left: parent.left
        anchors.right: parent.right
        title: qsTr("测试Todo")
        description: qsTr("测试")
        CheckBox {
            text: qsTr("Three-state CheckBox")
            tristate: true
        }
    }
}