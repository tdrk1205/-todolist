import 'package:flutter/material.dart';

void main() => runApp(const TodoApp());

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '日課表',
      home: TodoList(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Todo {
  Todo({required this.name, required this.checked});
  final String name;
  bool checked;
}

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController _textFieldController = TextEditingController();
  final List<Todo> _todos = <Todo>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的日課表'),
        centerTitle: true,
        backgroundColor: Colors.green,

      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: _todos.map((Todo todo) {
          return TodoItem(
            todo: todo,
            onTodoChanged: _handleTodoChange,
            //onTodoChanged2: _removeTodoItem,
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
          backgroundColor: Colors.green,
          onPressed: () => _displayDialog(),
          tooltip: '新增項目',
          child: const Icon(Icons.add)),
    );
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('新增遊戲日課'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: '輸入日課內容'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('新增'),
              onPressed: () {
                if(_textFieldController.text==''){
                  const snackBar = SnackBar(
                    content: Text('無輸入任何內容'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }else{
                  _addTodoItem(_textFieldController.text);
                }
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('取消'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _addTodoItem(String name) {
    setState(() {
      _todos.add(Todo(name: name, checked: false));
    });
    _textFieldController.clear();
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }

  /*void _removeTodoItem(String name) {
    setState(() {
      _todos.remove(Todo(name: name, checked: false));
    });
  }*/
}

class TodoItem extends StatelessWidget {
  TodoItem({
    required this.todo,
    required this.onTodoChanged,
    //required this.onTodoChanged2,
  }) : super(key: ObjectKey(todo));

  final Todo todo;
  final onTodoChanged;
  //final onTodoChanged2;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onTodoChanged(todo);
      },
      leading: CircleAvatar(
        child: Text(todo.name[0]),
      ),
      title: Text(todo.name, style: _getTextStyle(todo.checked)),
      trailing: const IconButton(
        icon: Icon(Icons.delete),
        onPressed: null,
      )
    );
  }
}