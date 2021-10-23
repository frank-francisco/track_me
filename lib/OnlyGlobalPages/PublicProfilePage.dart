import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valuhworld/OnlyAnimations/FadeAnimations.dart';
import 'package:valuhworld/OnlyGlobalPages/ChatsEngagePage.dart';
import 'package:valuhworld/OnlyGlobalPages/MakePaymentPage.dart';
import 'package:valuhworld/OnlyGlobalPages/PublicFeedsPage.dart';
import 'package:valuhworld/OnlyPersonalPages/MyFeedsPage.dart';
import 'package:valuhworld/OnlyServices/profileData.dart';
import 'package:valuhworld/OnlyWidgets/MyPostsItem.dart';

class PublicProfilePage extends StatefulWidget {
  final String userId;
  final String secondUserId;
  PublicProfilePage({this.userId, this.secondUserId});

  @override
  _PublicProfilePageState createState() =>
      _PublicProfilePageState(userId: userId, secondUserId: secondUserId);
}

class _PublicProfilePageState extends State<PublicProfilePage> {
  String userId;
  String secondUserId;
  _PublicProfilePageState({this.userId, this.secondUserId});

  bool userFlag = false;
  var details;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOnlineUserInfo();
  }

  getOnlineUserInfo() {
    ProfileService().getProfileInfo(userId).then((QuerySnapshot docs) {
      if (docs.docs.isNotEmpty) {
        setState(
          () {
            userFlag = true;
            details = docs.docs[0].data();
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .where('user_id', isEqualTo: secondUserId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('Loading...'),
              );
            } else {
              DocumentSnapshot userInfo = snapshot.data.docs[0];

              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    expandedHeight: MediaQuery.of(context).size.width,
                    backgroundColor: Theme.of(context).primaryColor,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(userInfo['user_image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: [
                                Colors.black,
                                Colors.black.withOpacity(.3)
                              ])),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                FadeAnimation(
                                  1,
                                  Text(
                                    userInfo['user_name'],
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: .5,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              FadeAnimation(
                                1.6,
                                Text(
                                  ("About ${userInfo['user_name']}")
                                      .toUpperCase(),
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: .5,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              FadeAnimation(
                                1.6,
                                Text(
                                  userInfo['about_user'],
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      letterSpacing: .5,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              FadeAnimation(
                                1.6,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Color(0xff3aa792),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.comments,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                            SizedBox(
                                              width: 16,
                                            ),
                                            Text(
                                              'Message',
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  letterSpacing: .5,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (_) => ChatsEngagePage(
                                              userId: userId,
                                              secondUserId: userInfo['user_id'],
                                              userName: userInfo['user_name'],
                                              userImage: userInfo['user_image'],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(width: 16),
                                    StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('MyCircle')
                                          .doc(userId)
                                          .collection('AllFriends')
                                          .where('circle_id',
                                              isEqualTo: secondUserId)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xff3aa792),
                                            ),
                                            child: Center(
                                              child: SpinKitThreeBounce(
                                                color: Colors.white,
                                                size: 10.0,
                                              ),
                                            ),
                                            onPressed: () {},
                                          );
                                        } else {
                                          if (snapshot.data.docs.length == 0) {
                                            return checkIfPaid();
                                          } else {
                                            DocumentSnapshot circleInfo =
                                                snapshot.data.docs[0];
                                            return checkStatus(circleInfo,
                                                userInfo['user_name']);
                                          }
                                        }
                                      },
                                    ),
                                    // const SizedBox(width: 8),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              FadeAnimation(
                                1.6,
                                Text(
                                  '${userInfo['user_name']}\'s posts'
                                      .toUpperCase(),
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: .5,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 0,
                              ),
                              FadeAnimation(
                                1.6,
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('Feeds')
                                        .orderBy('feed_time', descending: true)
                                        .where('feed_poster',
                                            isEqualTo: secondUserId)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Center(
                                          child: SpinKitThreeBounce(
                                            color: Colors.black54,
                                            size: 20.0,
                                          ),
                                        );
                                      } else {
                                        if (snapshot.data.docs.length == 0) {
                                          return emptyView();
                                        } else {
                                          return GridView.builder(
                                            primary: false,
                                            //padding: const EdgeInsets.all(16),
                                            padding: const EdgeInsets.all(0),
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 0,
                                              childAspectRatio: (2 / 1.3),
                                              mainAxisSpacing: 0,
                                            ),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              DocumentSnapshot myFeeds =
                                                  snapshot.data.docs[index];
                                              //return Text(myFeeds['feed_image']);
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      CupertinoPageRoute(
                                                        builder: (_) =>
                                                            PublicFeedsPage(
                                                          secondUserId:
                                                              secondUserId,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: myPostsItem(
                                                    "Press releases",
                                                    myFeeds['feed_image'],
                                                  ),
                                                ),
                                              );
                                            },
                                            itemCount:
                                                snapshot.data.docs.length,
                                            shrinkWrap: true,
                                          );
                                        }
                                      }
                                    }),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            }
          }),
    );
  }

  sendCircleRequest(String userName) {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('MyCircle')
        .doc(userId)
        .collection('AllFriends')
        .doc(secondUserId);
    Map<String, dynamic> _tasks = {
      'circle_requester': userId,
      'circle_requested': secondUserId,
      'requested_time': DateTime.now().millisecondsSinceEpoch,
      'circle_action': '-',
      'circle_id': secondUserId,
      'circle_extra': 'extra',
    };
    ds.set(_tasks).whenComplete(
      () {
        print('Request sent');
      },
    );

    DocumentReference ds2 = FirebaseFirestore.instance
        .collection('MyCircle')
        .doc(secondUserId)
        .collection('AllFriends')
        .doc(userId);
    Map<String, dynamic> _tasks2 = {
      'circle_requester': userId,
      'circle_requested': secondUserId,
      'requested_time': DateTime.now().millisecondsSinceEpoch,
      'circle_action': '-',
      'circle_id': userId,
      'circle_extra': 'extra',
    };
    ds2.set(_tasks2).whenComplete(
      () {
        print('Request received sent');
      },
    );
    _sendNotification(userName);
  }

  Widget checkStatus(DocumentSnapshot circleInfo, String userName) {
    if (circleInfo['circle_requested'] == userId) {
      if (circleInfo['circle_action'] == '-') {
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('MyCircle')
                .doc(userId)
                .collection('AllFriends')
                .where('circle_action', isEqualTo: 'Accepted')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xff3aa792),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.userPlus,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        'Accept request',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {},
                );
              } else {
                if (snapshot.data.docs.length == 0) {
                  return TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xff3aa792),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.userPlus,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          'Accept request',
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      acceptRequest();
                    },
                  );
                } else {
                  if (details[['user_plan']] == '-') {
                    return FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => MakePaymentPage(
                              userId: userId,
                            ),
                          ),
                        );
                      },
                      child: Icon(Icons.person_add),
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xff47c8b0),
                    );
                  } else {
                    return TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xff3aa792),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.userPlus,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            'Accept request',
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: .5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        acceptRequest();
                      },
                    );
                  }
                }
              }
            });
      } else {
        return TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.redAccent,
          ),
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.userInjured,
                color: Colors.white,
                size: 16,
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                'Unfriend',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            removeFromCircle();
          },
        );
      }
    } else {
      if (circleInfo['circle_action'] == '-') {
        return TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.black87,
          ),
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.userAltSlash,
                color: Colors.white,
                size: 16,
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                'Cancel request',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            removeFromCircle();
          },
        );
      } else {
        return TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.redAccent,
          ),
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.userInjured,
                color: Colors.white,
                size: 16,
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                'Unfriend',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            removeFromCircle();
          },
        );
      }
    }
  }

  acceptRequest() {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('MyCircle')
        .doc(userId)
        .collection('AllFriends')
        .doc(secondUserId);
    Map<String, dynamic> _tasks = {
      'circle_requester': userId,
      'circle_requested': secondUserId,
      'requested_time': DateTime.now().millisecondsSinceEpoch,
      'circle_action': 'Accepted',
      'circle_id': secondUserId,
      'circle_extra': 'extra',
    };
    ds.set(_tasks).whenComplete(
      () {
        print('Request accepted');
      },
    );

    DocumentReference ds2 = FirebaseFirestore.instance
        .collection('MyCircle')
        .doc(secondUserId)
        .collection('AllFriends')
        .doc(userId);
    Map<String, dynamic> _tasks2 = {
      'circle_requester': userId,
      'circle_requested': secondUserId,
      'requested_time': DateTime.now().millisecondsSinceEpoch,
      'circle_action': 'Accepted',
      'circle_id': userId,
      'circle_extra': 'extra',
    };
    ds2.set(_tasks2).whenComplete(
      () {
        print('Request accepted');
      },
    );
  }

  removeFromCircle() {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('MyCircle')
        .doc(userId)
        .collection('AllFriends')
        .doc(secondUserId);
    ds.delete().then((value) => print("Circle Deleted")).catchError(
          (error) => print("Failed to delete user: $error"),
        );

    DocumentReference ds2 = FirebaseFirestore.instance
        .collection('MyCircle')
        .doc(secondUserId)
        .collection('AllFriends')
        .doc(userId);
    ds2.delete().then((value) => print("Circle Deleted")).catchError(
          (error) => print("Failed to delete user: $error"),
        );
  }

  Widget checkIfPaid() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('MyCircle')
            .doc(userId)
            .collection('AllFriends')
            .where('circle_action', isEqualTo: 'Accepted')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xff3aa792),
              ),
              child: Center(
                child: SpinKitThreeBounce(
                  color: Colors.white,
                  size: 10.0,
                ),
              ),
              onPressed: () {},
            );
          } else {
            if (snapshot.data.docs.length == 0) {
              return TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xff3aa792),
                ),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.userPlus,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      'Add to circle',
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: .5,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  sendCircleRequest(details['user_name']);
                },
              );
            } else {
              if (details['user_plan'] == '-') {
                return TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xff3aa792),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.userPlus,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        'Add to circle',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => MakePaymentPage(
                          userId: userId,
                        ),
                      ),
                    );
                  },
                );
              } else {
                return TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xff3aa792),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.userPlus,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        'Add to circle',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    sendCircleRequest(details['user_name']);
                  },
                );
              }
            }
          }
        });
  }

  Widget emptyView() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 48,
          ),
          Container(
            width: double.infinity,
            child: Text(
              'This post list is empty',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 18.0,
                  //fontWeight: FontWeight.bold,
                  letterSpacing: .5,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  _sendNotification(String userName) {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('Notifications')
        .doc('important')
        .collection(secondUserId)
        .doc();
    Map<String, dynamic> tasks = {
      'notification_tittle': 'New request!',
      'notification_details':
          '$userName sent you a request to join his circle, visit their profile to act.',
      'notification_time': DateTime.now().millisecondsSinceEpoch,
      'notification_sender': 'Valuhworld',
      'action_title': 'Request',
      'action_destination': '',
      'latitudes': '',
      'longitudes': '-',
      'action_key': '',
      'post_id': 'extra',
    };
    ds.set(tasks).whenComplete(() {
      print('Notification sent');
      DocumentReference ds =
          FirebaseFirestore.instance.collection('Users').doc(secondUserId);
      Map<String, dynamic> _tasks = {
        'notification_count': FieldValue.increment(1),
      };
      ds.update(_tasks).whenComplete(() {
        print('notification count updated');
      });
    });
    _sendTrigger();
  }

  _sendTrigger() {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('Notifications')
        .doc('important')
        .collection(secondUserId)
        .doc();
    Map<String, dynamic> tasks = {
      'notification_tittle': 'New trigger!',
      'notification_details': 'This is a notification trigger',
      'notification_time': 0,
      'notification_sender': 'invisible',
      'action_title': 'invisible',
      'action_destination': '',
      'latitudes': '',
      'longitudes': '-',
      'action_key': '',
      'post_id': 'extra',
    };
    ds.set(tasks);
  }
}
