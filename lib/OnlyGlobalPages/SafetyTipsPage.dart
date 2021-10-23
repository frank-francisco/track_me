import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valuhworld/OnlyGlobalPages/AddSafetyTipPage.dart';

class SafetyTipsPage extends StatefulWidget {
  final String userId;
  SafetyTipsPage({
    this.userId,
  });

  @override
  _SafetyTipsPageState createState() => _SafetyTipsPageState(
        userId: userId,
      );
}

class _SafetyTipsPageState extends State<SafetyTipsPage> {
  String userId;
  _SafetyTipsPageState({
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3aa792),
        title: Text(
          'Safety tips',
          style: GoogleFonts.quicksand(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => AddSafetyTipPage(
                userId: userId,
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
            .collection('Tips')
            .orderBy('tip_time', descending: true)
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
                  return tipItem(index, myFeeds, snapshot.data.docs.length);
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
              'Empty safety tips',
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
              'The list of safety tips is currently empty, press the plus icon to add one.',
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

  Widget tipItem(int index, DocumentSnapshot myFeeds, int length) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Text(
                    (index + 1).toString() + '. ',
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .where('user_id', isEqualTo: myFeeds['tip_poster'])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Flexible(
                        child: RichText(
                          text: TextSpan(
                            text: 'Loading...',
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                letterSpacing: .5,
                              ),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: myFeeds['tip_description']
                                    .toString()
                                    .trim(),
                                style: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: .5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      if (snapshot.data.docs.length == 0) {
                        return Flexible(
                          child: RichText(
                            text: TextSpan(
                              text: 'USER NOT FOUND',
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: .5,
                                ),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: myFeeds['tip_description']
                                      .toString()
                                      .trim(),
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.normal,
                                      letterSpacing: .5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        DocumentSnapshot myUser = snapshot.data.docs[0];
                        return Flexible(
                          child: RichText(
                            text: TextSpan(
                              text: myUser['user_name'] + ': ',
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: .5,
                                ),
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: myFeeds['tip_description']
                                      .toString()
                                      .trim(),
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.normal,
                                      letterSpacing: .5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 4.0,
        ),
      ],
    );
  }
}
