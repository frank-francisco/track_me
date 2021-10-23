import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:valuhworld/OnlyGlobalPages/HomePage.dart';

class AddCompanyPage extends StatefulWidget {
  @override
  _AddCompanyPageState createState() => _AddCompanyPageState();
}

class _AddCompanyPageState extends State<AddCompanyPage> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  DateTime _date = DateTime.now();
  final databaseReference = FirebaseFirestore.instance;

  //text field state
  String error = '';
  String name = '';
  String reg = '';
  String biography = '';
  String userCountry = '';
  String userPhone = 'not set';
  List<String> _locations = ['Please choose a location', 'A', 'B', 'C', 'D'];
  String _selectedLocation = 'Please choose a location';
  int _value = 1;

  //image capture
  File _imageFile;
  String _uploadedFileURL;
  String onlineUserId;
  String onlineUserEmail;
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

    setState(() {
      _imageFile = croppedFile;
      print(_imageFile.lengthSync());
    });
  }

  //create data
  createData() {
    DocumentReference ds =
        FirebaseFirestore.instance.collection('Companies').doc(reg);
    Map<String, dynamic> tasks = {
      'company_name': name,
      'company_owner': onlineUserId,
      'company_type': '-',
      'company_verification': '-',
      'company_email': onlineUserEmail,
      'company_id': reg,
      'company_image': _uploadedFileURL,
      'company_phone': userPhone,
      'about_company': biography,
      'company_link': '-',
      'company_team': FieldValue.arrayUnion([
        onlineUserId,
      ]),
      'action_title': '',
      'creation_date': _date.millisecondsSinceEpoch,
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
      'notification_tittle': 'You created a company!',
      'notification_details':
          'Congratulations! You have successfully created your first company on the Valuhworld platform. Thanks for being part of our platform.',
      'notification_time': DateTime.now().millisecondsSinceEpoch,
      'notification_sender': 'Valuhworld',
      'action_title': '',
      'action_destination': '',
      'action_key': '',
      'post_id': 'extra',
    };
    ds.set(tasks).whenComplete(() {
      print('Notification created');
      // Navigator.of(context).pushAndRemoveUntil(
      //     CupertinoPageRoute(
      //       builder: (context) => HomePage(),
      //     ),
      //     (r) => false);
      Navigator.of(context).pop();
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                                          'assets/images/logo_placeholder.png'),
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
                          'Register your company',
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
                            labelText: 'Reg. No',
                            contentPadding: const EdgeInsets.all(0.0),
                            errorStyle: TextStyle(color: Colors.brown),
                          ),
                          onChanged: (val) {
                            setState(() => reg = val.trim());
                          },
                          validator: (val) =>
                              val.length < 5 ? ('Enter a reg number') : null,
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
                            labelText: 'Company name',
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
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          maxLength: 300,
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
                            labelText: 'Company description',
                            labelStyle: GoogleFonts.quicksand(
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
                          validator: (val) => val.length < 100
                              ? ('Too short, at least 100 chars')
                              : null,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
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
                            labelText: 'Phone',
                            labelStyle: GoogleFonts.quicksand(
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
                                    style: GoogleFonts.quicksand(
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

    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      await storage.ref('Profiles/$reg.jpg').putFile(_imageFile);
      print('File Uploaded');

      String downloadURL =
          await storage.ref('Profiles/$reg.jpg').getDownloadURL();

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
