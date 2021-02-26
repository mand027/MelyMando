import 'package:mel_y_mando/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthService{

  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  //create user based on firebase user
  User _userFromFirebaseUser(auth.User user){
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream (if sign in or sign out)
  Stream<User> get user{
    print('User changed');
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      var result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      var user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print("Error ${e.toString()}");
      return null;
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(String email, String password) async{
    try{
      var result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      var user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print("Error ${e.toString()}");
      return null;
    }
  }

  //Recover Password
  Future recoverPasswordWithMail(String email) async{
    try{
      var result = await _auth.sendPasswordResetEmail(email: email);
      return result;
    }catch(e){
      print("Error ${e.toString()}");
      return null;
    }
  }

  //sign out

  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print("Error ${e.toString()}");
    }
  }
}