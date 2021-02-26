import 'package:mel_y_mando/Screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:mel_y_mando/Services/DataBaseFix.dart';
import 'package:mel_y_mando/models/userdata.dart';
import 'package:provider/provider.dart';
import 'package:mel_y_mando/Screens/home/home.dart';
import 'package:mel_y_mando/models/user.dart';


class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    //Return home or authenticate widget
    if(user == null){
      return Authenticate();
    }else{
      return StreamProvider<UserData>.value(
        value: DatabaseServiceF(uid: user.uid).Thisuser,
        child: Home(),
      );
    }
  }
}
