import 'file:///C:/Users/mando/Documents/NeoCypher/mel_y_mando/lib/models/userdata.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class HomeScreenChat extends StatefulWidget {
  final String currentUserId;
  final UserData thisUser;

  const HomeScreenChat({Key key, this.currentUserId, this.thisUser}) : super(key: key);

  @override
  State createState() => HomeScreenChatState(currentUserId: currentUserId, currUser: thisUser);
}

class HomeScreenChatState extends State<HomeScreenChat>{
  HomeScreenChatState({Key key, @required this.currentUserId, @required this.currUser});

  final UserData currUser;
  final String currentUserId;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    print('que es esto: $currUser');

  }
}