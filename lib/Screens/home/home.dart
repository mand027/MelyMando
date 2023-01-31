import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:melymando2/Screens/Galeria/Galeria.dart';
import 'package:melymando2/Screens/ToDoList/ToDoHome.dart';
import 'package:melymando2/Screens/chat/widget/loading.dart';
import 'package:melymando2/Services/DataBaseFix.dart';
import 'package:melymando2/Services/auth.dart';
import 'package:melymando2/models/userdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final misDatos = Provider.of<UserData>(context);
    final String oid = misDatos.ouid;
    if (oid == '') {
      return const Loading();
    } else {
      return StreamProvider<UserData?>.value(
          value: DatabaseServiceF(otheruid: oid).parejaUser,
          //hear for everytime a document changes in users
          initialData: null,
          child: Helper(misDatos: misDatos));
    }
  }
}

class Helper extends StatefulWidget {
  final UserData misDatos;
  const Helper({Key? key, required this.misDatos}) : super(key: key);
  @override
  _HelperState createState() => _HelperState(misDatos: misDatos);
}

class _HelperState extends State<Helper> {
  bool cerrarOpcion = false;
  var genero = '';
  var lst = [
    'Accion',
    'Aventura',
    'Catastrofe',
    'Ciencia Ficcion',
    'Documental',
    'Drama',
    'Fantasia',
    'Musical',
    'Suspenso',
    'Terror',
    'Animada',
    'Anime',
    'Serie',
    'Romance',
    'Comedia',
    'Independiente',
    'Superheroes',
    'Basada en Libro'
  ];

  var tipo = '';
  var lst2 = [
    'Tex Mex',
    'BBQ',
    'Ramen',
    'Arabe',
    'Japonesa',
    'Carnes',
    'China',
    'Hamburguesa',
    'Italiana',
    'Taiwanesa',
    'Yucateca',
    'Oaxaqueña',
    'Bajio',
    'Norteña',
    'Qesadillas (masaoso)',
    'Dinner Mexicano',
    'Pizza',
    'Pollo (kfc, carbon...)',
    'Tacos',
    'Alitas',
    'Sushi',
    'Tortas (algo con pan)',
    'Europea',
    'Americana',
    'Griega',
    'Española',
    'Brasileña',
    'Koreana',
    'India',
    'Comida Corrida'
  ];

  ImageSelectOption(BuildContext context) {
    if (cerrarOpcion == true) {
      Navigator.pop(context);
      cerrarOpcion = false;
    }
    return showDialog(
      context: context,
      builder: (context) {
        final ButtonStyle flatButtonStyle = TextButton.styleFrom(
          foregroundColor: Colors.white,
          minimumSize: const Size(88, 44),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
          ),
          backgroundColor: Colors.blue,
        );
        return AlertDialog(
          title: const Text('Hoy Toca:'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.camera_roll_outlined,
                color: Color(0xff4c2882),
              ),
              const SizedBox(width: 10),
              Text(
                genero,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 20,
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.camera_roll_outlined,
                color: Color(0xff4c2882),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: flatButtonStyle,
              child: const Text('Salir'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  ImageSelectOption2(BuildContext context) {
    var accentColor = Theme.of(context).primaryColor;
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      foregroundColor: Colors.white,
      minimumSize: const Size(88, 44),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
      backgroundColor: Colors.blue,
    );
    if (cerrarOpcion == true) {
      Navigator.pop(context);
      cerrarOpcion = false;
    }
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hoy Comemos:'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.local_restaurant_outlined,
                color: accentColor,
              ),
              const SizedBox(width: 10),
              Text(
                tipo,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 20,
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.local_restaurant_outlined,
                color: accentColor,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: flatButtonStyle,
              child: const Text('Salir'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  _HelperState({required this.misDatos});

  final FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  UserData misDatos;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      foregroundColor: Colors.white,
      minimumSize: const Size(88, 44),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
      backgroundColor: Colors.blue,
    );

    final AuthService _auth = AuthService();
    final parejaUser = Provider.of<UserData>(context);
    var accentColor = Theme.of(context).accentColor;
    final peerId = parejaUser.uid;
    final currentId = misDatos.uid;

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "${parejaUser.nombre} y ${misDatos.nombre}",
                ), //cambiar por logo nuev
              ),
            ),
            Expanded(
              child: TextButton.icon(
                style: flatButtonStyle,
                label: const Text('',
                    style: TextStyle(color: Colors.white, fontSize: 10)),
                onPressed: () async {
                  _auth.signOut();
                },
                icon: const Icon(
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
      body: Column(
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
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: accentColor,
                  child: const Text(
                    'Abrir Galería',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StreamProvider<UserData?>.value(
                          value: DatabaseServiceF(uid: currentId).Thisuser,
                          initialData: null,
                          child: GaleriaList(
                            peerId: peerId,
                            currentId: currentId,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ButtonTheme(
                minWidth: 150.0,
                height: 100.0,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: accentColor,
                  child: const Text(
                    'Cosas para hacer',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => toDoHome()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 30),
              ButtonTheme(
                minWidth: 150.0,
                height: 100.0,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: accentColor,
                  child: const Text(
                    'Genero de peli \nrandom',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () async {
                    Random rnd = Random();
                    var element = lst[rnd.nextInt(lst.length)];
                    print(element); // e.g. 'Louis'
                    setState(() {
                      genero = element;
                    });
                    ImageSelectOption(context);
                  },
                ),
              )
            ],
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ButtonTheme(
                minWidth: 150.0,
                height: 100.0,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.deepOrangeAccent,
                  child: const Text(
                    'Abasho Virtual',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    DatabaseServiceF(otheruid: peerId).MasAbrazo();
                  },
                ),
              ),
              const SizedBox(width: 30),
              ButtonTheme(
                minWidth: 150.0,
                height: 100.0,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: accentColor,
                  child: const Text(
                    'Tipo de Comida \nrandom',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () async {
                    Random rnd = Random();
                    var element = lst2[rnd.nextInt(lst2.length)];
                    print(element); // e.g. 'Louis'
                    setState(
                      () {
                        tipo = element;
                      },
                    );
                    ImageSelectOption2(context);
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
