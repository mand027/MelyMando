import 'package:flutter/material.dart';
import 'package:melymando2/Services/DataBaseFix.dart';
import 'package:melymando2/models/TaskToDo.dart';
import 'package:provider/provider.dart';

import 'AddNewTask.dart';
import 'ToDoList.dart';

class toDoHome extends StatelessWidget {
  const toDoHome({super.key});

  @override
  Widget build(BuildContext context) {
    var accentColor = Theme.of(context).accentColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cosas para hacer'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => const AddNewTask(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const <Widget>[
                Text(
                  'Cosas por hacer',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ]),
          Row(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 1,
                child: StreamProvider<List<Task>?>.value(
                  value: DatabaseServiceF().tasksNotDone,
                  initialData: null,
                  child: ToDoList(),
                ),
              )
            ],
          ),
          Divider(
            thickness: 1,
            indent: 5,
            endIndent: 5,
            color: accentColor,
          ),
          const SizedBox(height: 10),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const <Widget>[
                Text(
                  'Cosas hechas',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ]),
          Row(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 1,
                child: StreamProvider<List<Task>?>.value(
                  value: DatabaseServiceF().tasksDone,
                  initialData: null,
                  child: ToDoList(),
                ),
              )
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => const AddNewTask(),
          );
        },
        tooltip: 'Agrega una!',
        child: const Icon(Icons.add),
      ),
    );
  }
}
