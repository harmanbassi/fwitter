import 'package:fwitter/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:fwitter/screens/home/home.dart';
import 'package:fwitter/models/user.dart';
import 'package:provider/provider.dart';

// wrapper widget to decide whether to show sign in/registration or home
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // Access the user data from the provider (see main.dart)
    final user = Provider.of<User>(context);

    // return either home or authenticate
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
