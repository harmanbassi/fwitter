import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:fwitter/models/user.dart';
import 'package:fwitter/pages/home.dart';
import 'package:fwitter/widgets/avatar_widget.dart';
import 'package:fwitter/widgets/progress.dart';
import 'package:image_picker/image_picker.dart';
import 'authenticate/auth.dart' as a;

class EditProfile extends StatefulWidget {
  final String currentUserId;

  EditProfile({this.currentUserId});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  User user;
  final picker = new ImagePicker();
  File image;

  // uploads profile picture to firebase storage and fetches download url
  Future<String> uploadProfilePic(File file) async{
    var userId = a.currentUser.id;
    var uploadTask = storageRef.child("profile_pics/$userId").putFile(file);
    var completedTask = await uploadTask;
    String downloadUrl = await completedTask.ref.getDownloadURL();
    return downloadUrl;
  }

  // sets the upload profile picture to the new one, uploaded by user
  Future<void> setProfilePicture(File image) async {
    a.currentUser.photoUrl = await uploadProfilePic(image);
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  // retrieves user from firebase
  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.doc(widget.currentUserId).get();
    user = User.fromDocument(doc);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          // 'done' button in AppBar, to finish editing profile
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green,
            ),
          ),
        ],
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: 16.0,
                          bottom: 8.0,
                        ),
                        // shows profile picture, allowing user to change it on tap
                        child: Avatar(
                          photoUrl: a.currentUser?.photoUrl,
                          onTap: () async{

                            // select image from gallery
                            PickedFile pickedImage = await picker.getImage(source: ImageSource.gallery);
                            image = File(pickedImage.path);

                            // upload image to firebase storage and set it as new profile pic
                            await setProfilePicture(image);
                            await usersRef.doc('${a.currentUser.id}').update({
                              "photoUrl": a.currentUser.photoUrl,
                            });

                            setState(() {});
                          },
                        ),
                      ),
                      Text('Tap on photo to change Profile picture'),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
