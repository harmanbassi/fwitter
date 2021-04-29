import 'package:fwitter/pages/authenticate/sign_in.dart';
import 'package:fwitter/pages/authenticate/register.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

// class to decide whether to show sign in or registration screen
class _AuthenticateState extends State<Authenticate> {

  // decides which screen is shown
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    // depends on boolean(set by button press on respective scree) to decide which screen is shown
    if(showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}