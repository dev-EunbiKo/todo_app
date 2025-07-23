import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/add_task.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 리스트 방식으로 화면에 보여주기 위한 리스트 변수
  List<String> todoList = [];

  // 추가 기능
  void addTodo({required String todoText}) {
    // 중복 방지
    if (todoList.contains(todoText)) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Already Exist!"),
            content: Text("This task is already Exists!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Close"),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      // 정렬을 위해 add -> insert 로 변경
      todoList.insert(0, todoText);
    });

    saveTodo();

    // bottom sheet 닫기
    Navigator.pop(context);
  }

  // 저장 기능
  void saveTodo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todoList', todoList);
  }

  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      todoList = (prefs.getStringList('todoList') ?? []).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("kombi"),
              accountEmail: const Text("12128_17@naver.com"),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(child: Image.asset("images/codingchef.png")),
              ),
            ),
            ListTile(
              onTap: () {
                launchUrl(Uri.parse("https://www.youtube.com"));
              },
              leading: const Icon(Icons.youtube_searched_for_rounded),
              title: const Text("About Me"),
            ),
            ListTile(
              onTap: () {
                launchUrl(Uri.parse("https://www.naver.com"));
              },
              leading: const Icon(Icons.mail_outline_rounded),
              title: const Text("Email"),
            ),
            ListTile(
              onTap: () {
                launchUrl(Uri.parse("https://www.naver.com"));
              },
              leading: const Icon(Icons.share_rounded),
              title: const Text("share"),
            ),
          ],
        ),
      ),
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
      body:
          (todoList.isEmpty)
              ? Center(
                child: Text(
                  "No Items on the List",
                  style: TextStyle(fontSize: 20),
                ),
              )
              : ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todoList[index]),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          todoList.removeAt(index);
                        });
                        saveTodo();
                        Navigator.pop(context);
                      },
                      child: const Text("Task Done!"),
                    ),
                  );
                },
              );
            },
          );
        },
        itemCount: todoList.length,
      ),
    );
  }
}
