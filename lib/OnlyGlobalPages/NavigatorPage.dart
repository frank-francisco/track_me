import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valuhworld/OnlyServices/profileData.dart';

class NavigatorPage extends StatefulWidget {
  final int bodyValue;
  NavigatorPage({this.bodyValue});

  @override
  _NavigatorPageState createState() =>
      _NavigatorPageState(bodyValue: bodyValue);
}

class _NavigatorPageState extends State<NavigatorPage> {
  int bodyValue;
  _NavigatorPageState({this.bodyValue});
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _onlineUserId;
  bool userFlag = false;
  var details;

  String _selectedLanguage = 'Romanian';

  readSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_language';
    final value = prefs.getString(key) ?? 'Romanian';
    print('read: $value');
    setState(() {
      _selectedLanguage = value;
    });
  }

  @override
  void initState() {
    super.initState();
    readSavedLanguage();

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

  addNewItems() {
    DocumentReference usersRef =
        FirebaseFirestore.instance.collection('Users').doc(_onlineUserId);

    usersRef.update({
      'presf_demos': 0,
      'evencts_demos': 1,
      'intcverviews_demo': 2,
      'pitcches_demo': 0,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userFlag
          ? bodyView(details['account_type'])
          : Center(
              child: SpinKitThreeBounce(
                color: Colors.black54,
                size: 20.0,
              ),
            ),
    );
  }

  Widget bodyView(String accountType) {
    return Container();
  }
}
