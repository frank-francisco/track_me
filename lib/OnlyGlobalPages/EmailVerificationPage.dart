import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valuhworld/OnlyCompanyPages/CompanyValidationPage.dart';
import 'package:valuhworld/OnlyCompanyPages/SetupCompanyAccount.dart';
import 'package:valuhworld/OnlyGlobalPages/GettingStartedPage.dart';
import 'package:valuhworld/OnlyPersonalPages/SetupPersonalAccountPage.dart';

class EmailVerificationPage extends StatefulWidget {
  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _emailVerified = false;
  bool reloadingUser = false;
  bool resendingEmail = false;
  bool inAction = false;
  bool resendInAction = false;
  String _userEmail = 'null';
  String _userId = 'null';
  int _icon = 0;

  Timer _timer;
  int _start = 0;

  Future<User> getUser() async {
    return _firebaseAuth.currentUser;
  }

  @override
  void initState() {
    super.initState();

    getUser().then((user) async {
      if (user == null) {
        setState(() {
          pushUserOut();
        });
      } else {
        setState(() {
          _userEmail = user.email;
          _userId = user.uid;
        });
        //user.reload();
      }
    });
    _reloadUser();
  }

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: 60,
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  Future _sendVerificationEmail() async {
    startTimer();
    setState(() {
      resendingEmail = true;
      resendInAction = true;
      inAction = true;
      _icon = 1;
    });
    var user = _firebaseAuth.currentUser;
    try {
      await user.sendEmailVerification().then((value) {
        setState(() {
          resendingEmail = false;
          inAction = false;
          _icon = 0;
        });
      });

      print('email sent');
      return user.uid;
    } catch (e) {
      print(e.message);
    }
  }

  _reloadUser() async {
    setState(() {
      reloadingUser = true;
      inAction = true;
      _icon = 1;
    });

    var user = _firebaseAuth.currentUser;
    await user.reload().then((value) {
      setState(() {
        reloadingUser = false;
        inAction = false;
        _icon = 0;
      });
    });
    if (user.emailVerified) {
      setState(
        () {
          _emailVerified = true;
          print('email verified');
        },
      );
    } else {
      setState(() {
        _emailVerified = false;
        print('Email not verified');
      });
    }
  }

