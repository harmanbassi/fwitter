import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  String photoUrl;

  User({
    this.id,
    this.username,
    this.photoUrl,
  });

  // allows for the creation of a User directly form a firebase document
  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'],
      username: doc['username'],
      photoUrl: doc['photoUrl'],
    );
  }
}
