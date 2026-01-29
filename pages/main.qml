import QtQuick
import QtQuick.Controls
import QtQuick.Window
import QtQuick.Layouts
import RinUI

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("One-Step")

    property string currentView: "home.qml"

    // 左侧导航栏
    ListView {
        id: navList
        width: 60
        height: parent.height  // 高度撑满窗口
        anchors.left: parent.left
        anchors.top: parent.top

        model: ListModel {
            ListElement { name: "home"; icon: "ic_fluent_home_20_regular" }
            ListElement { name: "list"; icon: "ic_fluent_list_20_regular" }
            ListElement { name: "about"; icon: "ic_fluent_info_20_regular" }
        }

        // 定义列表项委托（外观和行为）
        delegate: ListViewDelegate {
            // 左侧区域显示图标
            leftArea: IconWidget {
                icon: model.icon
                size: 22
            }

            // 中间区域留空
            middleArea: []

            // 点击事件处理
            onClicked: {
                console.log("Clicked on item:", model.name);
                currentView = model.name + ".qml"
            }
        }
    }

    // 主内容区域：Loader
    Loader {
        id: pageLoader
        // 关键：让 Loader 占据右侧剩余空间
        anchors.left: navList.right       // 左边紧贴导航栏
        anchors.right: parent.right       // 右边到窗口右边缘
        anchors.top: parent.top           // 顶部对齐
        anchors.bottom: parent.bottom     // 底部对齐
        anchors.leftMargin: 20
        anchors.topMargin: 5
        source: currentView
    }
}