  void startTimer() {
    setState(() {
      _start = 60;
    });
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            setState(() {
              resendInAction = false;
            });
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  pushUserOut() {
    Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(
          builder: (context) => GettingStartedScreen(),
        ),
        (r) => false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //resizeToAvoidBottomPadding: true,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Container(
                //color: Colors.red,
                height: 130,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 1,
                      child: _emailVerified
                          ? Image.asset(
                              "assets/images/email-verification_true.png",
                              fit: BoxFit.contain,
                            )
                          : Image.asset(
                              "assets/images/email-verification_false.png",
                              fit: BoxFit.contain,
                            ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: form(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  horizontalLine(),
                  Text(
                    "* * *",
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  horizontalLine()
                ],
              ),
              Stack(
                children: [
                  Image.asset(
                    "assets/images/verify_bg.png",
                    width: MediaQuery.of(context).size.width,
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () async {
                          await _firebaseAuth.signOut().then(
                            (res) {
                              pushUserOut();
                            },
                          );
                        },
                        child: Text(
                          'Log out',
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontSize: 18.0,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget form() {
    return SingleChildScrollView(
      child: _emailVerified
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xff1287c3),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10.0),
                          color: Color(0xff1287c3),
                          height: 1,
                          width: 16,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Congratulations!\nYour email has been verified.',
                          style: GoogleFonts.quicksand(
                            fontSize: 16,
                            color: Color(0xff1287c3),
                            fontWeight: FontWeight.bold,
                            letterSpacing: .5,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0, right: 10),
                      child: Text(
                        'The email address "$_userEmail" has been verified successfully. You can now select your account type to continue.',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 14,
                            // color: Colors.black54,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        FlatButton(
                          color: Color(0xff3aa792),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            side: BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                          child: Text(
                            'Continue',
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: .5,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => SetupPersonalAccountPage(),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 16),
                        // const SizedBox(width: 8),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Authorized')
                            .where('user_email', isEqualTo: _userEmail)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              color: Colors.white,
                            );
                          } else {
                            if (snapshot.data.docs.length == 0) {
                              return Container(
                                color: Colors.white,
                              );
                            } else {
                              DocumentSnapshot myData = snapshot.data.docs[0];
                              return Visibility(
                                visible: true,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 16, left: 16, right: 16),
                                  child: Container(
                                    color: Colors.grey[200],
                                    width: double.infinity,
                                    padding: EdgeInsets.all(8.0),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(
                                                Icons.error_outline,
                                                size: 24,
                                                color: Colors.blue,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Flexible(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'Looks like your email address was authorized to join the 2value team. Click the button below to continue.',
                                                        style: GoogleFonts
                                                            .quicksand(
                                                          textStyle: TextStyle(
                                                            fontSize: 14.0,
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          myData['user_authority'] == 'Admin'
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    TextButton(
                                                      child: const Text(
                                                          'Administrator'),
                                                      onPressed: () {
                                                        // Navigator.push(
                                                        //   context,
                                                        //   CupertinoPageRoute(
                                                        //     builder: (_) =>
                                                        //         AdminSetupAccountPage(),
                                                        //   ),
                                                        // );
                                                      },
                                                    ),
                                                    SizedBox(width: 10),
                                                    TextButton(
                                                      child:
                                                          const Text('Editor'),
                                                      onPressed: null,
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    TextButton(
                                                      child: const Text(
                                                          'Administrator'),
                                                      onPressed: null,
                                                    ),
                                                    SizedBox(width: 10),
                                                    TextButton(
                                                      child:
                                                          const Text('Editor'),
                                                      onPressed: () {
                                                        // Navigator.push(
                                                        //   context,
                                                        //   CupertinoPageRoute(
                                                        //     builder: (_) =>
                                                        //         EditorSetupAccountPage(),
                                                        //   ),
                                                        // );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                        }),
                  ],
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xff1287c3),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10.0),
                          color: Color(0xff1287c3),
                          height: 1,
                          width: 16,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Verify email',
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontSize: 16,
                              // color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 22.0, right: 10),
                      child: Text(
                        'We have sent a verification link to the email address "$_userEmail". Please check your inbox to verify your email.',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 14,
                            // color: Colors.black54,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        color: Colors.amberAccent,
                        width: double.infinity,
                        padding: EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  _icon == 0
                                      ? Icon(
                                          Icons.error_outline,
                                          size: 24,
                                          color: Colors.blue,
                                        )
                                      : SpinKitPulse(
                                          color: Colors.blue,
                                          size: 24.0,
                                        ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        children: [
                                          reloadingUser
                                              ? Expanded(
                                                  child: Text(
                                                    'Checking email verification...',
                                                    style:
                                                        GoogleFonts.quicksand(
                                                      textStyle: TextStyle(
                                                        fontSize: 14.0,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : resendingEmail
                                                  ? Expanded(
                                                      child: Text(
                                                        'Resending verification link...',
                                                        style: GoogleFonts
                                                            .quicksand(
                                                          textStyle: TextStyle(
                                                            fontSize: 14.0,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Expanded(
                                                      child: _start > 0
                                                          ? Text(
                                                              'The email has not been verified. \nIf you haven\'t received the verification link, you can resubmit it in $_start seconds.',
                                                              style: GoogleFonts
                                                                  .quicksand(
                                                                textStyle:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                ),
                                                              ),
                                                            )
                                                          : Text(
                                                              'The email has not been verified. \nIf you haven\'t received the verification link, you can resend it from the button bellow.',
                                                              style: GoogleFonts
                                                                  .quicksand(
                                                                textStyle:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                ),
                                                              ),
                                                            ),
                                                    ),
                                          SizedBox(
                                            width: 6,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  TextButton(
                                    child: Text(
                                      'Refresh',
                                    ),
                                    onPressed: inAction
                                        ? null
                                        : () {
                                            _reloadUser();
                                          },
                                  ),
                                  SizedBox(width: 10),
                                  TextButton(
                                    child: Text(
                                      'Resend',
                                    ),
                                    onPressed: inAction || resendInAction
                                        ? null
                                        : () {
                                            _sendVerificationEmail();
                                          },
                                  ),
                                  // const SizedBox(width: 8),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
