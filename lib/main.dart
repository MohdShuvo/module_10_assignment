import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class TodoItem {
  final String title;
  final dynamic content;
  final int id;

  TodoItem({required this.title, required this.content, required this.id});
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.blue),
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<TodoItem> todoList = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  void addItem(TodoItem item) {
    setState(() {
      todoList.add(item);
      titleController.clear();
      contentController.clear();
    });
  }

  void editItem(int index, TodoItem newItem) {
    setState(() {
      todoList[index] = newItem;
    });
  }

  void deleteItem(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: "Add Title"),
                ),
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(labelText: "Add description"),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showAddItemDialog();
                  },
                  child: Text("Add"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.numbers, color: Colors.white),
                    ),
                    title: Text(todoList[index].title),
                    subtitle: Text(todoList[index].content.toString()),
                    onLongPress: () {
                      _showEditDeleteDialog(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog() {
    addItem(TodoItem(
      title: titleController.text,
      content: contentController.text,
      id: DateTime.now().millisecondsSinceEpoch,
    ));
  }

  void _showEditDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController titleController = TextEditingController(text: todoList[index].title);
        TextEditingController contentController = TextEditingController(text: todoList[index].content.toString());

        return AlertDialog(
          title: Text("Edit"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Add Title"),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(labelText: "Add description"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                deleteItem(index);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Update"),
              onPressed: () {
                editItem(
                    index,
                    TodoItem(
                      title: titleController.text,
                      content: contentController.text,
                      id: todoList[index].id,
                    ));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
