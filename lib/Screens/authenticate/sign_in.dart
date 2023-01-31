import 'package:melymando2/Screens/authenticate/register.dart';
import 'package:melymando2/Screens/chat/widget/loading.dart';
import 'package:melymando2/Shared/customstyles.dart';
import 'package:melymando2/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>(); //for validation

  //text field state
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;

    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.grey[100],
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        const Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 5,
                          child: SizedBox(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child:
                                  Image.asset('assets/images/logoDM-full.jpg'),
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: const [
                        Expanded(
                          child: Text(
                            "Nuestra App",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30),
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 50),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(height: 32),
                            TextFormField(
                              decoration: textInputDecoration,
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
                                setState(
                                  () {
                                    email = val.trim();
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 32),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'Contraseña'),
                              obscureText: true,
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return 'El campo está vacío.';
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
                            const SizedBox(height: 28),
                          ],
                        ),
                      ),
                    ),
                    MaterialButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 64),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: primaryColor,
                      child: const Text("Ingresa"),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(
                            () {
                              loading = true;
                            },
                          );
                          dynamic result =
                              await _authService.signInWithEmailAndPassword(
                                  email.trim(), password);
                          print("Error: --");
                          print(result.runtimeType);
                          if (result == null) {
                            setState(
                              () {
                                error =
                                    'Error al ingresar. Revisa que los datos sean correctos y que haya conexión a la red.';
                                loading = false;
                              },
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Divider(
                      height: 2,
                      color: Colors.blueAccent[150],
                      indent: 64,
                      endIndent: 64,
                    ),
                    const SizedBox(height: 34),
                    MaterialButton(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 64),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Primera Vez',
                        style: TextStyle(color: primaryColor),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Register(),
                          ), //cambiar a Register
                        );
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Text(
                          error,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
