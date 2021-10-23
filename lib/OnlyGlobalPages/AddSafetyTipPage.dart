import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddSafetyTipPage extends StatefulWidget {
  final String userId;
  AddSafetyTipPage({
    this.userId,
  });

  @override
  _AddSafetyTipPageState createState() => _AddSafetyTipPageState(
        userId: userId,
      );
}

class _AddSafetyTipPageState extends State<AddSafetyTipPage> {
  String userId;
  _AddSafetyTipPageState({
    this.userId,
  });

  final _formKey = GlobalKey<FormState>();
  String _feedback = '';
  String _formattedDate = '';
  bool _loading = false;
  DateTime _date = DateTime.now();

  _submitFeedback() {
    DocumentReference ds = FirebaseFirestore.instance.collection('Tips').doc();
    Map<String, dynamic> tasks = {
      'tip_description': _feedback,
      'tip_time': _date.millisecondsSinceEpoch,
      'tip_poster': userId,
      'tip_id': ds.id,
      'tip_extra': 'Extra',
    };
    ds.set(tasks).whenComplete(
      () {
        setState(() {
          _loading = false;
        });
        _showDialog();
      },
    );
  }

  _showDialog() {
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
                        'Tip submitted!',
                        style: GoogleFonts.quicksand(
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
                        'Your tip has successfully been submitted!',
                        style: GoogleFonts.quicksand(
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
                            "Okay",
                            style: TextStyle(
                              color: Color(0xff3aa792),
                            ),
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
      appBar: AppBar(
        backgroundColor: Color(0xff3aa792),
        title: Text(
          'Add safety tips',
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
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
                        'What\'s your safety tip',
                        style: GoogleFonts.quicksand(
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
                        maxLength: 9000,
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black,
                            letterSpacing: .5,
                          ),
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          labelText: 'Your safety tip',
                          labelStyle: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              letterSpacing: .5,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(4.0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide(
                              color: Color(0xff3aa792),
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide(
                              color: (Colors.grey[200]),
                              width: 1.0,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(15.0),
                          errorStyle: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              color: Colors.brown,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() => _feedback = val);
                        },
                        validator: (val) => val.length < 5 ? 'Too short' : null,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      _loading
                          ? Container(
                              decoration: new BoxDecoration(
                                  color: Color(0xff3aa792),
                                  borderRadius: new BorderRadius.all(
                                      Radius.circular(4.0))),
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
                                  'Submit',
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                ),
                                shape: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff3aa792),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4.0),
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
