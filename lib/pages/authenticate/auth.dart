import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as f;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fwitter/models/user.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final Reference storageRef = FirebaseStorage.instance.ref();
final DateTime timestamp = DateTime.now();
User currentUser;

Future<String> getDefaultUrl() async {
  var defaultUrl = await storageRef.child("profile_pics/anon.png").getDownloadURL();
  return defaultUrl;
}

// class to handle authentication with firebase
class AuthService {

  final f.FirebaseAuth _auth = f.FirebaseAuth.instance;

  Stream<f.User> get user {
    return _auth.authStateChanges();
  }

  // sign in with email(username) and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      f.UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      f.User user = result.user;
      DocumentSnapshot doc = await usersRef.doc(user.uid).get();
      currentUser = User.fromDocument(doc);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      f.UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      usersRef.doc('${result.user.uid}').set({
        "id": result.user.uid,
        "username": email.substring(0, email.indexOf('@')),
        "photoUrl": await getDefaultUrl(),
        "timestamp": timestamp
      });

      f.User user = result.user;
      DocumentSnapshot doc = await usersRef.doc(user.uid).get();
      currentUser = User.fromDocument(doc);
      return user;
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