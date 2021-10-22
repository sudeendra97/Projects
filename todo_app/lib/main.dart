import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/listdata.dart';
import 'package:todo_app/screens/addscreen.dart';
import 'package:todo_app/screens/todolistscreen.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => TodoListData(),
        ),
      ],
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TodoAddScreen()),
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: TodoListScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodoAddScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
