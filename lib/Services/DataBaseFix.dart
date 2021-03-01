
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mel_y_mando/models/userdata.dart';

class DatabaseServiceF {

  final String uid;
  final String otheruid;
  UserData thisUser;

  DatabaseServiceF({this.uid, this.thisUser, this.otheruid});

  //collection reference
  //Users
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");

//Get Thisuser data
  UserData _ThisUserSnapshot(DocumentSnapshot snapshot){

    var user = UserData(
      nombre: snapshot.data()['nombre'] ?? '',
      ouid: snapshot.data()['idPareja'] ?? '',
      uid: snapshot.id,
    );
    user.fotoURLS = snapshot.data()['fotos'] ?? List<dynamic>();
    return user;
  }

  //Get Thisuser stream
  Stream<UserData> get Thisuser{
    return usersCollection.doc(uid).snapshots().map(_ThisUserSnapshot);
  }

  Stream<UserData> get parejaUser{
    return usersCollection.doc(otheruid).snapshots().map(_ThisUserSnapshot);
  }

  //Update user
  Future UpdateUserData(String name, String mailOther, String mail) async {
    var idPareja;
    bool registreAntes = true;
    var other = await usersCollection.where('miMail', isEqualTo: mailOther).get();
    if(other.docs.isNotEmpty) {
      registreAntes = false;
      idPareja = other.docs.first.id;
    } else{
      idPareja = '';
    }
    if (registreAntes){
      return await usersCollection.doc(uid).set({
        'nombre': name,
        'miMail' : mail,
        'mailPareja': mailOther,
        'idPareja' : '',
        'id': uid
      }, SetOptions(merge: true));
    }
    else{
      await usersCollection.doc(uid).set({
        'nombre': name,
        'miMail' : mail,
        'mailPareja': mailOther,
        'idPareja' : idPareja,
        'id': uid
      }, SetOptions(merge: true));

      return await usersCollection.doc(idPareja).set({
        'idPareja' : uid,
      }, SetOptions(merge: true));
    }
  }

  Future TokenDevice(String _fcm) async {
    return await usersCollection.doc(uid).set({
      'pushToken': _fcm,
    }, SetOptions(merge: true));
  }

  Future addPhotos(String url) async{
    var list = List<String>();
    list.add(url);
    // no need of the file extension, the name will do fine.
    await usersCollection.doc(uid).set({
      'fotos': FieldValue.arrayUnion(list),
    }, SetOptions(merge: true));

    return await usersCollection.doc(otheruid).set({
      'fotos': FieldValue.arrayUnion(list),
    }, SetOptions(merge: true));
  }

}