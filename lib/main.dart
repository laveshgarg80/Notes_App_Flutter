import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  List<String> list = [];
  var value = "";
  var deleteIndex = -1;
  @override
  void initState() {
    print("hello");
    load();
  }

  void load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      //read localStorage
      list = prefs.getStringList('items')!;
    });
  }

  void addTask() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      list.add(value);
    });
    //write localStorage
    await prefs.setStringList('items', list);
  }

  void deleteTask() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      list.removeAt(deleteIndex);
    });
    await prefs.setStringList('items', list);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 300,
            height: 500,
            child: Card(
                elevation: 10,
                child: Column(
                  children: [
                    //textField
                    Container(
                      width: 250,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      margin: EdgeInsets.only(
                        top: 10,
                      ),
                      child: TextField(
                          onChanged: (text) {
                            value = text;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter TODO Task",
                            hintStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                    //button
                    Container(
                        width: 250,
                        height: 50,
                        margin: EdgeInsets.only(
                          top: 10,
                        ),
                        child: ElevatedButton(
                          child: Text("Add Task"),
                          onPressed: () {
                            addTask();
                          },
                        )),
                    //task
                    Container(
                      width: 250,
                      height: 350,
                      child: ListView(
                        children: [
                          for (int i = 0; i < list.length; i++) ...[
                            Container(
                              width: 250,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              margin: EdgeInsets.only(
                                top: 10,
                              ),
                              child: ListTile(
                                trailing: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () {
                                      deleteIndex = i;
                                      deleteTask();
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  list[i],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
