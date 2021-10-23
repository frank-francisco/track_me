import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valuhworld/OnlyGlobalPages/ChatsEngagePage.dart';
import 'package:valuhworld/OnlyGlobalPages/PublicProfilePage.dart';
import 'package:valuhworld/OnlyGlobalPages/SearchUsersPage.dart';
import 'package:valuhworld/OnlyServices/time_ago_since_now_en.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _onlineUserId;

  @override
  void initState() {
    super.initState();
    manageUser();
  }

  manageUser() async {
    final User user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _onlineUserId = user.uid;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('MyChatHeads')
          .doc(_onlineUserId)
          .collection('Heads')
          .orderBy('head_time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: SpinKitThreeBounce(
                color: Colors.black54,
                size: 20.0,
              ),
            ),
          );
        } else {
          if (snapshot.data.docs.length == 0) {
            return Scaffold(
              body: placeHolder(),
            );

            placeHolder();
          } else {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) => SearchUsersPage(
                        userId: _onlineUserId,
                      ),
                    ),
                  );
                },
                child: Icon(Icons.contacts_rounded),
                foregroundColor: Colors.white,
                backgroundColor: Color(0xff47c8b0),
              ),
              body: ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot myChatHeads = snapshot.data.docs[index];
                  return chatHeadItem(
                      index, myChatHeads, snapshot.data.docs.length);
                },
              ),
            );
          }
        }
      },
    );
  }

  Widget chatHeadItem(int index, DocumentSnapshot myChatHeads, int length) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .where('user_id', isEqualTo: myChatHeads['head_subject'])
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
            return Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: Image(
                        height: 48,
                        width: 48,
                        image: AssetImage('assets/images/holder.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'User not found',
                            style: GoogleFonts.quicksand(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              letterSpacing: .5,
                            ),
                          ),
                          //setCompanyName(myInterviews),
                          SizedBox(
                            height: 4.0,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => ChatsEngagePage(
                                    userId: _onlineUserId,
                                    secondUserId: myChatHeads['head_subject'],
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              '${myChatHeads['head_last_message']}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.quicksand(
                                color: Colors.black87,
                                fontSize: 16.0,
                                letterSpacing: .5,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            DocumentSnapshot secondUserInfo = snapshot.data.docs[0];
            return Container(
              //color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Column(
                  children: [
                    index == 0
                        ? SizedBox(
                            height: 6,
                          )
                        : SizedBox(
                            height: 0,
                          ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => ChatsEngagePage(
                              userId: _onlineUserId,
                              secondUserId: myChatHeads['head_subject'],
                              userName: secondUserInfo['user_name'],
                              userImage: secondUserInfo['user_image'],
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => PublicProfilePage(
                                    userId: _onlineUserId,
                                    secondUserId: secondUserInfo['user_id'],
                                  ),
                                ),
                              );
                            },
                            child: CachedNetworkImage(
                              imageUrl: secondUserInfo['user_image'],
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white,
                                backgroundImage: imageProvider,
                              ),
                              placeholder: (context, url) => CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.green,
                                child: CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.white,
                                  backgroundImage: AssetImage(
                                    'assets/images/holder.png',
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.green,
                                child: CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.white,
                                  backgroundImage: AssetImage(
                                    'assets/images/holder.png',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '${secondUserInfo['user_name']}',
                                        style: GoogleFonts.quicksand(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                          letterSpacing: .5,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      timeAgoSinceDateEn(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          myChatHeads['head_time'],
                                        ).toString(),
                                      ),
                                      //postSnap['press_formatted_date'],
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //setCompanyName(myInterviews),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  '${myChatHeads['head_last_message']}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.quicksand(
                                    color: Colors.black87,
                                    fontSize: 16.0,
                                    letterSpacing: .5,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    index == length - 1
                        ? Container()
                        : Divider(
                            //color: Colors.red,
                            ),
                    index == length - 1
                        ? SizedBox(
                            height: 4,
                          )
                        : SizedBox(
                            height: 0,
                          ),
                  ],
                ),
              ),
            );
          }
        }
      },
    );
  }

  Widget placeHolder() {
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
              'Send messages \nto friends and family',
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
              'Send instant messages to your circle of friends and your family, valuhworld offers you with an easy way to interact with friends. Share your unforgettable moments with your circle of friends,',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  fontSize: 16.0,
                  letterSpacing: .5,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  color: Color(0xff3aa792),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    side: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                  child: Text(
                    'New message',
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => SearchUsersPage(
                          userId: _onlineUserId,
                        ),
                      ),
                    );
                  },
                ),
                // const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
