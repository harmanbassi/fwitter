import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fwitter/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'package:fwitter/services/auth.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // StreamProvider allows us to access changes in auth state (from auth.dart)
    // in all widgets and provides values to wrapper
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
