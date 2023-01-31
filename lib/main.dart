import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:melymando2/Screens/wrapper.dart';
import 'package:melymando2/Services/auth.dart';
import 'package:melymando2/models/user.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      //affect all widgets below this
      value: AuthService().user,
      initialData: null,
      //affect all widgets below this
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xff4c2882),
          accentColor: Color(0xff45daff),
        ),
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}
