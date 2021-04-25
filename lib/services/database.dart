import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fwitter/models/post.dart';
import 'package:fwitter/models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';


class DataBaseService {

  final String uid;
  DataBaseService({this.uid});

  // collection reference
  final CollectionReference postCollection = FirebaseFirestore.instance.collection('posts');
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  // creates a new document for a newly registered uid
  Future newUserData(String userName) async {
    await userCollection.doc(uid).set({
      'userName' : userName
    });
  }

  // updates data for existing users
  Future updateUserData(String userName, Reference firebaseStorageRef) async {
    await userCollection.doc(uid).set({
      'userName': userName,
      'reference' : firebaseStorageRef
    });
  }

  // TODO
  // take snapshot and turn into into the list of posts
  List<UserData> _postListFromSnapshot (QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserData(
        uid: uid,
        userName: doc.data()['userName'] ?? '',
      );
    }).toList();
  }

  // receive userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      userName : snapshot.data()['userName'],
    );
  }

  //TODO
  // get posts stream for changes
  Stream<List<UserData>> get users {
    return userCollection.snapshots().map(_postListFromSnapshot);
  }

  // get user doc Stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

}