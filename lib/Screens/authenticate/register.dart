import 'package:mel_y_mando/Screens/chat/widget/loading.dart';
import 'package:mel_y_mando/Services/DataBaseFix.dart';
import 'package:mel_y_mando/Services/auth.dart';
import 'package:mel_y_mando/Screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:mel_y_mando/Shared/customstyles.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}


class _RegisterState extends State<Register> {
  TextStyle subTitleStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
  TextStyle normalStyle = TextStyle(color: Colors.black);


  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>(); //for validation
  final _secondFormKey = GlobalKey<FormState>();

  //text field state
  String email = '';
  String password = '';
  String name = '';
  String mailPareja = '';

  String error = '';
  bool loading = false;
  bool secondForm = false;

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;
    if (loading) {
      return Loading();
    } else if (secondForm) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: primaryColor),
            title: Text(
              'Registro',
              style: TextStyle(color: primaryColor),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Form(
                key: _secondFormKey, //associate
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Ingresa los datos',
                        style: TextStyle(
                            fontSize: 32,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                    TextFormField(
                      decoration:
                      textInputDecoration.copyWith(hintText: 'Nombre'),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'El campo está vacío.';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (val) {
                        //val is the form input content
                        setState(() {
                          name = val.trim();
                        });
                      },
                    ),
                    SizedBox(height: 32),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'Mail Pareja'),
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'El campo está vacío.';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (val) {
                        setState(() {
                          mailPareja = val.trim();
                        });
                      },
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: OutlineButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            borderSide: BorderSide(color: primaryColor, width: 2),
                            child: Text(
                              'Atrás',
                              style: TextStyle(color: primaryColor),
                            ),
                            onPressed: () {
                              setState(() {
                                secondForm = false;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 2,
                          child: RaisedButton(
                            color: primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'Registrate',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_secondFormKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result = await _authService.registerWithEmailAndPassword(email.trim(), password);
                                if (result == null) {
                                  setState(() {
                                    error =
                                    'Error al crear usuario. Revisa que los datos sean correctos y que haya conexión a la red.';
                                    loading = false;
                                  });
                                } else {
                                  await DatabaseServiceF(uid: result.uid).UpdateUserData(name, mailPareja, email);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text(
                        error,
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: primaryColor),
          title: Text(
            'Registro',
            style: TextStyle(color: primaryColor),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Form(
              key: _formKey, //associate
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Crea una cuenta',
                      style: TextStyle(
                          fontSize: 32,
                          color: primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 64),
                  TextFormField(
                    decoration: textInputDecoration,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      Pattern pattern =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regex = new RegExp(pattern);
                      if (val.isEmpty) {
                        return 'El campo está vacío.';
                      } else if (!regex.hasMatch(val)) {
                        return 'El email no es válido';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (val) {
                      //val is the form input content
                      setState(() {
                        email = val.trim();
                      });
                    },
                  ),
                  SizedBox(height: 32),
                  TextFormField(
                    decoration:
                    textInputDecoration.copyWith(hintText: 'Contraseña'),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'El campo está vacío.';
                      } else if (val.length < 8) {
                        return 'La contraseña debe ser de mínimo 8 caracteres.';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (val) {
                      setState(() {
                        password = val.trim();
                      });
                    },
                  ),
                  SizedBox(height: 24),
                  RaisedButton(
                    color: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 64),
                    child: Text(
                      'Siguiente',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          secondForm = true;
                        });
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      error,
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}