import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mel_y_mando/Services/DataBaseFix.dart';
import 'package:mel_y_mando/models/TaskToDo.dart';

class AddNewTask extends StatefulWidget {

  @override
  _AddNewTaskState createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  Task task;
  String _inputDescription = '';
  final _formKey = GlobalKey<FormState>();
  String error = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Descripcion', style: Theme.of(context).textTheme.subtitle),
            TextFormField(
              initialValue:
              _inputDescription == null ? null : _inputDescription,
              decoration: InputDecoration(
                hintText: 'Qué haremos?',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'No puede estar vacio';
                }
                return null;
              },
              onChanged: (val) {
                setState(() {
                  _inputDescription = val.trim();
                });
              },
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                child: Text('Agregar!',
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontFamily: 'Lato',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  if(_inputDescription.isNotEmpty){
                    await DatabaseServiceF().addTask(_inputDescription);
                    Navigator.of(context).pop();
                  }
                  else{
                    setState(() {
                      error = 'no puede estar vacío';
                    });
                  }
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(error),
            )
          ],
        ),
      ),
    );
  }
}