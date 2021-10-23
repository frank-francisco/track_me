import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:valuhworld/OnlyGlobalPages/HomePage.dart';

class SetupPersonalAccountPage extends StatefulWidget {
  @override
  _SetupPersonalAccountPageState createState() =>
      _SetupPersonalAccountPageState();
}

class _SetupPersonalAccountPageState extends State<SetupPersonalAccountPage> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  DateTime _date = DateTime.now();
  final databaseReference = FirebaseFirestore.instance;
  final myController = TextEditingController();
  TextEditingController bioController;
  FirebaseMessaging messaging;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  //text field state
  String error = '';
  String name = '';
  String biography = '';
  String userCountry = '';
  String userPhone = 'not set';

  //image capture
  File _imageFile;
  String _uploadedFileURL;
  String onlineUserId;
  String onlineUserEmail;
  String _deviceToken = '';
  //end of image capture

  final ImagePicker _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        maxHeight: 1000,
        maxWidth: 1000,
        compressQuality: 80,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    setState(
      () {
        _imageFile = croppedFile;
        print(_imageFile.lengthSync());
      },
    );
  }

  //create data
  createData() {
    DocumentReference ds =
        FirebaseFirestore.instance.collection('Users').doc(onlineUserId);
    Map<String, dynamic> tasks = {
      'user_name': name,
      'account_type': 'Personal',
      'email_verification': 'Verified',
      'user_authority': '-',
      'user_email': onlineUserEmail,
      'user_id': onlineUserId,
      'user_image': _uploadedFileURL,
      'user_phone': userPhone,
      'user_city': '-',
      'works_for_firm': 'False',
      'user_plan': '-',
      'user_power': '-',
      'user_locality': userCountry,
      'about_user': bioController.text,
      'external_link': '-',
      'user_verification': '-',
      'user_circle_count': 0,
      'action_title': '',
      'notification_count': 1,
      'make_money': '-',
      'device_token': _deviceToken,
      'creation_date': _date.millisecondsSinceEpoch,
      'feedback_consent': 'True',
      'rated_on_stores': 'False',
      'show_task_dialog': 'False',
      'facebook_profile': '',
      'linked_in_profile': '',
      'user_extra': 'extra',
      'searchKeywords': FieldValue.arrayUnion([
        '${name[0]}',
        '${name[1]}',
        '${name[2]}',
        '${name[3]}',
        '${name[4]}',
        '${name[0]}${name[1]}',
        '${name[0]}${name[1]}${name[2]}',
        '${name[0]}${name[1]}${name[2]}${name[3]}',
        '${name[0]}${name[1]}${name[2]}${name[3]}${name[4]}',
        '$name',
        '${name[0].toLowerCase()}',
        '${name[1].toLowerCase()}',
        '${name[2].toLowerCase()}',
        '${name[3].toLowerCase()}',
        '${name[4].toLowerCase()}',
        '${name[0].toLowerCase()}${name[1].toLowerCase()}',
        '${name[0].toLowerCase()}${name[1].toLowerCase()}${name[2].toLowerCase()}',
        '${name[0].toLowerCase()}${name[1].toLowerCase()}${name[2].toLowerCase()}${name[3].toLowerCase()}',
        '${name[0].toLowerCase()}${name[1].toLowerCase()}${name[2].toLowerCase()}${name[3].toLowerCase()}${name[4].toLowerCase()}',
        '${name.toLowerCase()}',
      ]),
    };
    ds.set(tasks).whenComplete(() {
      sendNotification();
    });
  }

  sendNotification() {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('Notifications')
        .doc('important')
        .collection(onlineUserId)
        .doc();
    Map<String, dynamic> tasks = {
      'notification_tittle': 'Welcome to Valuhworld!',
      'notification_details':
          'Welcome to Valuhworld App where you will find useful features! Your presence is our motivation to do better! Our heartiest welcome goes to you. Thanks for being a proud customer of our unique platform.',
      'notification_time': DateTime.now().millisecondsSinceEpoch,
      'notification_sender': 'Valuhworld',
      'action_title': '',
      'action_destination': '',
      'action_key': '',
      'post_id': 'extra',
    };
    ds.set(tasks).whenComplete(() {
      print('Notification created');
      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) => HomePage(),
          ),
          (r) => false);
    });
  }

  @override
  void initState() {
    super.initState();
    bioController = new TextEditingController(
        text:
            'Hello there! I\'m using Valuhworld to connect with my close friends and hosts. They are the ones I reach whenever I need an immediate help.');
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  _getToken() {
    _firebaseMessaging.getToken().then((deviceToken) {
      print('Device token: $deviceToken');
      setState(() {
        _deviceToken = deviceToken;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black87,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Container(
            color: Colors.white,
            width: double.infinity,
            child: SingleChildScrollView(
              child: AbsorbPointer(
                absorbing: _loading,
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Container(
                            height: 160.0,
                            width: 160.0,
                            child: InkWell(
                              child: _imageFile == null
                                  ? CircleAvatar(
                                      //backgroundColor: Colors.red,
                                      backgroundImage: AssetImage(
                                          'assets/images/holder.jpg'),
                                      //foregroundColor: Colors.white,
                                      radius: 80,
                                      //child: Text('Select Image'),
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      backgroundImage: FileImage(_imageFile),
                                      foregroundColor: Colors.white,
                                      radius: 80,
                                      //child: Text('Select Image'),
                                    ),
                              onTap: () {
                                getImage();
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Set-up a \npersonal account',
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          keyboardType: TextInputType.name,
                          maxLength: 30,
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black54,
                              letterSpacing: .5,
                            ),
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            labelText: 'Name',
                            contentPadding: const EdgeInsets.all(0.0),
                            errorStyle: TextStyle(color: Colors.brown),
                          ),
                          onChanged: (val) {
                            setState(() => name = val.trim());
                          },
                          validator: (val) =>
                              val.length < 5 ? ('Enter a valid name') : null,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: bioController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          maxLength: 300,
                          style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black54,
                              letterSpacing: .5,
                            ),
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[100],
                            labelText: 'Biography',
                            labelStyle: GoogleFonts.nunito(
                              textStyle: TextStyle(
                                letterSpacing: .5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(0.0),
                            errorStyle: TextStyle(color: Colors.brown),
                          ),
                          onChanged: (val) {
                            setState(() => biography = val);
                          },
                          validator: (val) => val.length < 30
                              ? ('Too short, at least 30 chars')
                              : null,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          maxLength: 16,
                          style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black54,
                              letterSpacing: .5,
                            ),
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[100],
                            labelText: 'Phone',
                            labelStyle: GoogleFonts.nunito(
                              textStyle: TextStyle(
                                letterSpacing: .5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(0.0),
                            errorStyle: TextStyle(color: Colors.brown),
                          ),
                          onChanged: (val) {
                            setState(() => userPhone = val);
                          },
                          validator: (val) => val.length < 10
                              ? ('Enter a valid phone number')
                              : null,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              // showPhoneCode:
                              //     true, // optional. Shows phone code before the country name.
                              onSelect: (Country country) {
                                print('Select country: ${country.name}');
                                setState(() {
                                  userCountry = country.name;
                                  myController.text = country.name;
                                });
                              },
                            );
                          },
                          child: TextFormField(
                            controller: myController,
                            enabled: false,
                            keyboardType: TextInputType.number,
                            maxLength: 16,
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black54,
                                letterSpacing: .5,
                              ),
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[100],
                              labelText: 'Country',
                              contentPadding: const EdgeInsets.all(0.0),
                              errorStyle: TextStyle(color: Colors.brown),
                            ),
                            validator: (val) =>
                                val.isEmpty ? ('Select country') : null,
                          ),
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
                                    style: GoogleFonts.nunito(
                                      textStyle: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: .5,
                                      ),
                                    ),
                                  ),
                                  shape: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff3aa792), width: 2),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    if (_imageFile == null) {
                                      final snackBar = SnackBar(
                                        content: Text(
                                          'Select image!',
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
                                    } else {
                                      if (_formKey.currentState.validate()) {
                                        setState(() => _loading = true);
                                        _startUpload();
                                      } else {
                                        final snackBar = SnackBar(
                                          content: Text(
                                            'Please fill everything!',
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                        Scaffold.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    }
                                  },
                                ),
                              ),
                        SizedBox(
                          height: 60,
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
    );
  }

  Future<void> _startUpload() async {
    final User user = FirebaseAuth.instance.currentUser;
    final uid = user.uid;
    final userEmail = user.email;
    _getToken();

    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      await storage.ref('Profiles/$uid.jpg').putFile(_imageFile);
      print('File Uploaded');

      String downloadURL =
          await storage.ref('Profiles/$uid.jpg').getDownloadURL();

      setState(
        () {
          _uploadedFileURL = downloadURL;
          onlineUserId = uid;
          onlineUserEmail = userEmail;
          createData();
        },
      );
    } on FirebaseException catch (e) {
      final snackBar = SnackBar(
        content: Text(
          e.message,
          textAlign: TextAlign.center,
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
      setState(() {
        _loading = false;
      });
    }
  }
}
