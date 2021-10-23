import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valuhworld/OnlyAnimations/FadeAnimations.dart';
import 'package:valuhworld/OnlyServices/profileData.dart';

class PublicCompanyPage extends StatefulWidget {
  final String userId;
  final String secondUserId;
  PublicCompanyPage({this.userId, this.secondUserId});

  @override
  _PublicCompanyPageState createState() =>
      _PublicCompanyPageState(userId: userId, secondUserId: secondUserId);
}

class _PublicCompanyPageState extends State<PublicCompanyPage> {
  String userId;
  String secondUserId;
  _PublicCompanyPageState({this.userId, this.secondUserId});

  String password = '';
  bool userFlag = false;
  var details;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  getUserInfo() {
    ProfileService().getProfileInfo(secondUserId).then((QuerySnapshot docs) {
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
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('MyHosts')
                                    .doc(userId)
                                    .collection('AllHosts')
                                    .where('host_id', isEqualTo: secondUserId)
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
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: TextField(
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              maxLines: 1,
                                              style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.black54,
                                                  letterSpacing: .5,
                                                ),
                                              ),
                                              decoration: InputDecoration(
                                                filled: false,
                                                fillColor: Colors.grey[100],
                                                labelText: 'Password',
                                                labelStyle: GoogleFonts.nunito(
                                                  textStyle: TextStyle(
                                                    letterSpacing: .5,
                                                  ),
                                                ),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 0),
                                                errorStyle: TextStyle(
                                                    color: Colors.brown),
                                              ),
                                              onChanged: (val) {
                                                setState(() => password = val);
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          TextButton(
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
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons.link,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                  SizedBox(
                                                    width: 16,
                                                  ),
                                                  Text(
                                                    'Connect',
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
                                              if (details[
                                                      'connection_password'] !=
                                                  password) {
                                                final snackBar = SnackBar(
                                                  content: Text(
                                                    'Wrong password!',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                );
                                                Scaffold.of(context)
                                                    .showSnackBar(snackBar);
                                              } else {
                                                connectWithHost();
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    } else {
                                      DocumentSnapshot circleInfo =
                                          snapshot.data.docs[0];
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              backgroundColor: Colors.black87,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons.unlink,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                  SizedBox(
                                                    width: 16,
                                                  ),
                                                  Text(
                                                    'Disconnect',
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
                                              disconnectWithHost();
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  connectWithHost() {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('MyHosts')
        .doc(userId)
        .collection('AllHosts')
        .doc(secondUserId);
    Map<String, dynamic> _tasks = {
      'connection_requester': userId,
      'connection_requested': secondUserId,
      'connected_time': DateTime.now().millisecondsSinceEpoch,
      'host_action': '-',
      'host_id': secondUserId,
      'host_extra': 'extra',
    };
    ds.set(_tasks).whenComplete(
      () {
        print('Connected successfully');
      },
    );

    DocumentReference ds2 = FirebaseFirestore.instance
        .collection('MyHosts')
        .doc(secondUserId)
        .collection('AllHosts')
        .doc(userId);
    Map<String, dynamic> _tasks2 = {
      'connection_requester': userId,
      'connection_requested': secondUserId,
      'connected_time': DateTime.now().millisecondsSinceEpoch,
      'host_action': '-',
      'host_id': secondUserId,
      'host_extra': 'extra',
    };
    ds2.set(_tasks2).whenComplete(
      () {
        print('Connected successfully');
      },
    );
  }

  disconnectWithHost() {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('MyHosts')
        .doc(userId)
        .collection('AllHosts')
        .doc(secondUserId);
    ds.delete().then((value) => print("Connection Deleted")).catchError(
          (error) => print("Failed to delete user: $error"),
        );

    DocumentReference ds2 = FirebaseFirestore.instance
        .collection('MyHosts')
        .doc(secondUserId)
        .collection('AllHosts')
        .doc(userId);
    ds2.delete().then((value) => print("Connection Deleted")).catchError(
          (error) => print("Failed to delete user: $error"),
        );
  }
}
