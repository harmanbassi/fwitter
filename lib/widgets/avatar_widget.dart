import 'dart:io';

import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  String photoUrl;
  final Function onTap;

  Avatar({this.photoUrl, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: photoUrl == '' ? CircleAvatar(
          radius: 50.0,
          child: Icon(Icons.photo_camera),
        ) : CircleAvatar(
          radius: 50.0,
          backgroundImage: NetworkImage(photoUrl),
        ),
      ),
    );
  }
}
