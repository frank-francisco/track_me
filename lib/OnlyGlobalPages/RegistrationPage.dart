import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valuhworld/OnlyAnimations/FadeAnimations.dart';
import 'package:valuhworld/OnlyGlobalPages/wrapper.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool _errorVisibility = false;
  String error = '';
  String email = '';
  String password = '';
  bool checkedValue = false;

  Future<void> _launched;
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential != null) {
        await userCredential.user.sendEmailVerification();

        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => Wrapper(),
            ),
            (r) => false);
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      print(e.message);
      setState(() {
        _errorVisibility = true;
        loading = false;
      });
      if (e.code == 'email-already-in-use') {
        setState(() {
          error = (e.message);
        });
      } else {
        setState(() {
          error = (e.message);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/elephant.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          width: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Register',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  fontSize: 18.0,
                  letterSpacing: .5,
                ),
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: FadeAnimation(
                    1.2,
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    spreadRadius: 3,
                                    blurRadius: 4,
                                    offset: Offset(
                                        0, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black54,
                                          letterSpacing: .5,
                                        ),
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'E-mail',
                                        labelStyle: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontSize: 18.0,
                                            letterSpacing: .5,
                                          ),
                                        ),
                                        errorStyle: TextStyle(
                                          color: Colors.brown,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.all(0.0),
                                      ),
                                      onChanged: (val) {
                                        setState(() {
                                          _errorVisibility = false;
                                          email = val.trim();
                                        });
                                      },
                                      validator: (val) =>
                                          !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                                  .hasMatch(val)
                                              ? ('Enter a valid e-mail address')
                                              : null,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.text,
                                      obscureText: true,
                                      maxLength: 18,
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black54,
                                          letterSpacing: .5,
                                        ),
                                      ),
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        labelStyle: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontSize: 18.0,
                                            letterSpacing: .5,
                                          ),
                                        ),
                                        errorStyle:
                                            TextStyle(color: Colors.brown),
                                        contentPadding:
                                            const EdgeInsets.all(0.0),
                                      ),
                                      onChanged: (val) {
                                        setState(() {
                                          _errorVisibility = false;
                                          password = val.trim();
                                        });
                                      },
                                      validator: (val) => val.length < 6
                                          ? ('Weak password')
                                          : null,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.text,
                                      obscureText: true,
                                      maxLength: 18,
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black54,
                                          letterSpacing: .5,
                                        ),
                                      ),
                                      decoration: InputDecoration(
                                          labelText: 'Confirm password',
                                          contentPadding:
                                              const EdgeInsets.all(0.0),
                                          labelStyle: GoogleFonts.quicksand(
                                            textStyle: TextStyle(
                                              fontSize: 18.0,
                                              letterSpacing: .5,
                                            ),
                                          ),
                                          errorStyle:
                                              TextStyle(color: Colors.brown)),
                                      validator: (val) => val != password
                                          ? ('Password does not match')
                                          : null,
                                      onChanged: (val) {
                                        setState(
                                          () {
                                            _errorVisibility = false;
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    loading
                                        ? Container(
                                            decoration: new BoxDecoration(
                                              color: Color(0xff3aa792),
                                              borderRadius:
                                                  new BorderRadius.all(
                                                Radius.circular(4.0),
                                              ),
                                            ),
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
                                            minWidth: 200.0,
                                            height: 48.0,
                                            child: RaisedButton(
                                              color: Color(0xff3aa792),
                                              onPressed: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                if (checkedValue == true) {
                                                  if (_formKey.currentState
                                                      .validate()) {
                                                    setState(() {
                                                      loading = true;
                                                      _errorVisibility = false;
                                                    });
                                                    registerWithEmailAndPassword(
                                                        email, password);
                                                  } else {
                                                    setState(() {
                                                      loading = false;
                                                      _errorVisibility = true;
                                                      error =
                                                          'Please fill in all the fields!';
                                                    });
                                                  }
                                                } else {
                                                  setState(() {
                                                    loading = false;
                                                    _errorVisibility = true;
                                                    error =
                                                        'You must accept Valuhworld terms of service.';
                                                  });
                                                }
                                              },
                                              child: Text(
                                                'Register',
                                                style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: .5,
                                                  ),
                                                ),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        4.0),
                                              ),
                                            ),
                                          ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    CheckboxListTile(
                                      title: RichText(
                                        text: TextSpan(
                                            text: 'Accept',
                                            style: GoogleFonts.quicksand(
                                              textStyle: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black,
                                                letterSpacing: .5,
                                              ),
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: ' terms and conditions',
                                                  style: GoogleFonts.quicksand(
                                                    textStyle: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: .5,
                                                    ),
                                                  ),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          _launchInBrowser(
                                                              'https://valuhworld.com/terms.html');
                                                        }),
                                              TextSpan(
                                                text: ' and',
                                                style: GoogleFonts.quicksand(
                                                  textStyle: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.black,
                                                    letterSpacing: .5,
                                                  ),
                                                ),
                                              ),
                                              TextSpan(
                                                  text: ' privacy policy',
                                                  style: GoogleFonts.quicksand(
                                                    textStyle: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: .5,
                                                    ),
                                                  ),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () {
                                                          _launchInBrowser(
                                                              'https://valuhworld.com/gdpr.html');
                                                        }),
                                            ]),
                                      ),
                                      //Text("Accept termenii si conditiile."),
                                      value: checkedValue,
                                      onChanged: (newValue) {
                                        setState(() {
                                          checkedValue = newValue;

                                          _errorVisibility = false;
                                          error = '';
                                        });
                                      },
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      activeColor:
                                          Colors.green, //  <-- leading Checkbox
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Visibility(
                                      visible: _errorVisibility,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: Container(
                                          color: Colors.amberAccent,
                                          width: double.infinity,
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(
                                                Icons.error_outline,
                                              ),
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: Text(
                                                    error,
                                                    style:
                                                        GoogleFonts.quicksand(
                                                      textStyle: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.black,
                                                        letterSpacing: .5,
                                                      ),
                                                    ),
                                                  ),
                                                ),
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
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
