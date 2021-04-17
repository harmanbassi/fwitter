import 'package:fwitter/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'database.dart';

// class to handle authentication with firebase
class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create User object based on FirebaseUser
  User _userFromFirebaseUser (FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // user stream to determine changes in Firebase auth
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }

  // sign in with email(username) and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      // TODO: Create new document for registered user
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future logout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

}