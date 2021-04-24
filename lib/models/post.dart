import 'package:flutter/cupertino.dart';
import 'package:fwitter/models/user.dart';

class Post {
  final String text;
  final Image image;
  final UserData postedBy;

  Post({this.text, this.image, this.postedBy});
}