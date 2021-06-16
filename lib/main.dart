import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mel_y_mando/models/user.dart';
import 'package:mel_y_mando/Screens/wrapper.dart';
import 'package:mel_y_mando/Services/auth.dart';

Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      //affect all widgets below this
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xff4c2882),
          accentColor: Color(0xff45daff),
        ),
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
      value: AuthService().user
    );
  }
}
