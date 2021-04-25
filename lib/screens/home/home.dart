import 'package:flutter/material.dart';
import 'package:fwitter/models/post.dart';
import 'package:fwitter/models/user.dart';
import 'package:fwitter/screens/home/post_list.dart';
import 'package:fwitter/screens/home/settings_form.dart';
import 'package:fwitter/services/auth.dart';
import 'package:fwitter/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          color: Colors.blue[50],
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: SettingsForm(),
        );
      });
    }

    // allows access to data from database
    return
    //TODO
      StreamProvider<List<UserData>>.value(
      value: DataBaseService().users,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Fwitter Home'),
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          actions: [
            // Logout Button
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
            // Settings Button
            TextButton.icon(
              onPressed: () => _showSettingsPanel(),
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
        body: Container(
          child: PostList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () { },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}


