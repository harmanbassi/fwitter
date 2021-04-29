import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fwitter/models/user.dart';
import 'package:fwitter/pages/home.dart';
import 'package:fwitter/pages/search.dart';
import 'package:fwitter/widgets/post.dart';
import 'package:fwitter/widgets/progress.dart';
import 'authenticate/auth.dart' as a;

final usersRef = FirebaseFirestore.instance.collection('users');

class Timeline extends StatefulWidget {
  final User currentUser;

  Timeline({this.currentUser});

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Post> posts;
  List<String> followingList = [];
  final a.AuthService _auth = a.AuthService();

  @override
  void initState() {
    super.initState();
    getTimeline();
    // getFollowing();
  }

  getTimeline() async {
    QuerySnapshot snapshot = await timelineRef
        .doc(a.currentUser.id)
        .collection('timelinePosts')
        .orderBy('timestamp', descending: true)
        .get();
    List<Post> posts =
        snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    setState(() {
      this.posts = posts;
    });
  }
  //
  // getFollowing() async {
  //   QuerySnapshot snapshot = await followingRef
  //       .doc(currentUser.id)
  //       .collection('userFollowing')
  //       .get();
  //   setState(() {
  //     followingList = snapshot.docs.map((doc) => doc.documentID).toList();
  //   });
  // }

  buildTimeline() {
    if (posts == null) {
      return circularProgress();
    } else if (posts.isEmpty) {
      return buildUsersToFollow();
    } else {
      return ListView(children: posts);
    }
  }

  buildUsersToFollow() {
    return StreamBuilder(
      stream:
          usersRef.orderBy('timestamp', descending: true).limit(30).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<UserResult> userResults = [];
        snapshot.data.docs.forEach((doc) {
          User user = User.fromDocument(doc);
          final bool isAuthUser = a.currentUser.id == user.id;
          final bool isFollowingUser = followingList.contains(user.id);
          // remove auth user from recommended list
          if (isAuthUser) {
            return;
          } else if (isFollowingUser) {
            return;
          } else {
            UserResult userResult = UserResult(user);
            userResults.add(userResult);
          }
        });
        return Container(
          color: Theme.of(context).accentColor.withOpacity(0.2),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.person_add,
                      color: Theme.of(context).primaryColor,
                      size: 30.0,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "Users to Follow",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
              Column(children: userResults),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
        key: _scaffoldKey,
      backgroundColor: Colors.blue[50],
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
        ]
    ),
        body: RefreshIndicator(
            onRefresh: () => getTimeline(), child: buildTimeline()));
  }
}
