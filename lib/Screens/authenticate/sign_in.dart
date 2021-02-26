import 'package:mel_y_mando/Screens/authenticate/register.dart';
import 'package:mel_y_mando/Screens/chat/widget/loading.dart';
import 'package:mel_y_mando/Shared/customstyles.dart';
import 'package:mel_y_mando/services/auth.dart';
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

    return loading ? Loading(): Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                          child: Image.asset('assets/images/logoDM-full.jpg')
                      )
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  Expanded(child: Text("Nuestra App", textAlign: TextAlign.center,style: TextStyle(fontSize: 30),))
                ],
              ),

              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 32),
                      TextFormField(
                        decoration: textInputDecoration,
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
                        decoration: textInputDecoration.copyWith(hintText: 'Contraseña'),
                        obscureText: true,
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'El campo está vacío.';
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
                      SizedBox(height: 28),
                    ],
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              ),
              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 64),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: primaryColor,
                child: Text("Ingresa"),
                onPressed: () async {
                  if(_formKey.currentState.validate()){
                    setState(() {
                      loading = true;
                    });
                    dynamic result = await _authService.signInWithEmailAndPassword(email.trim(), password);
                    print("Error: --");
                    print(result.runtimeType);
                    if (result == null) {
                      setState(() {
                        error =
                        'Error al ingresar. Revisa que los datos sean correctos y que haya conexión a la red.';
                        loading = false;
                      });
                    }
                  }

                },
              ),
              SizedBox(height: 20),
              Divider(
                height: 2,
                color: Colors.blueAccent[150],
                indent: 64,
                endIndent: 64,

              ),
              SizedBox(height: 34),

              OutlineButton(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 64),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                borderSide: BorderSide(color: primaryColor, width: 2),
                child: Text(
                  'Primera Vez',
                  style: TextStyle(color: primaryColor),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()), //cambiar a Register
                  );
                },
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    error,
                    style: TextStyle(color: Colors.redAccent),
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
