import 'package:flutter/material.dart';
import 'package:fwitter/models/post.dart';

class PostTile extends StatelessWidget {

  final Post post;
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
            backgroundImage: AssetImage('assets/anon.png'),
          ),
          title: Text(post.postedBy.userName),
          subtitle: Text(post.text),
        ),
      )
    );
  }
}
