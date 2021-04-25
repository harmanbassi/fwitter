import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fwitter/services/database.dart';
import 'package:fwitter/shared/loading.dart';
import 'package:fwitter/models/user.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';


// class to set actions of the settings panel
class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  File _image;
  final _picker = new ImagePicker();
  Reference firebaseStorageRef;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    // allow user to crop image
    _cropImage(PickedFile pickedFile) async {
      File cropped = await ImageCropper.cropImage(sourcePath: pickedFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio16x9,
        CropAspectRatioPreset.ratio4x3,
      ],
      );
      if (cropped != null) {
        setState(() {
          _image = cropped;
        });
      }
    }

    // load from Image Picker
    _loadPicker(ImageSource source) async {
      final pickedFile = await _picker.getImage(source: source);
      if(pickedFile != null) {
        _cropImage(pickedFile);
      }
      Navigator.pop(context);
    }

    // dialog to pick image
    void _showPickOptionsDialog(BuildContext context) {
      showDialog(context: context,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Pick from Gallery"),
                onTap: () {
                  _loadPicker(ImageSource.gallery);
                },
              ),
              ListTile(
                title: Text("Take a picture"),
                onTap: () {
                  _loadPicker(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      );
    }

    //upload selected image to firebase storage
    Future uploadPic(BuildContext context) async {
      String fileName = basename(_image.path);
      firebaseStorageRef = FirebaseStorage.instance.ref().child(
        fileName
      );
      UploadTask uploadTask = firebaseStorageRef.putFile(_image);
      TaskSnapshot taskSnapshot = await uploadTask;
    }

    // access data from userData
    return StreamBuilder<UserData>(
      stream: DataBaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData) {

          UserData userData = snapshot.data;

          return Container(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 80.0,
                  backgroundImage: _image != null ? FileImage(_image)
                  : null,
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                    onPressed: () async {
                      // pick an image from gallery/camera
                      _showPickOptionsDialog(context);
                    },
                  child: Text(
                    'Pick Image',
                    style: TextStyle(color: Colors.white),
                  ),
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
                SizedBox(height: 20.0),
                ElevatedButton(
                  // TODO
                  // set image as profile picture
                  onPressed: () async {
                    uploadPic(context);
                    print(firebaseStorageRef.child(basename(_image.path)));
                    // await DataBaseService(uid: user.uid).updateUserData(
                    //     userData.userName,
                    //     firebaseStorageRef.child(basename(_image.path))
                    // );
                  },
                  child: Text(
                    'Set Profile Picture',
                    style: TextStyle(color: Colors.white),
                  ),
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
              ],
            ),
          );
        } else {
          return Loading();
        }
      }
    );
  }
}
