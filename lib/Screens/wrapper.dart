import 'package:melymando2/Screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:melymando2/Services/DataBaseFix.dart';
import 'package:melymando2/models/userdata.dart';
import 'package:provider/provider.dart';
import 'package:melymando2/Screens/home/home.dart';
import 'package:melymando2/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    //Return home or authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return StreamProvider<UserData?>.value(
        value: DatabaseServiceF(uid: user.uid).Thisuser,
        initialData: null,
        child: Home(),
      );
    }
  }
}
