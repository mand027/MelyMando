import 'package:flutter/material.dart';
import 'package:melymando2/Services/DataBaseFix.dart';
import 'package:melymando2/models/TaskToDo.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  _AddNewTaskState createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  late Task task;
  String _inputDescription = '';
  final _formKey = GlobalKey<FormState>();
  String error = '';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      foregroundColor: Colors.white,
      minimumSize: const Size(88, 44),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
      backgroundColor: Colors.blue,
    );

    return Container(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Descripcion', style: Theme.of(context).textTheme.titleSmall),
            TextFormField(
              initialValue:
                  _inputDescription == null ? null : _inputDescription,
              decoration: const InputDecoration(
                hintText: 'Qué haremos?',
              ),
              validator: (value) {
                if (value!.isEmpty) {
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
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.bottomRight,
              child: TextButton(
                style: flatButtonStyle,
                child: Text(
                  'Agregar!',
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontFamily: 'Lato',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  if (_inputDescription.isNotEmpty) {
                    await DatabaseServiceF().addTask(_inputDescription);
                    Navigator.of(context).pop();
                  } else {
                    setState(
                      () {
                        error = 'no puede estar vacío';
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(error),
            )
          ],
        ),
      ),
    );
  }
}
