import 'package:melymando2/Screens/chat/widget/loading.dart';
import 'package:melymando2/Services/DataBaseFix.dart';
import 'package:melymando2/Services/auth.dart';
import 'package:melymando2/Screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:melymando2/Shared/customstyles.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextStyle subTitleStyle =
      const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
  TextStyle normalStyle = const TextStyle(color: Colors.black);

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
      return const Loading();
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
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
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
                        if (val!.isEmpty) {
                          return 'El campo está vacío.';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (val) {
                        //val is the form input content
                        setState(
                          () {
                            name = val.trim();
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Mail Pareja'),
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        if (val!.isEmpty) {
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
                    const SizedBox(height: 30),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              'Atrás',
                              style: TextStyle(color: primaryColor),
                            ),
                            onPressed: () {
                              setState(
                                () {
                                  secondForm = false;
                                },
                              );
                            },
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 2,
                          child: MaterialButton(
                            color: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Registrate',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_secondFormKey.currentState!.validate()) {
                                setState(
                                  () {
                                    loading = true;
                                  },
                                );
                                dynamic result = await _authService
                                    .registerWithEmailAndPassword(
                                        email.trim(), password);
                                if (result == null) {
                                  setState(
                                    () {
                                      error =
                                          'Error al crear usuario. Revisa que los datos sean correctos y que haya conexión a la red.';
                                      loading = false;
                                    },
                                  );
                                } else {
                                  await DatabaseServiceF(uid: result.uid)
                                      .UpdateUserData(name, mailPareja, email);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Home(),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text(
                        error,
                        style: const TextStyle(color: Colors.redAccent),
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
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
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
                  const SizedBox(height: 64),
                  TextFormField(
                    decoration: textInputDecoration,
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      RegExp regex = RegExp(
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                      if (val!.isEmpty) {
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
                  const SizedBox(height: 32),
                  TextFormField(
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Contraseña'),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'El campo está vacío.';
                      } else if (val.length < 8) {
                        return 'La contraseña debe ser de mínimo 8 caracteres.';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (val) {
                      setState(
                        () {
                          password = val.trim();
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  MaterialButton(
                    color: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 64),
                    child: const Text(
                      'Siguiente',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(
                          () {
                            secondForm = true;
                          },
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      error,
                      style: const TextStyle(color: Colors.redAccent),
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
