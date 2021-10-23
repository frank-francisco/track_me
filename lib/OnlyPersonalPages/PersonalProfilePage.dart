import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valuhworld/OnlyAnimations/FadeAnimations.dart';
import 'package:valuhworld/OnlyGlobalPages/SelectFromGalleryPage.dart';
import 'package:valuhworld/OnlyPersonalPages/MyFeedsPage.dart';
import 'package:valuhworld/OnlyPersonalPages/PersonalUpdateProfile.dart';
import 'package:valuhworld/OnlyWidgets/MyPostsItem.dart';
import 'package:valuhworld/OnlyWidgets/NewAddCorneredButton.dart';

class PersonalProfilePage extends StatefulWidget {
  final String userId;
  final userSnap;
  PersonalProfilePage({this.userId, this.userSnap});

  @override
  _PersonalProfilePageState createState() =>
      _PersonalProfilePageState(userId: userId, userSnap: userSnap);
}

class _PersonalProfilePageState extends State<PersonalProfilePage> {
  String userId;
  var userSnap;
  _PersonalProfilePageState({this.userId, this.userSnap});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .where('user_id', isEqualTo: userId)
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
                                ]),
                          ),
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
                                FadeAnimation(
                                  1.2,
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.email_outlined,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Text(
                                          userInfo['user_email'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              letterSpacing: .5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                                height: 30,
                              ),
                              FadeAnimation(
                                1.6,
                                Text(
                                  'My posts'.toUpperCase(),
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
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('Feeds')
                                      .orderBy('feed_time', descending: true)
                                      .where('feed_poster', isEqualTo: userId)
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
                                                          MyFeedsPage(),
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
                                          itemCount: snapshot.data.docs.length,
                                          shrinkWrap: true,
                                          // crossAxisSpacing: 16,
                                          // mainAxisSpacing: 16,
                                          // crossAxisCount: 2,
                                          // childAspectRatio: (2 / 1.3),
                                          // children: <Widget>[
                                          //   InkWell(
                                          //     onTap: () {
                                          //       // Navigator.push(
                                          //       //   context,
                                          //       //   CupertinoPageRoute(
                                          //       //     builder: (_) => EditorPressTasksPage(
                                          //       //       userId: userId,
                                          //       //     ),
                                          //       //   ),
                                          //       // );
                                          //     },
                                          //     child: myPostsItem(
                                          //       "Press releases",
                                          //       'https://picsum.photos/seed/picsum/200/300',
                                          //     ),
                                          //   ),
                                          //   InkWell(
                                          //     onTap: () {
                                          //       // Navigator.push(
                                          //       //   context,
                                          //       //   CupertinoPageRoute(
                                          //       //     builder: (_) => EditorInterviewTasksPage(),
                                          //       //   ),
                                          //       // );
                                          //     },
                                          //     child: myPostsItem(
                                          //       "Press releases",
                                          //       'https://picsum.photos/id/237/200/300',
                                          //     ),
                                          //   ),
                                          //   InkWell(
                                          //     onTap: () {
                                          //       // Navigator.push(
                                          //       //   context,
                                          //       //   CupertinoPageRoute(
                                          //       //     builder: (_) => AddStoriesPage(),
                                          //       //   ),
                                          //       // );
                                          //     },
                                          //     child: myPostsItem(
                                          //       "Press releases",
                                          //       'https://picsum.photos/200/300/?blur',
                                          //     ),
                                          //   ),
                                          //   InkWell(
                                          //     onTap: () {
                                          //       // Navigator.push(
                                          //       //   context,
                                          //       //   CupertinoPageRoute(
                                          //       //     builder: (_) => EditorApproveEventsPage(),
                                          //       //   ),
                                          //       // );
                                          //     },
                                          //     child: myPostsItem(
                                          //       "Press releases",
                                          //       'https://picsum.photos/200/300?grayscale',
                                          //     ),
                                          //   ),
                                          // ],
                                        );
                                      }
                                    }
                                  }),
                              SizedBox(
                                height: 40,
                              ),
                              FadeAnimation(
                                2,
                                InkWell(
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 0.0),
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Color(0xff3aa792),
                                        width: 2,
                                      ),
                                    ),
                                    child: Align(
                                      child: Text(
                                        'Update profile',
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            color: Color(0xff3aa792),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            letterSpacing: .5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (_) => PersonalUpdateProfile(
                                          userSnap: userSnap,
                                          userId: userId,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
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

  Widget emptyView() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 48,
          ),
          Text(
            'You haven\'t posted anything yet',
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                letterSpacing: .5,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Text(
              'Press the plus icon to post your first post on the feeds.',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  fontSize: 16.0,
                  letterSpacing: .5,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => SelectFromGalleryPage(
                      //userId: _onlineUserId,
                      ),
                ),
              );
            },
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[400],
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
