import sys
import json
import os
from PySide6.QtWidgets import QApplication
from PySide6.QtCore import QObject, Slot

import RinUI
from RinUI import RinUIWindow


class TodoManager(QObject):
    """管理待办事项的Python类，可以从QML访问"""
    
    def __init__(self):
        super().__init__()
        # JSON文件路径
        self.data_file = "todos.json"
        # 初始化todos列表
        self._todos = []
        # 加载数据，如果文件不存在则初始化默认数据
        loaded_data = self.load_data()
        self._todos = loaded_data
        # 如果是首次运行（没有现有数据），则保存默认数据
        if not os.path.exists(self.data_file):
            self.save_data()

    def load_data(self):
        """从JSON文件加载数据，如果文件不存在则创建默认数据"""
        if os.path.exists(self.data_file):
            try:
                with open(self.data_file, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                    return data if data else self.get_default_data()
            except (json.JSONDecodeError, FileNotFoundError):
                # 如果文件损坏或无法读取，则返回默认数据
                return self.get_default_data()
        else:
            # 文件不存在，返回默认数据
            return self.get_default_data()

    def save_data(self):
        """将数据保存到JSON文件"""
        try:
            with open(self.data_file, 'w', encoding='utf-8') as f:
                json.dump(self._todos, f, ensure_ascii=False, indent=2)
        except Exception as e:
            print(f"保存数据时出错: {e}")

    def get_default_data(self):
        """获取默认的待办事项数据"""
        return [
            {"id": 1, "title": "欢迎使用", "description": "欢迎使用", "completed": False}
        ]

    @Slot(result='QVariantList')
    def get_todos(self):
        """获取所有待办事项"""
        return self._todos

    @Slot(int, result='QVariant')
    def get_todo_by_id(self, todo_id):
        """根据ID获取特定待办事项"""
        for todo in self._todos:
            if todo['id'] == todo_id:
                return todo
        return {}

    @Slot(str, str, bool)
    def add_todo(self, title, description, completed=False):
        """添加新的待办事项"""
        new_id = max([t['id'] for t in self._todos], default=0) + 1
        self._todos.append({
            "id": new_id,
            "title": title,
            "description": description,
            "completed": completed
        })
        # 保存数据到JSON文件
        self.save_data()

    @Slot(int, bool)
    def update_todo_status(self, todo_id, completed):
        """更新待办事项的完成状态"""
        for todo in self._todos:
            if todo['id'] == todo_id:
                todo['completed'] = completed
                # 保存数据到JSON文件
                self.save_data()
                break

    @Slot(int)
    def remove_todo(self, todo_id):
        """删除待办事项"""
        self._todos = [t for t in self._todos if t['id'] != todo_id]
        # 保存数据到JSON文件
        self.save_data()


if __name__ == '__main__':
    print(RinUI.__file__)
    app = QApplication(sys.argv)
    # 创建TodoManager实例
    todo_manager = TodoManager()
    gallery = RinUIWindow("pages/main.qml")  # 假设我们使用list.qml
    gallery.engine.rootContext().setContextProperty("todoManager", todo_manager)
    
    app.exec()