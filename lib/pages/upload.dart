import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fwitter/models/user.dart';
import 'package:fwitter/pages/home.dart';
import 'package:fwitter/widgets/post.dart';
import 'package:fwitter/widgets/progress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'authenticate/auth.dart' as a;

class Upload extends StatefulWidget {
  final User currentUser;

  Upload({this.currentUser});

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload>
    with AutomaticKeepAliveClientMixin<Upload> {
  TextEditingController captionController = TextEditingController();
  PickedFile file;
  bool isUploading = false;
  String postId = Uuid().v4();
  final picker = new ImagePicker();
  File image;
  String mediaUrl;
  Post currentPost;
  bool isFweet;
  String fweetText;
  bool isSplash = true;

  Container buildSplashScreen() {
    return Container(
      color: Colors.blue[50],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset('assets/upload.svg', height: 260.0),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Colors.lightBlueAccent)
                      ),
                  ),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Colors.black;
                    return Colors.blueAccent;
                  },
                ),
              ),
                child: Text(
                  "Upload Image",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                  ),
                ),
                onPressed: () async {
                isFweet = false;
                isSplash = false;
                  // select image from gallery
                  PickedFile pickedImage = await picker.getImage(source: ImageSource.gallery);
                  image = File(pickedImage.path);

                  // upload image to firebase storage
                  await handleSubmit();

                  setState(() {});
                }
            ),
          ),
          ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: Colors.lightBlueAccent)
                  ),
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Colors.black;
                    return Colors.blueAccent;
                  },
                ),
              ),
              child: Text(
                "Upload Fweet",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                ),
              ),
              onPressed: () {
                isFweet = true;
                isSplash = false;
                setState(() {});
              }
          ),
        ],
      ),
    );
  }

  clearImage() {
    setState(() {
      image = null;
    });
  }

  Future<String> uploadImage(File file) async{
    var uploadTask = storageRef.child("posts/$postId").putFile(file);
    var completedTask = await uploadTask;
    String downloadUrl = await completedTask.ref.getDownloadURL();
    return downloadUrl;
  }

  createPostInFirestore(
      {String mediaUrl, String description}) async {
    mediaUrl = await uploadImage(image);
    postsRef
        .doc(a.currentUser.id)
        .collection("userPosts")
        .doc(postId)
        .set({
      "postId": postId,
      "ownerId": widget.currentUser.id,
      "username": widget.currentUser.username,
      "mediaUrl": mediaUrl,
      "description": description,
      "timestamp": a.timestamp,
      "likes": {},
    });
    DocumentSnapshot doc = await postsRef.doc(a.currentUser.id)
        .collection("userPosts")
        .doc(postId).get();
    currentPost = Post.fromDocument(doc);
  }

  // handles submission of image posts
  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    mediaUrl = await uploadImage(image);
    isUploading = false;
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: clearImage),
        title: Text(
          "Text",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: isUploading ? null : () {
                createPostInFirestore(
                  mediaUrl: mediaUrl,
                  description: captionController.text,
                );
                setState(() {
                  captionController.clear();
                  image = null;
                  postId = Uuid().v4();
                });
                isSplash = true;
              },
            child: Text(
              "Post",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          isUploading ? linearProgress() : Text(""),
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(File(image.path)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(a.currentUser.photoUrl),
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: captionController,
                decoration: InputDecoration(
                  hintText: "Say something meaningful",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Scaffold buildFweetUploadForm()  {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
               captionController.clear();
               isSplash = true;
               setState(() {});
              }
          ),
          title: Text(
            "Post Fweet",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await postsRef
                    .doc(a.currentUser.id)
                    .collection("userPosts")
                    .doc(postId)
                    .set({
                "postId": postId,
                "ownerId": widget.currentUser.id,
                "username": widget.currentUser.username,
                "mediaUrl": '',
                "description": captionController.text,
                "timestamp": a.timestamp,
                "likes": {},
                });
                DocumentSnapshot doc = await postsRef.doc(a.currentUser.id)
                    .collection("userPosts")
                    .doc(postId).get();
                currentPost = Post.fromDocument(doc);
                isSplash = true;
                setState(() {});
              },
              child: Text(
                "Post",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
        body: ListTile(
          leading: CircleAvatar(
            backgroundImage:
            CachedNetworkImageProvider(a.currentUser.photoUrl),
          ),
          title: Container(
            width: 250.0,
            child: TextField(
              controller: captionController,
              decoration: InputDecoration(
                hintText: "Say something meaningful",
                border: InputBorder.none,
              ),
            ),
          ),
        ),
    );
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return isSplash ? buildSplashScreen() : isFweet? buildFweetUploadForm()
        : buildUploadForm();
  }
}
