// class for user id
import 'package:flutter/cupertino.dart';

class User {

  final String uid;

  User({this.uid});

}

// class for user data
class UserData {

  final String uid;
  final String userName;
  FileImage profilePic;

  UserData({this.uid, this.userName, this.profilePic});

}