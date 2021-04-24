import 'package:flutter/material.dart';
import 'package:fwitter/services/database.dart';
import 'package:fwitter/shared/loading.dart';
import 'package:fwitter/models/user.dart';
import 'package:fwitter/shared/constants.dart';
import 'package:provider/provider.dart';

// class to set actions of the settings panel
class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formkey = GlobalKey<FormState>();

  String _currentName;
  Image _currentImage;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
