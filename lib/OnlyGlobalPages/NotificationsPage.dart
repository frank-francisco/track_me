import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valuhworld/OnlyGlobalPages/ViewLocationPage.dart';
import 'package:valuhworld/OnlyServices/time_ago_since_now_en.dart';
import 'package:valuhworld/OnlyServices/time_ago_since_now_ro.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future _data;
  String _onlineUserId;

  Future _getUsers() async {
    final User user = _firebaseAuth.currentUser;
    setState(() {
      _onlineUserId = user.uid;
    });
    var _fireStore = FirebaseFirestore.instance;
    QuerySnapshot qn = await _fireStore
        .collection('Notifications')
        .doc('important')
        .collection(_onlineUserId)
        .orderBy('notification_time', descending: true)
        .get();
    return qn.docs;
  }

  @override
  void initState() {
    super.initState();
    _data = _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3aa792),
        title: Text(
          'Notifications',
          style: GoogleFonts.quicksand(),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Notifications')
              .doc('important')
              .collection(_onlineUserId)
              .orderBy('notification_time', descending: true)
              .where('notification_time', isNotEqualTo: 0)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: SpinKitThreeBounce(
                  color: Colors.grey,
                  size: 20.0,
                ),
              );
            } else {
              if (snapshot.data.docs.length == 0) {
                return Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Image(
                      image: AssetImage('assets/images/empty.png'),
                      width: double.infinity,
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot myNotifications =
                        snapshot.data.docs[index];
                    return _displayNotifications(index, myNotifications);
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }

  Widget _displayNotifications(index, myNotifications) {
    return Padding(
      padding: index == 0
          ? EdgeInsets.only(left: 10, right: 10, bottom: 16, top: 16)
          : EdgeInsets.only(left: 10, right: 10, bottom: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          //color: Color(0xffe7f3f9),
          border: Border.all(
            color: Colors.green,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                myNotifications['notification_tittle'],
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: .5,
                  ),
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                myNotifications['notification_details'],
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    letterSpacing: .5,
                  ),
                ),
              ),
              SizedBox(
                height: 4.0,
              ),
              myNotifications['action_title'] == 'SOS'
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xff3aa792),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.locationArrow,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Text(
                                'View location',
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
                          _viewOnMap(myNotifications['latitudes'],
                              myNotifications['longitudes']);
                        },
                      ),
                    )
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    timeAgoSinceDateEn(
                      DateTime.fromMillisecondsSinceEpoch(
                              myNotifications['notification_time'])
                          .toString(),
                    ),
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
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _viewOnMap(double latitudes, double longitudes) {
    // Navigator.push(
    //   context,
    //   CupertinoPageRoute(
    //     builder: (_) => ViewLocationPage(
    //       latitudes: latitudes,
    //       longitudes: longitudes,
    //     ),
    //   ),
    // );
    MapsLauncher.launchCoordinates(latitudes, longitudes);
    print(latitudes.toString() + ' and ' + longitudes.toString());
  }
}
