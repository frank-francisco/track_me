import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class FeedbackPage extends StatefulWidget {
  final String rateTitle;
  final String userId;
  final int userTime;
  FeedbackPage({this.rateTitle, this.userId, this.userTime});

  @override
  _FeedbackPageState createState() => _FeedbackPageState(
      rateTitle: rateTitle, userId: userId, userTime: userTime);
}

class _FeedbackPageState extends State<FeedbackPage> {
  String rateTitle;
  String userId;
  int userTime;
  _FeedbackPageState({this.rateTitle, this.userId, this.userTime});

  final _formKey = GlobalKey<FormState>();
  String _feedback = '';
  String _formattedDate = '';
  bool _loading = false;
  DateTime _date = DateTime.now();

  _submitFeedback() {
    initializeDateFormatting('ro_RO', null).then((_) {
      String _dateFormat =
          DateFormat.yMMMd('ro_RO').format(DateTime.now()).toString();

      DocumentReference ds =
          FirebaseFirestore.instance.collection('Feedback').doc();
      Map<String, dynamic> tasks = {
        'feedback_title': rateTitle,
        'feedback_rate': 'not set',
        'feedback_description': _feedback,
        'feedback_time': _date.millisecondsSinceEpoch,
        'feedback_formatted_time': _dateFormat,
        'feedback_poster': userId,
        'feedback_action': 'Feedback',
        'feedback_id': 'id',
        'user_since': userTime,
        'feedback_extra': 'Extra',
      };
      ds.set(tasks).whenComplete(
        () {
          DocumentReference documentReferences =
              FirebaseFirestore.instance.collection('Feedback').doc(ds.id);
          Map<String, dynamic> _updateTasks = {
            'feedback_id': ds.id,
          };
          documentReferences.update(_updateTasks).whenComplete(() {
            print('Feedback added');
            setState(() {
              _loading = false;
            });
            _showDialog();
          });
        },
      );
    });
  }

  _showDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
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
                        'Părere trimisă!',
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
                        'Îți  mulțumim că ți-ai  folosit timpul pentru a ne oferi parerea ta, pe care o vom folosi cu scopul de a ne îmbunătăți serviciile.',
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
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Bine",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
                        'Te rugăm să ne \nîmpărtășești părerea ta',
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.name,
                        maxLines: null,
                        maxLength: 800,
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                            letterSpacing: .5,
                          ),
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          labelText: 'Părere',
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
                              color: Colors.blue,
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
                          setState(() => _feedback = val);
                        },
                        validator: (val) => val.length < 50
                            ? 'Cel puțin 50 de caractere'
                            : null,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      _loading
                          ? Container(
                              decoration: new BoxDecoration(
                                  color: Colors.blue,
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
                                color: Colors.blue,
                                child: Text(
                                  'Trimite',
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                ),
                                shape: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blue, width: 2),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.all(10),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() => _loading = true);
                                    FocusScope.of(context).unfocus();
                                    _submitFeedback();
                                  } else {
                                    final snackBar = SnackBar(
                                      content: Text(
                                        'Te rugăm să completezi toate câmpurile!',
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  }
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
