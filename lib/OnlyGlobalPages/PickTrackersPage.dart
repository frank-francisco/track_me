import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class PickTrackersPage extends StatefulWidget {
  final double latitudes;
  final double longitudes;
  final String userId;
  PickTrackersPage({this.latitudes, this.longitudes, this.userId});

  @override
  _PickTrackersPageState createState() => _PickTrackersPageState(
      latitudes: latitudes, longitudes: longitudes, userId: userId);
}

class _PickTrackersPageState extends State<PickTrackersPage> {
  double latitudes;
  double longitudes;
  String userId;
  _PickTrackersPageState({this.latitudes, this.longitudes, this.userId});

  List listOfUid = [];
  bool _isConnected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3aa792),
        title: Text(
          'Send your live location',
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('MyCircle')
            .doc(userId)
            .collection('AllFriends')
            .orderBy('requested_time', descending: true)
            .where('circle_action', isEqualTo: 'Accepted')
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
                  DocumentSnapshot myCircle = snapshot.data.docs[index];
                  return _circleItem(
                      index, myCircle, snapshot.data.docs.length);
                },
              );
            }
          }
        },
      ),
    );
  }

  Widget _circleItem(
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
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: 'https://picsum.photos/200/300/?blur',
                        imageBuilder: (context, imageProvider) => CircleAvatar(
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
                              'LOADING',
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
                              'This user is being loaded from the database',
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
                                        'Send live location',
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
                                  //send Location
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
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl: 'https://picsum.photos/200/300/?blur',
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
                                'USER NOT FOUND',
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
                                'This user was not found on the database',
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
                                          FontAwesomeIcons.locationArrow,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          'Send live location',
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
                                    //send Location
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
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                              listOfUid.contains(userInfo['user_id'])
                                  ? ButtonTheme(
                                      minWidth: double.infinity,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.redAccent,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image(
                                                fit: BoxFit.cover,
                                                height: 16,
                                                width: 16,
                                                image: AssetImage(
                                                    'assets/images/location_slash.png'),
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              Text(
                                                'End live tracking',
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
                                          listOfUid.remove(userInfo['user_id']);
                                          setState(() {
                                            _isConnected = false;
                                          });
                                        },
                                      ),

                                      // FlatButton(
                                      //   child: Text('Add to circle'),
                                      //   color: Colors.green,
                                      //   textColor: Colors.white,
                                      //   onPressed: () {},
                                      // ),
                                    )
                                  : (_isConnected
                                      ? ButtonTheme(
                                          minWidth: double.infinity,
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xff3aa792),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons
                                                        .locationArrow,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                  SizedBox(
                                                    width: 16,
                                                  ),
                                                  Text(
                                                    'Send live location',
                                                    style:
                                                        GoogleFonts.quicksand(
                                                      textStyle: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        letterSpacing: .5,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onPressed: () {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                  "You can only send to one person at a time.",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ));
                                            },
                                          ),

                                          // FlatButton(
                                          //   child: Text('Add to circle'),
                                          //   color: Colors.green,
                                          //   textColor: Colors.white,
                                          //   onPressed: () {},
                                          // ),
                                        )
                                      : ButtonTheme(
                                          minWidth: double.infinity,
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xff3aa792),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons
                                                        .locationArrow,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                  SizedBox(
                                                    width: 16,
                                                  ),
                                                  Text(
                                                    'Send live location',
                                                    style:
                                                        GoogleFonts.quicksand(
                                                      textStyle: TextStyle(
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                        letterSpacing: .5,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onPressed: () {
                                              listOfUid
                                                  .add(userInfo['user_id']);
                                              setState(() {
                                                _isConnected = true;
                                              });
                                              sendLocation(userInfo['user_id'],
                                                  userInfo['user_name']);
                                            },
                                          ),

                                          // FlatButton(
                                          //   child: Text('Add to circle'),
                                          //   color: Colors.green,
                                          //   textColor: Colors.white,
                                          //   onPressed: () {},
                                          // ),
                                        )),
                            ],
                          ),
                        ),
                      ],
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

  sendLocation(String secondId, String name) {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('Notifications')
        .doc('important')
        .collection(secondId)
        .doc();
    Map<String, dynamic> tasks = {
      'notification_tittle': 'TRACK ME!',
      'notification_details':
          '$name pressed the track me button, you can track the live location from button below.',
      'notification_time': DateTime.now().millisecondsSinceEpoch,
      'notification_sender': 'Valuhworld',
      'action_title': 'SOS',
      'action_destination': '',
      'latitudes': latitudes,
      'longitudes': longitudes,
      'action_key': '',
      'post_id': 'extra',
    };
    ds.set(tasks).whenComplete(() {
      print('Notification sent');
      DocumentReference ds =
          FirebaseFirestore.instance.collection('Users').doc(secondId);
      Map<String, dynamic> _tasks = {
        'notification_count': FieldValue.increment(1),
      };
      ds.update(_tasks).whenComplete(() {
        print('notification count updated');
      });
    });
  }
}
