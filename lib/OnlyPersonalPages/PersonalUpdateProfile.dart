import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PersonalUpdateProfile extends StatefulWidget {
  final userSnap;
  final String userId;
  PersonalUpdateProfile({this.userSnap, this.userId});

  @override
  _PersonalUpdateProfileState createState() =>
      _PersonalUpdateProfileState(userSnap: userSnap, userId: userId);
}

class _PersonalUpdateProfileState extends State<PersonalUpdateProfile> {
  var userSnap;
  String userId;
  _PersonalUpdateProfileState({this.userSnap, this.userId});

  TextEditingController nameInput;
  TextEditingController bioInput;
  TextEditingController phoneInput;

  @override
  void initState() {
    super.initState();
    getInitialValues();
  }

  getInitialValues() {
    nameInput = TextEditingController(text: userSnap['user_name']);
    bioInput = TextEditingController(text: userSnap['about_user']);
    phoneInput = TextEditingController(text: userSnap['user_phone']);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    nameInput.dispose();
    bioInput.dispose();
    phoneInput.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  String name = '';
  String biography = '';
  String userPhone = '';

  //image capture
  File _imageFile;
  String _uploadedFileURL = '';
  //end of image capture

  final ImagePicker _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);

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
      ),
    );

    setState(() {
      _imageFile = croppedFile;
      print(_imageFile.lengthSync());
    });
  }

  //create data
  createDataWithNewImage() {
    DocumentReference ds =
        FirebaseFirestore.instance.collection('Users').doc(userId);
    Map<String, dynamic> tasks = {
      'user_name': name,
      'user_image': _uploadedFileURL,
      'about_user': biography,
      'user_phone': userPhone,
    };
    ds.update(tasks).whenComplete(() {
      print('profile updated');
      setState(() {
        //loading = false;
        Navigator.pop(context, true);
      });
    });
  }

  createDataWithOldImage() {
    DocumentReference ds =
        FirebaseFirestore.instance.collection('Users').doc(userId);
    Map<String, dynamic> tasks = {
      'user_name': name,
      'about_user': biography,
      'user_phone': userPhone,
    };
    ds.update(tasks).whenComplete(() {
      print('profile updated');
      setState(() {
        Navigator.pop(context, true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3aa792),
        title: Text('Update profile'),
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
          return Container(
            width: double.infinity,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: viewportConstraints.maxHeight),
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
                          height: 40,
                        ),
                        Center(
                          child: Container(
                            child: InkWell(
                              child: _imageFile == null
                                  ? CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 82,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          userSnap['user_image'],
                                        ),
                                        radius: 80,
                                        //child: Text('Select Image'),
                                      ),
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
                          height: 40,
                        ),
                        TextFormField(
                          controller: nameInput,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          maxLength: 30,
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              letterSpacing: .5,
                            ),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Name and surname',
                            contentPadding: const EdgeInsets.all(0.0),
                            errorStyle: TextStyle(color: Colors.brown),
                          ),
                          validator: (val) =>
                              val.isEmpty ? ('Enter a name') : null,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: bioInput,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          maxLength: 300,
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              letterSpacing: .5,
                            ),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Bio',
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 8.0),
                            errorStyle: TextStyle(color: Colors.brown),
                          ),
                          validator: (val) => val.length < 30
                              ? ('Too short at least 30 chars')
                              : null,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: phoneInput,
                          keyboardType: TextInputType.phone,
                          maxLength: 13,
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 0),
                            errorStyle: TextStyle(color: Colors.brown),
                          ),
                          validator: (val) => val.length < 10
                              ? ('Enter a valid phone number')
                              : null,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        loading
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
                                height: 48.0,
                                child: FlatButton(
                                  color: Color(0xff3aa792),
                                  child: Text(
                                    'Submit',
                                    style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: .5,
                                      ),
                                    ),
                                  ),
                                  shape: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff3aa792), width: 2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  onPressed: () async {
                                    setState(() {
                                      name = nameInput.text;
                                    });
                                    print(name);
                                    if (_imageFile == null) {
                                      if (_formKey.currentState.validate()) {
                                        setState(() {
                                          loading = true;
                                          name = nameInput.text;
                                          biography = bioInput.text;
                                          userPhone = phoneInput.text;
                                          createDataWithOldImage();
                                        });
                                        // do something
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
                                    } else {
                                      if (_formKey.currentState.validate()) {
                                        setState(() {
                                          loading = true;
                                          name = nameInput.text;
                                          biography = bioInput.text;
                                          userPhone = phoneInput.text;
                                        });
                                        _startUpload();
                                        // do something
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
                          height: 40,
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

    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      await storage.ref('Profiles/$uid.jpg').putFile(_imageFile);
      print('File Uploaded');

      String downloadURL =
          await storage.ref('Profiles/$uid.jpg').getDownloadURL();

      setState(() {
        _uploadedFileURL = downloadURL;
        createDataWithNewImage();
      });
    } on FirebaseException catch (e) {
      final snackBar = SnackBar(
        content: Text(
          e.message,
          textAlign: TextAlign.center,
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
      setState(() {
        loading = false;
      });
    }
  }
}
