import 'package:flutter/material.dart';
import 'package:fwitter/screens/home/home.dart';
import 'package:fwitter/screens/authenticate/authenticate.dart';
import 'package:fwitter/models/user.dart';
import 'package:fwitter/services/auth.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fwitter Home'),
        backgroundColor: Colors.blueAccent,
        elevation: 0.0,
        actions: [
          TextButton.icon(
            onPressed: () async {
              await _auth.logout();
            },
            label: Text(
              'logout',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            icon : Icon(
                Icons.person,
                color: Colors.white
            ),
          ),
          TextButton.icon(
            // TODO:
            onPressed: () {},
            label: Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            icon : Icon(
                Icons.settings,
                color: Colors.white
            ),
          ),

        ],
      ),
    );
  }
}


