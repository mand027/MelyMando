import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mel_y_mando/Screens/chat/chat.dart';
import 'package:mel_y_mando/Screens/chat/widget/loading.dart';
import 'package:mel_y_mando/Services/DataBaseFix.dart';
import 'package:mel_y_mando/Services/auth.dart';
import 'package:mel_y_mando/models/userdata.dart';
import 'package:mel_y_mando/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final misDatos = Provider.of<UserData>(context);
    final String id = user.uid;
    final String oid = misDatos.ouid;
    if (oid == '' || oid == null){
      return Loading();
    }else{
      return StreamProvider<UserData>.value(
          value: DatabaseServiceF(otheruid: oid).parejaUser,
          //hear for everytime a document changes in users
          child: Helper(misDatos: misDatos)
      );
    }
  }
}

class Helper extends StatefulWidget {
  final UserData misDatos;
  Helper({Key key, @required this.misDatos}) : super(key: key);
  @override
  _HelperState createState() => _HelperState(misDatos: misDatos);
}

class _HelperState extends State<Helper> {
  _HelperState({Key key, @required this.misDatos});

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


  final FirebaseMessaging _fcm = FirebaseMessaging();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    registerNotification();
    configLocalNotification();
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings()
    );

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });
  }

  void configLocalNotification() async {
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'com.segov.drivermatch' : 'com.segov.drivermatch',
      'Driver Match',
      'Prueba',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics =
    new NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, message['title'].toString(), message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  UserData misDatos;

  @override
  Widget build(BuildContext context) {

    final AuthService _auth = AuthService();

    final parejaUser = Provider.of<UserData>(context);
    var accentColor = Theme.of(context).accentColor;
    final peerId = parejaUser.uid;
    final peerName = parejaUser.nombre;
    final currentId = misDatos.uid;
    void saveDeviceToken() async {

      // Get the token for this device
      String fcmToken = await _fcm.getToken();
      print("Tokeeeeeeen: $fcmToken");

      // Save it to Firestore
      await DatabaseServiceF(uid: currentId).TokenDevice(fcmToken);
    }
    saveDeviceToken();


    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(flex: 1, child: SizedBox(),),
            Expanded(
              child: Center(
                  child:
                  Text(parejaUser.nombre +" y "+ misDatos.nombre), //cambiar por logo nuev
              ),
            ),
            Expanded(
              child:  FlatButton.icon(
                label: Text('', style: TextStyle(color: Colors.white, fontSize: 10)),
                onPressed: () async {
                  _auth.signOut();
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ButtonTheme(
                minWidth: 150.0,
                height: 100.0,
                child: RaisedButton(shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                  color: Colors.grey,
                  child: Text(
                    'Abrir Galería',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: ()  async {
                  },
                )
              ),
              SizedBox(width: 30),
              ButtonTheme(
                minWidth: 150.0,
                height: 100.0,
                child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: accentColor,
                child: Text(
                  'Abrir chat',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                onPressed: ()  async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Chat(
                            peerId: peerId,
                            peerName: peerName,
                            currentId: currentId,
                          )));
                },
              )
              )
            ],
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ButtonTheme(
                minWidth: 150.0,
                height: 100.0,
                child:RaisedButton(shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                  color: Colors.grey,
                  child: Text(
                    'Cosas para hacer',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: ()  async {
                  },
                )
              ),
              SizedBox(width: 30),
              ButtonTheme(
                minWidth: 150.0,
                height: 100.0,
                child: RaisedButton(shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                  color: Colors.grey,
                  child: Text(
                    'Abasho virtual',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: ()  async {
                  },
                )
              )
            ],
          )
        ],
      ),
    );
  }
}