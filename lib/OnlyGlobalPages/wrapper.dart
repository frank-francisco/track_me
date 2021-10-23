import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valuhworld/OnlyGlobalPages/EmailVerificationPage.dart';
import 'package:valuhworld/OnlyGlobalPages/GettingStartedPage.dart';
import 'package:valuhworld/OnlyGlobalPages/HomePage.dart';
import 'package:valuhworld/OnlyGlobalPages/OnBoardingPage.dart';
import 'package:valuhworld/OnlyPersonalPages/SetupPersonalAccountPage.dart';
import '../main.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String onlineUserId;
  String _controller;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    manageUser();
    makeDecision();
    //_configureFirebaseListeners();
  }

  // _configureFirebaseListeners() {
  //   _firebaseMessaging.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       print('onMessage: $message');
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print('onLaunch: $message');
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print('onResume: $message');
  //     },
  //     // onBackgroundMessage: (Map<String, dynamic> message) async {
  //     //   print('onBackgroundMessage: $message');
  //     // },
  //   );
  // }

  makeDecision() {
    _timer = new Timer(
      const Duration(seconds: 3),
      () {
        print('done');
        if (_controller == 'out') {
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => OnBoardingPage(),
              ),
              (r) => false);
        } else if (_controller == 'info') {
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => EmailVerificationPage(),
              ),
              (r) => false);
        } else if (_controller == 'home') {
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => HomePage(),
              ),
              (r) => false);
        } else if (_controller == null) {
          MyApp.restartApp(context);
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  manageUser() async {
    final User user = _auth.currentUser;
    if (user == null) {
      setState(() {
        _controller = 'out';
      });
    } else {
      final snapShot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      if (snapShot.exists) {
        setState(() {
          _controller = 'home';
        });
      } else {
        setState(() {
          _controller = 'info';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3aa792),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                //color: Colors.red,
                child: Center(
                  child: Image(
                    height: 80,
                    //width: 300,
                    fit: BoxFit.contain,
                    image: AssetImage(
                      'assets/images/ValuhworldLogo.png',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 220,
            ),
            Text(
              'Valuhworld,\nnow safer than ever',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  fontSize: 18.0,
                  //fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: .5,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
