import 'package:flutter/material.dart';
import 'package:fwitter/models/post.dart';
import 'package:fwitter/models/user.dart';

class PostTile extends StatelessWidget {

  // TODO
  final UserData post;
  PostTile({this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.red,
            // TODO
            backgroundImage: post.profilePic
          ),
          title: Text(post.userName),

        ),
      )
    );
  }
}
