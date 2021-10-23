import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valuhworld/OnlyGlobalPages/ChatsEngagePage.dart';
import 'package:valuhworld/OnlyGlobalPages/MakePaymentPage.dart';
import 'package:valuhworld/OnlyGlobalPages/PublicProfilePage.dart';
import 'package:valuhworld/OnlyGlobalPages/SearchUsersPage.dart';
import 'package:valuhworld/OnlyPersonalPages/MyCirclePage.dart';

class MyCircleListPage extends StatefulWidget {
  final String userId;
  final String userPlan;
  MyCircleListPage({this.userId, this.userPlan});

  @override
  _MyCircleListPageState createState() =>
      _MyCircleListPageState(userId: userId, userPlan: userPlan);
}

class _MyCircleListPageState extends State<MyCircleListPage> {
  String userId;
  String userPlan;
  _MyCircleListPageState({this.userId, this.userPlan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3aa792),
        title: Text(
          'My circle',
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      floatingActionButton: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('MyCircle')
              .doc(userId)
              .collection('AllFriends')
              .where('circle_action', isEqualTo: 'Accepted')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.person_add),
                foregroundColor: Colors.white,
                backgroundColor: Color(0xff47c8b0),
              );
            } else {
              if (snapshot.data.docs.length == 0) {
                return FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => SearchUsersPage(
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
                if (userPlan == '-') {
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
                  return FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => SearchUsersPage(
                            userId: userId,
                          ),
                        ),
                      );
                    },
                    child: Icon(Icons.person_add),
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xff47c8b0),
                  );
                }
              }
            }
          }),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('MyCircle')
            .doc(userId)
            .collection('AllFriends')
            .where('circle_action', isEqualTo: 'Accepted')
            .orderBy('requested_time', descending: true)
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
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot myCircle = snapshot.data.docs[index];
                  return friendItem(index, myCircle, snapshot.data.docs.length);
                },
              );
            }
          }
        },
      ),
    );
  }

  Widget emptyView() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 48,
            ),
            Text(
              'Your circle is empty',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: .5,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Click the plus button to add friends to your circle',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  fontSize: 16.0,
                  letterSpacing: .5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget friendItem(
    int index,
    DocumentSnapshot myCircle,
    int length,
  ) {
    //var height = 300.0;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .where('user_id', isEqualTo: myCircle['circle_id'])
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              index == 0
                  ? SizedBox(
                      height: 10.0,
                    )
                  : SizedBox(
                      height: 0.0,
                    ),
              Text(myCircle['circle_id'])
            ],
          );
        } else {
          if (snapshot.data.docs.length == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                index == 0
                    ? SizedBox(
                        height: 10.0,
                      )
                    : SizedBox(
                        height: 0.0,
                      ),
                Text(myCircle['circle_id'])
              ],
            );
          } else {
            DocumentSnapshot userInfo = snapshot.data.docs[0];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                index == 0
                    ? SizedBox(
                        height: 10.0,
                      )
                    : SizedBox(
                        height: 0.0,
                      ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => PublicProfilePage(
                              userId: userId,
                              secondUserId: userInfo['user_id'],
                            ),
                          ),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: userInfo['user_image'],
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white,
                              backgroundImage: imageProvider,
                            ),
                            placeholder: (context, url) => CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  AssetImage('assets/images/holder.png'),
                            ),
                            errorWidget: (context, url, error) => CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  AssetImage('assets/images/holder.png'),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${userInfo['user_name']}',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    letterSpacing: .5,
                                  ),
                                ),
                                //setCompanyName(myInterviews),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  '${userInfo['about_user']}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.quicksand(
                                    color: Colors.black87,
                                    fontSize: 14.0,
                                    letterSpacing: .5,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ButtonTheme(
                                  minWidth: double.infinity,

                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Color(0xff3aa792),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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

                                  // FlatButton(
                                  //   child: Text('Add to circle'),
                                  //   color: Colors.green,
                                  //   textColor: Colors.white,
                                  //   onPressed: () {},
                                  // ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          }
        }
      },
    );
  }
}
