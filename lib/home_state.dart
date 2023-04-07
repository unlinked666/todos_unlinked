import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_unlinked/custom_widgets.dart';
import 'data_helper/todo_class_helper.dart';
import 'firebase/firestore_helper.dart';

class HomeState extends StatefulWidget {
  const HomeState({super.key});

  @override
  State<HomeState> createState() => _HomeStateState();
}

class _HomeStateState extends State<HomeState> {
  @override
  Widget build(BuildContext context) {
    final removedProv = Provider.of<RemovedProvider>(context);

    return Scaffold(
      // Drawer
      drawer: LeftMenu(),

      // Appbar
      appBar: AppBar(
        title: Text("Halo, Figo"),
        shadowColor: Theme.of(context).primaryColor,
        scrolledUnderElevation: 50,
        toolbarHeight: 80,
        surfaceTintColor: Colors.yellow,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Hapus Semua?"),
                  actions: [
                    TButton(
                      context,
                      text: "Ya",
                      onPressed: () async {
                        TodosHelper.deleteData(collection: "todos");

                        Navigator.pushReplacementNamed(context, "home_route");
                      },
                      primary: true,
                    ),
                    TButton(
                      context,
                      text: "Tidak",
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
            },
            icon: Icon(Icons.delete),
            color: Colors.black.withOpacity(.75),
          )
        ],
      ),

      // Add Todo Button
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_sharp),
        onPressed: () {
          Navigator.pushNamed(context, "add_todo_route");
        },
      ),

      // Body
      body: FutureBuilder(
        future: TodosHelper.readData(),
        builder: (context, snapshot) {
          List<QueryDocumentSnapshot<Map<String, dynamic>>> todos;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.isNotEmpty && !removedProv.removed) {
            todos = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.only(top: 50),
              itemCount: todos.length,
              itemBuilder: (context, index) {
                List<QueryDocumentSnapshot<Map<String, dynamic>>> todo =
                    todos.map((e) => e).toList();

                return Align(
                  alignment: Alignment.center,

                  // Todo Card
                  child: TodoCard(
                    todo: TodoClass(
                      title: todo[index]["title"],
                      description: todo[index]["description"],
                      dateTime: (todo[index]["dateTime"] as Timestamp).toDate(),
                    ),
                  ),
                );
              },
            );
          }
          TodosHelper.readData().ignore();
          return Center(
            child: Text("Todo masih kosong"),
          );
        },
      ),
    );
  }
}

// Todo Card
class TodoCard extends StatelessWidget {
  final TodoClass todo;

  TodoCard({
    super.key,
    required this.todo,
  });

  final int r = Random().nextInt(100) + 155;
  final int g = Random().nextInt(100) + 155;
  final int b = Random().nextInt(100) + 155;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width / 1.25,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, r, g, b),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                color: Colors.black.withOpacity(.25),
                offset: Offset(0, 10),
              )
            ],
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(.35),
              width: 5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Align(
                child: Text(
                  todo.title.toUpperCase(),
                  style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold),
                ),
                alignment: Alignment.topLeft,
              ),

              // Description
              Text(todo.description),

              // Date TIme
              Align(
                heightFactor: 1.5,
                alignment: Alignment.bottomRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${DateFormat.yMMMMEEEEd().format(todo.dateTime)}",
                      style: TextStyle(
                        color: Colors.black.withOpacity(.5),
                      ),
                    ),
                    Text(
                      "${DateFormat.jm().format(todo.dateTime)}",
                      style: TextStyle(color: Colors.black.withOpacity(.5)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 50),
      ],
    );
  }
}

// Drawer
class LeftMenu extends StatelessWidget {
  const LeftMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Akun
          Container(
            height: MediaQuery.of(context).size.height / 3.5,
            margin: EdgeInsets.only(bottom: 30),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),

          // Text Button
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TButton(context, text: "Settings", onPressed: () {}),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class RemovedProvider extends ChangeNotifier {
  bool _removed = false;
  bool get removed => this._removed;

  set removed(bool value) {
    this._removed = value;
    notifyListeners();
  }
}
