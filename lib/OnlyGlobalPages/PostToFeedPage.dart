import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valuhworld/OnlyAnimations/FadeAnimations.dart';
import 'package:valuhworld/OnlyGlobalPages/HomePage.dart';

class PostToFeedPage extends StatefulWidget {
  final File image;
  final int height;
  final int width;
  PostToFeedPage({this.image, this.height, this.width});
  @override
  _PostToFeedPageState createState() =>
      _PostToFeedPageState(image: image, height: height, width: width);
}

class _PostToFeedPageState extends State<PostToFeedPage> {
  File image;
  int height;
  int width;
  _PostToFeedPageState({this.image, this.height, this.width});

  var top = 0.0;
  bool _loading = false;
  String _date = DateTime.now().millisecondsSinceEpoch.toString();
  String _uploadedFileURL;
  String onlineUserId;
  String onlineUserEmail;
  String _caption = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            centerTitle: true,
            expandedHeight: MediaQuery.of(context).size.width * height / width,
            backgroundColor: Theme.of(context).primaryColor,
            pinned: true,
            floating: false,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                top = constraints.biggest.height;
                return FlexibleSpaceBar(
                  title: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: top < 120.0 ? 1.0 : 0.0,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 80,
                      child: Text(
                        'Post image',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  centerTitle: true,
                  collapseMode: CollapseMode.pin,
                  background: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [
                            Colors.black,
                            Colors.black.withOpacity(.1),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 16,
                      ),
                      FadeAnimation(
                        1,
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.name,
                          maxLength: 600,
                          maxLines: null,
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black54,
                              letterSpacing: .5,
                            ),
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'Caption',
                            contentPadding: const EdgeInsets.all(0.0),
                            errorStyle: TextStyle(color: Colors.brown),
                          ),
                          onChanged: (val) {
                            setState(() => _caption = val.trim());
                          },
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      FadeAnimation(
                        1.2,
                        _loading
                            ? Container(
                                decoration: new BoxDecoration(
                                    color: Color(0xff3aa792),
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(4.0))),
                                width: double.infinity,
                                height: 48.0,
                                child: Center(
                                  child: SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                ),
                              )
                            : ButtonTheme(
                                height: 48,
                                minWidth: double.infinity,
                                child: FlatButton(
                                  color: Color(0xff3aa792),
                                  child: Text(
                                    'Submit',
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: .5,
                                      ),
                                    ),
                                  ),
                                  shape: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff3aa792), width: 2),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    setState(() => _loading = true);
                                    _startUpload();
                                  },
                                ),
                              ),
                      ),
                      SizedBox(
                        height: 60,
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
      ),
    );
  }

  Future<void> _startUpload() async {
    final User user = FirebaseAuth.instance.currentUser;
    final uid = user.uid;
    final userEmail = user.email;

    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      await storage.ref('FeedImages/$_date.jpg').putFile(image);
      print('File Uploaded');

      String downloadURL =
          await storage.ref('FeedImages/$_date.jpg').getDownloadURL();

      setState(
        () {
          _uploadedFileURL = downloadURL;
          onlineUserId = uid;
          onlineUserEmail = userEmail;
          createFeed();
        },
      );
    } on FirebaseException catch (e) {
      final snackBar = SnackBar(
        content: Text(
          e.message,
          textAlign: TextAlign.center,
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
      setState(() {
        _loading = false;
      });
    }
  }

  createFeed() {
    DocumentReference ds = FirebaseFirestore.instance.collection('Feeds').doc();
    Map<String, dynamic> tasks = {
      'feed_image': _uploadedFileURL,
      'feed_caption': _caption,
      'feed_time': DateTime.now().millisecondsSinceEpoch,
      'feed_comments_count': 0,
      'feed_likes_count': 0,
      'image_height': height,
      'image_width': width,
      'feed_poster': onlineUserId,
      'feed_poster_email': onlineUserEmail,
      'feed_id': ds.id,
    };
    ds.set(tasks).whenComplete(() {
      postComment(ds.id);
    });
  }

  postComment(String id) {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('FeedsComments')
        .doc(id)
        .collection('Comments')
        .doc();
    Map<String, dynamic> _tasks = {
      'comment_owner': onlineUserId,
      'comment_read': '-',
      'comment_time': DateTime.now().millisecondsSinceEpoch,
      'comment_body': _caption,
      'comment_id': ds.id,
      'comment_extra': 'extra',
    };
    ds.set(_tasks).whenComplete(() {
      print('Comment sent');
      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) => HomePage(),
          ),
          (r) => false);
    });
  }
}
