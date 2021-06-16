import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mel_y_mando/Services/DataBaseFix.dart';
import 'package:mel_y_mando/models/TaskToDo.dart';
import 'package:provider/provider.dart';

import 'AddNewTask.dart';
import 'ToDoList.dart';

class toDoHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var accentColor = Theme.of(context).accentColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cosas para hacer'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => AddNewTask(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Cosas por hacer', textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20
                  ),
                ),
              ]
          ),
          Row(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 1,
                child:  StreamProvider<List<Task>>.value(
                  value: DatabaseServiceF().tasksNotDone,
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
          SizedBox(height: 10),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Cosas hechas', textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20
                  ),
                ),
              ]
          ),
          Row(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 1,
                child: StreamProvider<List<Task>>.value(
                  value: DatabaseServiceF().tasksDone,
                  child: ToDoList(),
                ),
              )
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => AddNewTask(),
          );
        },
        tooltip: 'Agrega una!',
      ),
    );
  }
}
