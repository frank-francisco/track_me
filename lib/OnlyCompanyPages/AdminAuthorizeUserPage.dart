import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminAuthorizeUserPage extends StatefulWidget {
  @override
  _AdminAuthorizeUserPageState createState() => _AdminAuthorizeUserPageState();
}

class _AdminAuthorizeUserPageState extends State<AdminAuthorizeUserPage> {
  final _formKey = GlobalKey<FormState>();
  String _addedEmail = '';
  bool _loading = false;
  String _selectedCategory = 'Editor';

  final List<String> _userCategories = [
    'Editor',
    'Admin',
  ];

  _submitUser() {
    DocumentReference ds =
        FirebaseFirestore.instance.collection('Authorized').doc();
    Map<String, dynamic> tasks = {
      'user_email': _addedEmail,
      'user_authority': '',
      'user_extra': 'Extra',
    };
    ds.set(tasks).whenComplete(
      () {
        print('user authorized');
        _displayAuthorizationCompleteDialog();
        setState(() {
          _loading = false;
        });
      },
    );
  }

  _displayAuthorizationCompleteDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)), //this right here
          child: Wrap(
            children: [
              Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Authorized!',
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        'The user with the email adress "$_addedEmail" has successfully been authorized to join your host',
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: 320.0,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              _addedEmail = '';
                            });
                          },
                          child: Text(
                            "Okay",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Color(0xff3aa792),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3aa792),
        title: Text('Authorize a user'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: viewportConstraints.maxHeight),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Authorize a user',
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.emailAddress,
                        maxLines: 1,
                        maxLength: 100,
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                            letterSpacing: .5,
                          ),
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'User email',
                          labelStyle: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              letterSpacing: .5,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Color(0xff3aa792),
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(15.0),
                          errorStyle: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              color: Colors.brown,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() => _addedEmail = val);
                        },
                        validator: (val) =>
                            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                    .hasMatch(val)
                                ? 'Enter a valid email'
                                : null,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      _loading
                          ? Container(
                              decoration: new BoxDecoration(
                                  color: Color(0xff3aa792),
                                  borderRadius: new BorderRadius.all(
                                      Radius.circular(8.0))),
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
                              height: 48,
                              child: FlatButton(
                                color: Color(0xff3aa792),
                                child: Text(
                                  'Authorize',
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                ),
                                shape: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff3aa792),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.all(10),
                                onPressed: () async {
                                  // if (_formKey.currentState.validate()) {
                                  //   setState(() => _loading = true);
                                  //   FocusScope.of(context).unfocus();
                                  //   _submitUser();
                                  // } else {
                                  //   final snackBar = SnackBar(
                                  //     content: Text(
                                  //       'Fill valid user emails!',
                                  //       textAlign: TextAlign.center,
                                  //     ),
                                  //   );
                                  //   Scaffold.of(context).showSnackBar(snackBar);
                                  // }
                                  _displayAuthorizationCompleteDialog();
                                },
                              ),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
