import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:measured_size/measured_size.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:valuhworld/OnlyAnimations/FadeAnimations.dart';
import 'package:valuhworld/OnlyGlobalPages/FeedCommentsPage.dart';
import 'package:valuhworld/OnlyGlobalPages/PostToFeedPage.dart';
import 'package:valuhworld/OnlyGlobalPages/SelectFromGalleryPage.dart';
import 'package:valuhworld/OnlyServices/time_ago_since_now_en.dart';

class FeedsPage extends StatefulWidget {
  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String onlineUserId;

  @override
  void initState() {
    super.initState();
    manageUser();
  }

  manageUser() async {
    final User user = _auth.currentUser;
    if (user != null) {
      setState(() {
        onlineUserId = user.uid;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => SelectFromGalleryPage(
                  //userId: _onlineUserId,
                  ),
            ),
          );
        },
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: Color(0xff47c8b0),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Feeds')
            .orderBy('feed_time', descending: true)
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
                  DocumentSnapshot myFeeds = snapshot.data.docs[index];
                  return feedItem(index, myFeeds, snapshot.data.docs.length);
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
              'Lead your circle \nbefore another one does',
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
              'Be the first in your circle to post on the news feed, it is a one time chance your are lucky to have it. Press the camera icon to post on the feed.',
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

  Widget feedItem(
    int index,
    DocumentSnapshot myFeeds,
    int length,
  ) {
    //var height = 300.0;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .where('user_id', isEqualTo: myFeeds['feed_poster'])
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: (MediaQuery.of(context).size.width - 16) *
                          myFeeds['image_height'] /
                          myFeeds['image_width'],
                      child: CachedNetworkImage(
                        imageUrl: myFeeds['feed_image'],
                        imageBuilder: (context, imageProvider) => Image(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        placeholder: (context, url) => Image(
                          image: AssetImage('assets/images/place_holder.png'),
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => Image(
                          image: AssetImage('assets/images/place_holder.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    loadLiker(myFeeds['feed_id'], myFeeds),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => FeedCommentsPage(
                          feedId: myFeeds['feed_id'],
                          userId: onlineUserId,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: 'https://picsum.photos/300/300/?blur',
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.green,
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.white,
                                backgroundImage: imageProvider,
                              ),
                            ),
                            placeholder: (context, url) => CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.green,
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(
                                  'assets/images/holder.jpg',
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.green,
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(
                                  'assets/images/holder.jpg',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                  text: '...',
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: .5,
                                    ),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ' ${myFeeds['feed_caption']}',
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          letterSpacing: .5,
                                        ),
                                      ),
                                    ),
                                  ]),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),

