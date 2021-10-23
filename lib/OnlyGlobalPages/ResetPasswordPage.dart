import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valuhworld/OnlyAnimations/FadeAnimations.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
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

  //text field state
  String email = '';
  String message = '';

  Future resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      setState(() {
        'An email with the password reset link has been sent to  $email';
        _errorVisibility = true;
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      print(e.code);
      print(e.message);
      setState(() {
        _errorVisibility = true;
        loading = false;
      });
      if (e.code == 'user-not-found') {
        setState(() {
          message = (e.message);
        });
      } else {
        setState(() {
          message = (e.message);
        });
      }

      return null;
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
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text('Reset password'),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).primaryColor,
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
                          minHeight: viewportConstraints.maxHeight),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.always,
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
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 0),
                                        errorStyle: TextStyle(
                                          color: Colors.brown,
                                        ),
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
                                      height: 20,
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
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  setState(() {
                                                    loading = true;
                                                    message = '';
                                                    _errorVisibility = false;
                                                  });
                                                  resetPassword(email);
                                                } else {
                                                  final snackBar = SnackBar(
                                                    content: Text(
                                                      'Please fill in all the fields!',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  );
                                                  Scaffold.of(context)
                                                      .showSnackBar(snackBar);
                                                }
                                              },
                                              child: Text(
                                                "Reset",
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
                                      height: 20,
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
                                                    message,
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
