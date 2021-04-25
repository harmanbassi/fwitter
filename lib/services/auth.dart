import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:fwitter/models/user.dart' as u;
import 'package:firebase_auth/firebase_auth.dart';

import 'database.dart';

// class to handle authentication with firebase
class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final AssetImage profilePic = AssetImage('/assets/anon.png');

  // create User object based on FirebaseUser
  u.User _userFromFirebaseUser (User user) {
    return user != null ? u.User(uid: user.uid) : null;
  }

  // user stream to determine changes in Firebase auth
  Stream<u.User> get user {
    return _auth.authStateChanges()
        .map(_userFromFirebaseUser);
  }

  // sign in with email(username) and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      // create new document for registered user
      await DataBaseService(uid: user.uid).newUserData(email.substring(0, email.indexOf('@')));
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