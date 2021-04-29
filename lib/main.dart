import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fwitter/pages/authenticate/auth.dart';
import 'package:fwitter/pages/home.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as f;
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<f.User>.value(
    value: AuthService().user,
    child: MaterialApp(
      title: 'Fwitter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.teal,
      ),
      home: Home(),
    ),
    );
  }
}
