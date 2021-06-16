import 'package:flutter/material.dart';
import 'package:mel_y_mando/Services/DataBaseFix.dart';
import 'package:mel_y_mando/models/TaskToDo.dart';
import 'package:provider/provider.dart';

class ListItem extends StatelessWidget{
  final Task task;
  ListItem({this.task});


  @override
  Widget build(BuildContext context) {

    final String taskId = task.id;
    final String descripcion = task.description;
    final bool isDone = task.isDone;

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
            leading: Checkbox(
              value: isDone,
              onChanged: (bool newVal){
                DatabaseServiceF().setTaskDoneUndone(taskId, newVal);
              }
            ),
          title: Text(descripcion),
        ),
      )
    );
  }
}
