import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mel_y_mando/models/TaskToDo.dart';
import 'package:provider/provider.dart';

import 'ListItem.dart';

class ToDoList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskList = Provider.of<List<Task>>(context);

    return taskList.length > 0
        ? ListView.builder(
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        return ListItem(task: taskList[index]);
      },
    )
        : LayoutBuilder(
      builder: (ctx, constraints) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: constraints.maxHeight * 0.5,
                child: Image.asset('assets/images/waiting.png',
                    fit: BoxFit.cover),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Aun no hay cosas en esta lista',
                style: Theme.of(context).textTheme.title,
              ),
            ],
          ),
        );
      },
    );
  }
}