                            // Text(
                            //   myFeeds['feed_caption'],
                            //   style: GoogleFonts.quicksand(
                            //     textStyle: TextStyle(
                            //       fontSize: 16.0,
                            //       color: Colors.black87,
                            //       letterSpacing: .5,
                            //     ),
                            //   ),
                            //   maxLines: 2,
                            //   overflow: TextOverflow.ellipsis,
                            //   textAlign: TextAlign.start,
                            // ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            myFeeds['feed_likes_count'].toString() + ' likes',
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 0,
                          ),
                          Text(
                            myFeeds['feed_comments_count'].toString() +
                                ' comment(s)',
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Text(
                            timeAgoSinceDateEn(
                              DateTime.fromMillisecondsSinceEpoch(
                                myFeeds['feed_time'],
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
                      SizedBox(
                        height: 18,
                      ),
                    ],
                  ),
                ),
              )
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: (MediaQuery.of(context).size.width - 16) *
                            myFeeds['image_height'] /
                            myFeeds['image_width'],
                        child: CachedNetworkImage(
                          imageUrl: myFeeds['feed_image'],
                          imageBuilder: (context, imageProvider) => Image(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                          placeholder: (context, url) => Image(
                            image: AssetImage('assets/images/place_holder.png'),
                            fit: BoxFit.cover,
                          ),
                          errorWidget: (context, url, error) => Image(
                            image: AssetImage('assets/images/place_holder.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      loadLiker(myFeeds['feed_id'], myFeeds),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => FeedCommentsPage(
                            postSnap: myFeeds,
                            feedId: myFeeds['feed_id'],
                            userId: onlineUserId,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: 'https://picsum.photos/300/300/?blur',
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.green,
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.white,
                                  backgroundImage: imageProvider,
                                ),
                              ),
                              placeholder: (context, url) => CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.green,
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.white,
                                  backgroundImage: AssetImage(
                                    'assets/images/holder.jpg',
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.green,
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.white,
                                  backgroundImage: AssetImage(
                                    'assets/images/holder.jpg',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                    text: '...',
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: .5,
                                      ),
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: ' ${myFeeds['feed_caption']}',
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            letterSpacing: .5,
                                          ),
                                        ),
                                      ),
                                    ]),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                              ),

                              // Text(
                              //   myFeeds['feed_caption'],
                              //   style: GoogleFonts.quicksand(
                              //     textStyle: TextStyle(
                              //       fontSize: 16.0,
                              //       color: Colors.black87,
                              //       letterSpacing: .5,
                              //     ),
                              //   ),
                              //   maxLines: 2,
                              //   overflow: TextOverflow.ellipsis,
                              //   textAlign: TextAlign.start,
                              // ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              myFeeds['feed_likes_count'].toString() + ' likes',
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 0,
                            ),
                            Text(
                              myFeeds['feed_comments_count'].toString() +
                                  ' comment(s)',
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Text(
                              timeAgoSinceDateEn(
                                DateTime.fromMillisecondsSinceEpoch(
                                  myFeeds['feed_time'],
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
                        SizedBox(
                          height: 18,
                        ),
                      ],
                    ),
                  ),
                )
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: (MediaQuery.of(context).size.width - 16) *
                            myFeeds['image_height'] /
                            myFeeds['image_width'],
                        child: CachedNetworkImage(
                          imageUrl: myFeeds['feed_image'],
                          imageBuilder: (context, imageProvider) => Image(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                          placeholder: (context, url) => Image(
                            image: AssetImage('assets/images/place_holder.png'),
                            fit: BoxFit.cover,
                          ),
                          errorWidget: (context, url, error) => Image(
                            image: AssetImage('assets/images/place_holder.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      loadLiker(myFeeds['feed_id'], myFeeds),
                      loadReport(myFeeds['feed_id']),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8.0,
                      ),
                      Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: userInfo['user_image'],
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.green,
                              child: CircleAvatar(
                                radius: 13,
                                backgroundColor: Colors.white,
                                backgroundImage: imageProvider,
                              ),
                            ),
                            placeholder: (context, url) => CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.green,
                              child: CircleAvatar(
                                radius: 13,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(
                                  'assets/images/holder.jpg',
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.green,
                              child: CircleAvatar(
                                radius: 13,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(
                                  'assets/images/holder.jpg',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                  text: userInfo['user_name'],
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: .5,
                                    ),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ' ${myFeeds['feed_caption']}',
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          letterSpacing: .5,
                                        ),
                                      ),
                                    ),
                                  ]),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            ),

                            // Text(
                            //   myFeeds['feed_caption'],
                            //   style: GoogleFonts.quicksand(
                            //     textStyle: TextStyle(
                            //       fontSize: 16.0,
                            //       color: Colors.black87,
                            //       letterSpacing: .5,
                            //     ),
                            //   ),
                            //   maxLines: 2,
                            //   overflow: TextOverflow.ellipsis,
                            //   textAlign: TextAlign.start,
                            // ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            myFeeds['feed_likes_count'].toString() + ' likes',
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 0,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => FeedCommentsPage(
                                    feedId: myFeeds['feed_id'],
                                    userId: onlineUserId,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              myFeeds['feed_comments_count'].toString() +
                                  ' comment(s)',
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            timeAgoSinceDateEn(
                              DateTime.fromMillisecondsSinceEpoch(
                                myFeeds['feed_time'],
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
                      SizedBox(
                        height: 18,
                      ),
                    ],
                  ),
                )
              ],
            );
          }
        }
      },
    );
  }

  Widget loadLiker(String feedId, DocumentSnapshot myFeeds) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('FeedLikes')
          .doc(feedId)
          .collection('Likes')
          .where('liker_id', isEqualTo: onlineUserId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Positioned(
            bottom: 16.0,
            left: 10.0,
            child: Icon(
              CupertinoIcons.hand_thumbsup,
              color: Colors.white,
            ),
          );
        } else {
          if (snapshot.data.docs.length == 0) {
            return Positioned(
              bottom: 16.0,
              left: 10.0,
              child: InkWell(
                onTap: () {
                  addLike(feedId, myFeeds);
                },
                child: Icon(
                  CupertinoIcons.hand_thumbsup,
                  color: Colors.white,
                ),
              ),
            );
          } else {
            return Positioned(
              bottom: 16.0,
              left: 10.0,
              child: InkWell(
                onTap: () {
                  removeLike(feedId);
                },
                child: Icon(
                  CupertinoIcons.hand_thumbsup_fill,
                  color: Colors.white,
                ),
              ),
            );
            ;
          }
        }
      },
    );
  }

  addLike(String feedId, DocumentSnapshot myFeeds) {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('FeedLikes')
        .doc(feedId)
        .collection('Likes')
        .doc(onlineUserId);
    Map<String, dynamic> _tasks = {
      'liker_id': onlineUserId,
      'liked_time': DateTime.now().millisecondsSinceEpoch,
      'like_id': onlineUserId,
      'like_extra': 'extra',
    };
    ds.set(_tasks).whenComplete(
      () {
        print('Like added');
      },
    );

    DocumentReference ds2 =
        FirebaseFirestore.instance.collection('Feeds').doc(feedId);
    Map<String, dynamic> tasks2 = {
      'feed_likes_count': FieldValue.increment(1),
    };
    ds2.update(tasks2).whenComplete(() {
      print('like counted added');
    });
    _sendNotification(myFeeds);
  }

  removeLike(String feedId) {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('FeedLikes')
        .doc(feedId)
        .collection('Likes')
        .doc(onlineUserId);
    ds.delete().then((value) => print("Like removed")).catchError(
          (error) => print("Failed to delete like: $error"),
        );

    DocumentReference ds2 =
        FirebaseFirestore.instance.collection('Feeds').doc(feedId);
    Map<String, dynamic> tasks2 = {
      'feed_likes_count': FieldValue.increment(-1),
    };
    ds2.update(tasks2).whenComplete(() {
      print('like counted subtracted');
    });
  }

  //report

  Widget loadReport(String feedId) {
    return Positioned(
      bottom: 16.0,
      right: 10.0,
      child: InkWell(
        onTap: () {
          _showBottomSheet();
        },
        child: Icon(
          CupertinoIcons.exclamationmark_circle,
          color: Colors.white,
        ),
      ),
    );
  }

  _showBottomSheet() {
    showCupertinoModalBottomSheet(
      expand: false,
      context: context,
      builder: (context) => Material(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 16,
              ),
              Text(
                'Why are you reporting this content?',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // Container(
              //   height: 2,
              //   width: MediaQuery.of(context).size.width / 2,
              //   color: Colors.black54,
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              Divider(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _toast();
                },
                child: Text(
                  'Spam or Scam',
                  style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              Divider(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  _toast();
                },
                child: Text(
                  'Inappropriate content',
                  style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _toast() {
    Fluttertoast.showToast(
      msg: "Report submitted",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  _sendNotification(DocumentSnapshot myFeeds) {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('Notifications')
        .doc('important')
        .collection(myFeeds['feed_poster'])
        .doc();
    Map<String, dynamic> tasks = {
      'notification_tittle': 'New Like!',
      'notification_details':
          'Somebody liked your post, visit the feeds page to see comments and likes.',
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
      DocumentReference ds = FirebaseFirestore.instance
          .collection('Users')
          .doc(myFeeds['feed_poster']);
      Map<String, dynamic> _tasks = {
        'notification_count': FieldValue.increment(1),
      };
      ds.update(_tasks).whenComplete(() {
        print('notification count updated');
      });
    });
    _sendTrigger(myFeeds);
  }

  _sendTrigger(DocumentSnapshot myFeeds) {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('Notifications')
        .doc('important')
        .collection(myFeeds['feed_poster'])
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
