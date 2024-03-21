import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todos_application/models/todo.dart';
import 'package:todos_application/services/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  final Database _database = Database();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: _displayTextInputDialog,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Text(
        "Todo",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: Column(
        children: [
          _messageListView(),
        ],
      ),
    );
  }

  Widget _messageListView() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.80,
      width: MediaQuery.sizeOf(context).width,
      child: StreamBuilder(
        stream: _database.getTodos(),
        builder: (context, snapshots) {
          List todos = snapshots.data?.docs ?? [];

          if (todos.isEmpty) {
            return const Center(
              child: Text("Nothing here..."),
              // child: AssetImage('assets/images/empty.svg'),
            );
          }

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              Todo todo = todos[index].data();
              String todoId = todos[index].id;
              // print(todoId);
              // print("Hello World");

              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: ListTile(
                  tileColor: Theme.of(context).colorScheme.primaryContainer,
                  title: Text(todo.task),
                  subtitle: Text(
                    DateFormat("dd-MM-yyyy h:m a").format(
                      todo.updatedAt.toDate(),
                    ),
                  ),
                  trailing: Checkbox(
                    value: todo.isDone,
                    onChanged: (value) {
                      Todo updatedTodo = todo.copyWith(
                        isDone: !todo.isDone,
                        updatedAt: Timestamp.now(),
                      );
                      _database.updateTodo(todoId, updatedTodo);
                    },
                  ),
                  onLongPress: () {
                    _database.deleteTodo(todoId);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _displayTextInputDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add new todo"),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(
              hintText: "Todo...",
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              textColor: Colors.white,
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                Todo todo = Todo(
                  task: _textEditingController.text,
                  isDone: false,
                  createdAt: Timestamp.now(),
                  updatedAt: Timestamp.now(),
                );
                _database.addTodo(todo);
                Navigator.pop(context);
                _textEditingController.clear();
              },
              child: const Text("Save"),
            )
          ],
        );
      },
    );
  }
}
