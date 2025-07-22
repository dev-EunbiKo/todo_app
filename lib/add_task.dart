import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  final void Function({required String todoText}) updateText;
  const AddTask({super.key, required this.updateText});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var todoText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Add Task"),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            controller: todoText,
            decoration: InputDecoration(hintText: "Add Task"),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            widget.updateText(todoText: todoText.text);
            todoText.clear();
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}
