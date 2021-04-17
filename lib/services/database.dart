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

}