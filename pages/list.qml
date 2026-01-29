import QtQuick
import QtQuick.Controls
import QtQuick.Window
import RinUI


Item {
    Flickable {
        anchors.fill: parent
        contentHeight: columnLayout.height
        flickableDirection: Flickable.VerticalFlick

        Column {
            id: columnLayout
            width: parent.width
            spacing: 10 // 设置组件之间的间距

            // 从Python后端获取数据的ListModel
            ListModel {
                id: todoListModel
            }

            Repeater {
                model: todoListModel
                SettingCard {
                    width: parent.width
                    title: model.title
                    description: model.description
                    CheckBox {
                        text: ""
                        checked: model.checked
                        onCheckedChanged: {
                            // 通知Python后端更新状态
                            todoManager.update_todo_status(model.id, checked)
                        }
                    }
                }
            }
        }
    }

    // 数据加载组件
    Component.onCompleted: {
        // 从Python后端加载数据
        loadTodosFromPython()
    }

    // 从Python后端加载待办事项的函数
    function loadTodosFromPython() {
        // 清空现有数据
        todoListModel.clear()
        
        // 从Python的TodoManager获取数据
        var todos = todoManager.get_todos()
        
        // 将数据添加到ListModel
        for (var i = 0; i < todos.length; i++) {
            todoListModel.append({
                "id": todos[i].id,
                "title": todos[i].title,
                "description": todos[i].description,
                "checked": todos[i].completed
            })
        }
    }
}