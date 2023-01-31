import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:melymando2/models/TaskToDo.dart';
import 'package:melymando2/models/userdata.dart';

class DatabaseServiceF {
  final String? uid;
  final String? otheruid;
  UserData? thisUser;

  DatabaseServiceF({this.uid, this.thisUser, this.otheruid});

  //collection reference
  //Users
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference toDoCollection =
      FirebaseFirestore.instance.collection("toDo");

//Get Thisuser data
  UserData _ThisUserSnapshot(DocumentSnapshot snapshot) {
    var user = UserData(
      nombre: snapshot['nombre'],
      ouid: snapshot['idPareja'],
      uid: snapshot.id,
      fotoURLS: snapshot['fotos'],
    );
    return user;
  }

  //Get Thisuser stream
  Stream<UserData> get Thisuser {
    return usersCollection.doc(uid).snapshots().map(_ThisUserSnapshot);
  }

  Stream<UserData> get parejaUser {
    return usersCollection.doc(otheruid).snapshots().map(_ThisUserSnapshot);
  }

  //Get tasks data
  List<Task> _taskListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((task) {
      return Task(
        description: task['descripcion'],
        isDone: task['isDone'],
        id: task.id,
      );
    }).toList();
  }

  //Get mis autos stream
  Stream<List<Task>> get tasksNotDone {
    return toDoCollection
        .where('isDone', isEqualTo: false)
        .snapshots()
        .map(_taskListFromSnapshot);
  }

  Stream<List<Task>> get tasksDone {
    return toDoCollection
        .where('isDone', isEqualTo: true)
        .snapshots()
        .map(_taskListFromSnapshot);
  }

  //Update user
  Future UpdateUserData(String name, String mailOther, String mail) async {
    String idPareja;
    bool registreAntes = true;
    var other =
        await usersCollection.where('miMail', isEqualTo: mailOther).get();
    if (other.docs.isNotEmpty) {
      registreAntes = false;
      idPareja = other.docs.first.id;
    } else {
      idPareja = '';
    }
    if (registreAntes) {
      return await usersCollection.doc(uid).set({
        'nombre': name,
        'miMail': mail,
        'mailPareja': mailOther,
        'idPareja': '',
        'id': uid
      }, SetOptions(merge: true));
    } else {
      await usersCollection.doc(uid).set({
        'nombre': name,
        'miMail': mail,
        'mailPareja': mailOther,
        'idPareja': idPareja,
        'id': uid
      }, SetOptions(merge: true));

      return await usersCollection.doc(idPareja).set({
        'idPareja': uid,
      }, SetOptions(merge: true));
    }
  }

  Future TokenDevice(String _fcm) async {
    return await usersCollection.doc(uid).set({
      'pushToken': _fcm,
    }, SetOptions(merge: true));
  }

  Future addPhotos(String url) async {
    var list = <String>[];
    list.add(url);
    // no need of the file extension, the name will do fine.
    await usersCollection.doc(uid).set({
      'fotos': FieldValue.arrayUnion(list),
    }, SetOptions(merge: true));

    return await usersCollection.doc(otheruid).set({
      'fotos': FieldValue.arrayUnion(list),
    }, SetOptions(merge: true));
  }

  Future addTask(String descripcion) async {
    return await toDoCollection.doc().set({
      'descripcion': descripcion,
      'isDone': false,
    }, SetOptions(merge: true));
  }

  Future setTaskDoneUndone(String id, bool newState) async {
    return await toDoCollection.doc(id).set({
      'isDone': newState,
    }, SetOptions(merge: true));
  }

  Future MasAbrazo() async {
    return await usersCollection.doc(otheruid).set({
      'abrazos': FieldValue.increment(1),
    }, SetOptions(merge: true));
  }
}
