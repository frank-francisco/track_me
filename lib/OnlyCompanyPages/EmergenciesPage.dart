import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valuhworld/OnlyCompanyPages/UpgradePage.dart';
import 'package:valuhworld/OnlyServices/profileData.dart';

class EmergenciesPage extends StatefulWidget {
  @override
  _EmergenciesPageState createState() => _EmergenciesPageState();
}

class _EmergenciesPageState extends State<EmergenciesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  DateTime _date = DateTime.now();
  String _onlineUserId;

  bool userFlag = false;
  var details;
  String _userType = 'not_set';
  String _userPower = 'not_set';

  @override
  void initState() {
    super.initState();

    getUser().then(
      (user) async {
        if (user != null) {
          final User user = _auth.currentUser;
          _onlineUserId = user.uid;

          ProfileService()
              .getProfileInfo(_onlineUserId)
              .then((QuerySnapshot docs) {
            if (docs.docs.isNotEmpty) {
              setState(
                () {
                  userFlag = true;
                  details = docs.docs[0].data();
                  _userType = details['account_type'];
                  _userPower = details['user_authority'];
                  //_goWatchVideos();
                },
              );
            }
          });
        }
      },
    );
  }

  Future<User> getUser() async {
    return _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .where('user_id', isEqualTo: _onlineUserId)
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
                DocumentSnapshot userInfo = snapshot.data.docs[0];
                return bodyView(userInfo);
                //return userInfo['user_plan'] == '-' ? noPlan() : Container();
              }
            }
          },
        ),
      ),
    );
  }

  Widget bodyView(DocumentSnapshot userInfo) {
    return Column(
      children: [
        Visibility(
          visible: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
              color: Colors.grey[200],
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 0,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  'You are the on a 3 months trial, Upgrade to add more members.',
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        'Upgrade',
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: .5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) => UpgradePage(
                                        userId: _onlineUserId,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: Center(
              child: Text(
                'Your list is now empty',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 24.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
