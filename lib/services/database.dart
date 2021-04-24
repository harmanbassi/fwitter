import 'dart:ui';

import 'package:fwitter/models/post.dart';
import 'package:fwitter/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseService {

  final String uid;
  DataBaseService({this.uid});

  // collection reference
  final CollectionReference postCollection = Firestore.instance.collection('posts');
  final CollectionReference userCollection = Firestore.instance.collection('users');

  // creates a new document for a newly registered uid
  // updates data for existing users
  Future updateUserData(String userName, Image profilePic) async {
    await userCollection.document(uid).setData({
      'userName': userName,
      'profilePic': profilePic
    });
  }

  // take snapshot and turn into into the list of posts
  List<Post> _postListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc) {
      return Post(
        text: doc.data['text'] ?? 'Post is empty',
        image: doc.data['image'] ?? null
      );
    }).toList();
  }

  // receive userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      userName : snapshot.data['userName'],
      profilePic : snapshot.data['profilePic']
    );
  }

  // get posts stream for changes
  Stream<List<Post>> get posts {
    return postCollection.snapshots().map(_postListFromSnapshot);
  }

  // get user doc Stream
  Stream<UserData> get userData {
    return postCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

}