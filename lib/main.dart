import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/toDoModel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoListModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TodoApp(),
      )
    );
  }
}

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {

  TextEditingController t1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var listModel = Provider.of<TodoListModel>(context);
    return Scaffold(
      body: listModel.isLoading?
      Center(
        child: CircularProgressIndicator(),
      )
      : Column(
        children: [
          Expanded(
            flex: 4,
            child: ListView.builder(
              itemCount: listModel.todos.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(listModel.todos[index].taskName) ?? '...',
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(child: TextField(
                    controller: t1,
                  ), flex: 5),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      child: Text("ADD"),
                      onPressed: () {
                        listModel.addTask(t1.text);
                      },
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
