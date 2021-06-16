import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mel_y_mando/Screens/Galeria/Galeria.dart';
import 'package:mel_y_mando/Screens/ToDoList/ToDoHome.dart';
import 'package:mel_y_mando/Screens/chat/chat.dart';
import 'package:mel_y_mando/Screens/chat/const.dart';
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


  bool cerrarOpcion = false;
  var genero = '';
  var lst = ['Accion','Aventura','Catastrofe','Ciencia Ficcion','Documental', 'Drama', 'Fantasia', 'Musical', 'Suspenso', 'Terror', 'Animada', 'Anime', 'Serie', 'Romance', 'Comedia', 'Independiente', 'Superheroes', 'Basada en Libro'];

  var tipo = '';
  var lst2 = ['Arabe','Japonesa','Carnes','China','Hamburguesa', 'Italiana', 'Asiatica', 'Mexicana', 'Pizza', 'Pollo (kfc, carbon...)', 'Tacos', 'Alitas', 'Sushi', 'Tortas (algo con pan)', 'Europea', 'Americana'];

  ImageSelectOption(BuildContext context) {
    var accentColor = Theme.of(context).primaryColor;

    if(cerrarOpcion == true){
      Navigator.pop(context);
      cerrarOpcion = false;
    }
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text(
            'Hoy Toca:'
        ),
        content:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.camera_roll_outlined,
                  color: primaryColor,
                ),
                SizedBox(width: 10),
                Text(genero,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 20,
                  ),
                SizedBox(width: 10),
                Icon(
                    Icons.camera_roll_outlined,
                    color: primaryColor,
                  ),
              ],
          ),
        actions: <Widget>[
          FlatButton(
            child: Text('Salir'),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ],
      );
    });
  }

  ImageSelectOption2(BuildContext context) {
    var accentColor = Theme.of(context).primaryColor;

    if(cerrarOpcion == true){
      Navigator.pop(context);
      cerrarOpcion = false;
    }
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text(
            'Hoy Comemos:'
        ),
        content:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.local_restaurant_outlined,
              color: primaryColor,
            ),
            SizedBox(width: 10),
            Text(tipo,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 20,
            ),
            SizedBox(width: 10),
            Icon(
              Icons.local_restaurant_outlined,
              color: primaryColor,
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Salir'),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ],
      );
    });
  }

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
      Platform.isAndroid ? 'com.pluscipher.mel_y_mando' : 'com.pluscipher.mel_y_mando',
      'Mel y Mando',
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
      //print("Tokeeeeeeen: $fcmToken");

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
                  color: accentColor,
                  child: Text(
                    'Abrir Galería',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: ()  async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            StreamProvider<UserData>.value(
                                value: DatabaseServiceF(uid: currentId).Thisuser,
                                child: GaleriaList(
                                  peerId: peerId,
                                  currentId: currentId,
                                )
                            )
                        )
                    );
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
                  color: accentColor,
                  child: Text(
                    'Cosas para hacer',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: ()  async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => toDoHome()));
                  },
                )
              ),
              SizedBox(width: 30),
              ButtonTheme(
                minWidth: 150.0,
                height: 100.0,
                child: RaisedButton(shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                  color: accentColor,
                  child: Text(
                    'Genero de peli \nrandom',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: ()  async {
                    Random rnd = new Random();
                    var element = lst[rnd.nextInt(lst.length)];
                    print(element); // e.g. 'Louis'
                    setState(() {
                      genero = element;
                    });
                    ImageSelectOption(context);
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
                    color: Colors.deepOrangeAccent,
                    child: Text(
                      'Abasho Virtual',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {
                    DatabaseServiceF(otheruid: peerId).MasAbrazo();
                    },
                  )
              ),
              SizedBox(width: 30),
              ButtonTheme(
                  minWidth: 150.0,
                  height: 100.0,
                  child: RaisedButton(shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                    color: accentColor,
                    child: Text(
                      'Tipo de Comida \nrandom',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: ()  async {
                      Random rnd = new Random();
                      var element = lst2[rnd.nextInt(lst2.length)];
                      print(element); // e.g. 'Louis'
                      setState(() {
                        tipo = element;
                      });
                      ImageSelectOption2(context);
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