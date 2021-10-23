import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:measured_size/measured_size.dart';
import 'package:valuhworld/OnlyServices/profileData.dart';
import 'package:valuhworld/OnlyServices/time_ago_since_now_en.dart';

class FeedCommentsPage extends StatefulWidget {
  var postSnap;
  final String feedId;
  final String userId;
  FeedCommentsPage({this.postSnap, this.feedId, this.userId});

  @override
  _FeedCommentsPageState createState() => _FeedCommentsPageState(
        postSnap: postSnap,
        feedId: feedId,
        userId: userId,
      );
}

class _FeedCommentsPageState extends State<FeedCommentsPage> {
  var postSnap;
  String feedId;
  String userId;
  _FeedCommentsPageState({this.postSnap, this.feedId, this.userId});

  TextEditingController textEditingController = new TextEditingController();
  String _message = '';
  var height = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3aa792),
        title: Text(
          'Comments',
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: Container(
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.grey[100],
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('FeedsComments')
                  .doc(feedId)
                  .collection('Comments')
                  .orderBy('comment_time', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: SpinKitThreeBounce(
                        color: Colors.black54,
                        size: 20.0,
                      ),
                    ),
                  );
                } else {
                  if (snapshot.data.docs.length == 0) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Image(
                            image: AssetImage('assets/images/empty.png'),
                            width: double.infinity,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,

                      ///reverse: true,
                      // physics: NeverScrollableScrollPhysics(),
                      // primary: false,
                      padding: EdgeInsets.zero,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot myComments = snapshot.data.docs[index];
                        return commentItem(
                            index, myComments, snapshot.data.docs.length);
                      },
                    );
                  }
                }
              },
            ),
          ),
          Positioned(
            bottom: 10.0,
            left: 10.0,
            right: 10.0,
            child: MeasuredSize(
              onChange: (Size size) {
                setState(() {
                  print(size);
                  height = size.height;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                //height: 58,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: textEditingController,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: null,
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black54,
                              letterSpacing: .5,
                            ),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Comment',
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 0.0),
                            errorStyle: TextStyle(color: Colors.brown),
                          ),
                          onChanged: (val) {
                            setState(() => _message = val);
                          },
                          validator: (val) =>
                              val.length < 1 ? ('Too short') : null,
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      InkWell(
                        onTap: () {
                          _submitComment();
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(right: 8.0, bottom: 20),
                          child: Icon(
                            Icons.send_rounded,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget commentItem(int index, DocumentSnapshot myComments, int length) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .where('user_id', isEqualTo: myComments['comment_owner'])
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          if (snapshot.data.docs.length == 0) {
            return Container();
          } else {
            DocumentSnapshot userInfo = snapshot.data.docs[0];
            return Padding(
              padding: index == length - 1
                  ? EdgeInsets.only(bottom: height + 26)
                  : EdgeInsets.only(bottom: 0),
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      imageUrl: userInfo['user_image'],
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.green,
                        child: CircleAvatar(
                          radius: 17,
                          backgroundColor: Colors.white,
                          backgroundImage: imageProvider,
                        ),
                      ),
                      placeholder: (context, url) => CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.green,
                        child: CircleAvatar(
                          radius: 17,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage(
                            'assets/images/holder.jpg',
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.green,
                        child: CircleAvatar(
                          radius: 17,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
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
                                    text: ' ${myComments['comment_body']}',
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
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                timeAgoSinceDateEn(
                                  DateTime.fromMillisecondsSinceEpoch(
                                    myComments['comment_time'],
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
                        ],
                      ),
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

  _submitComment() {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('FeedsComments')
        .doc(feedId)
        .collection('Comments')
        .doc();
    Map<String, dynamic> _tasks = {
      'comment_owner': userId,
      'comment_read': '-',
      'comment_time': DateTime.now().millisecondsSinceEpoch,
      'comment_body': _message.trim(),
      'comment_id': ds.id,
      'comment_extra': 'extra',
    };
    ds.set(_tasks).whenComplete(
      () {
        print('Message sent');
        textEditingController.text = '';
      },
    );

    DocumentReference ds2 =
        FirebaseFirestore.instance.collection('Feeds').doc(feedId);
    Map<String, dynamic> tasks2 = {
      'feed_comments_count': FieldValue.increment(1),
    };
    ds2.update(tasks2).whenComplete(() {
      print('Comment count incremented');
    });

    _sendNotification();
  }

  _sendNotification() {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('Notifications')
        .doc('important')
        .collection(postSnap['feed_poster'])
        .doc();
    Map<String, dynamic> tasks = {
      'notification_tittle': 'New Comment!',
      'notification_details':
          'Somebody commented on your post, visit the feeds page to see comments.',
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
          .doc(postSnap['feed_poster']);
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
        .collection(postSnap['feed_poster'])
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
