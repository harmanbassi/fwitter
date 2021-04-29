import 'package:fwitter/pages/authenticate/auth.dart';
import 'package:fwitter/shared/constants.dart';
import 'package:fwitter/shared/loading.dart';
import 'package:flutter/material.dart';

// classes to handle sign in
class SignIn extends StatefulWidget {

  // helps to toggle between sign in and registration screens (see authenticate)
  final Function toggleView;
  final Function setIsAuth;
  SignIn({this.toggleView, this.setIsAuth});

  @override
  _SignInState createState() => _SignInState();
}

// sign in widgets, similar to registration widgets
class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // boolean to show loading screen
  bool loading = false;

  // text field states
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    // checks to see whether to show loading screen or not
    return loading ? Loading() : Scaffold(
      // basic scaffold with app bar
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          title: Text('Sign in to Fwitter'),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          // button to toggle to register screen from app bar
          actions: [
            TextButton.icon(
              onPressed: () {
                widget.toggleView();
              },
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              label: Text(
                'Register',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 60.0),
          // main sign in form
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20.0),
                // email field
                TextFormField(
                  // see constants.dart for decoration specs
                    decoration: textInputDecoration.copyWith(hintText: 'username'),
                    // makes sure field is not left empty
                    validator: (val) => val.isEmpty ? 'Enter a username' : null,
                    onChanged: (val) {
                      /*
                      tricks firebase registerWithEmailAndPassword function into
                      thinking user name is a valid email (easier than making a
                      custom function)
                      */
                      setState(() => email = '${val}@fwitter.com');
                    }
                ),
                SizedBox(height: 20.0),
                // password field
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Password'),
                  // makes sure password contains more than 6 characters
                  validator: (val) =>
                  val.length < 6
                      ?
                  'Enter a password, which is at least 6 characters long'
                      : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  child: Text('Sign in',),
                  onPressed: () async {
                    // works if it receives null from validators
                    if (_formKey.currentState.validate()) {
                      // go to loading screen while waiting for authentication
                      setState(() => loading = true);
                      // auth change causes login (see auth.dart)
                      dynamic result = await _auth.signInWithEmailAndPassword(
                          email, password);
                      if (result == null) {
                        setState(() {
                          // returns to sign in screen if login details do not correspond with
                          // Firebase data
                          error = 'Could not sign in with given username/password';
                          loading = false;
                        });
                      }
                    }
                  },
                  // appearance of sign in button
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.black;
                        return Colors.blueAccent;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 12.0),
                // error message in case of wrong login details
                Text(
                  error,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}