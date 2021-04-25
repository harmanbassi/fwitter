import 'package:flutter/material.dart';
import 'package:fwitter/services/auth.dart';
import 'package:fwitter/shared/constants.dart';
import 'package:fwitter/shared/loading.dart';

// handling of registration for new users
class Register extends StatefulWidget {

  // helps to toggle between sign in and registration screens
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

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
          title: Text('Sign up to Fwitter'),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          // button to toggle to sign in screen from app bar
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
                'Sign In',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 60.0),
          // main registration form
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
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  // makes sure password contains more than 6 characters
                  validator: (val) => val.length < 6 ?
                  'Enter a password, which is at least 6 characters long' : null,
                  obscureText: true,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                SizedBox(height: 20.0),
                // 'Register' button
                ElevatedButton(
                  child: Text('Register',),
                  onPressed: () async {
                    // works if it receives null from validators
                    if(_formKey.currentState.validate()) {
                      // go to loading screen while waiting for authentication
                      setState(() => loading = true);
                      // auth change causes login (see auth.dart)
                      dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                      if(result == null) {
                        setState(() {
                          // returns to registration screen if Firebase decides user name has been used
                          error = 'username is taken or \'@\' (not allowed) used in username';
                          loading = false;
                        });
                      }
                    }
                  },
                  // appearance of register button
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if(states.contains(MaterialState.pressed))
                          return Colors.black;
                        return Colors.blueAccent;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 12.0),
                // error message, in case of invalid email
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
