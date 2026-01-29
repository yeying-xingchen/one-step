// 导入Qt Quick相关模块
import QtQuick
import QtQuick.Controls
import QtQuick.Window
// 导入自定义RinUI组件库
import RinUI

// 主窗口定义
Window {
    width: 640          // 窗口宽度
    height: 480         // 窗口高度
    visible: true       // 设置窗口可见
    title: qsTr("Hello World")  // 窗口标题

    // 左侧导航列表视图
    ListView {
        width: 60
        height: 300
        // 定义列表数据模型
        model: ListModel {
            ListElement { name: "home", icon: "ic_fluent_home_20_regular" }      // 首页项
            ListElement { name: "list", icon: "ic_fluent_list_20_regular" }      // 列表项
            ListElement { name: "about", icon: "ic_fluent_info_20_regular" }     // 关于项
        }

        // 定义列表项委托（外观和行为）
        delegate: ListViewDelegate {
            // 左侧区域显示图标
            leftArea: IconWidget {
                icon: model.icon // 从数据模型获取图标
                size: 22         // 图标大小
            }

            // 中间区域留空
            middleArea: []

            // 点击事件处理
            onClicked: {
                console.log("Clicked on item:", model.titleText);
            }
        }
    }
}