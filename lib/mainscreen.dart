import 'package:flutter/material.dart';
import 'package:todo_app/add_task.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 리스트 방식으로 화면에 보여주기 위한 리스트 변수
  List<String> todoList = [];

  // 데이터 전달 방법 1
  void addTodo({required String todoText}) {
    setState(() {
      todoList.add(todoText);
    });

    // bottom sheet 닫기
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: Text("Drawer")),
      appBar: AppBar(
        title: const Text('TODO App'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: SizedBox(
                      height: 250,
                      child: AddTask(addTodo: addTodo),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(title: Text(todoList[index]));
        },
        itemCount: todoList.length,
      ),
    );
  }
}
