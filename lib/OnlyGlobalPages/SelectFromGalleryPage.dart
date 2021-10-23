import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:valuhworld/OnlyGlobalPages/PostToFeedPage.dart';

class SelectFromGalleryPage extends StatefulWidget {
  @override
  _SelectFromGalleryPageState createState() => _SelectFromGalleryPageState();
}

class _SelectFromGalleryPageState extends State<SelectFromGalleryPage> {
  final ImagePicker _picker = ImagePicker();
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3aa792),
        title: Text(
          'Post to feed',
          style: GoogleFonts.quicksand(),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 48,
              ),
              Text(
                'Share your \nmoments with the world',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: .5,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'Share your unforgettable moments with your circle of friends, let them know what you are up to. Enjoy the feature!',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    letterSpacing: .5,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    color: Color(0xff3aa792),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side: BorderSide(
                        color: Color(0xff3aa792),
                      ),
                    ),
                    child: Text(
                      'From Camera',
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: .5,
                        ),
                      ),
                    ),
                    onPressed: () {
                      getImageFromCamera();
                    },
                  ),
                  SizedBox(width: 16),
                  FlatButton(
                    color: Color(0xff3aa792),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side: BorderSide(
                        color: Color(0xff3aa792),
                      ),
                    ),
                    child: Text(
                      'From Gallery',
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: .5,
                        ),
                      ),
                    ),
                    onPressed: () {
                      getImageFromGallery();
                    },
                  ),
                  // const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getImageFromGallery() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        //aspectRatio: CropAspectRatio(ratioX: 2, ratioY: 3),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        maxHeight: 1920,
        maxWidth: 1080,
        compressQuality: 80,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop image',
            toolbarColor: Colors.green,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    setState(() {
      _imageFile = croppedFile;
      print(_imageFile.lengthSync());
    });

    var decodedImage = await decodeImageFromList(croppedFile.readAsBytesSync());
    print(decodedImage.width);
    print(decodedImage.height);

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => PostToFeedPage(
          image: _imageFile,
          height: decodedImage.height,
          width: decodedImage.width,
        ),
      ),
    );
  }

  Future getImageFromCamera() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        //aspectRatio: CropAspectRatio(ratioX: 2, ratioY: 3),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        maxHeight: 1920,
        maxWidth: 1080,
        compressQuality: 80,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop image',
            toolbarColor: Colors.green,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    setState(() {
      _imageFile = croppedFile;
      print(_imageFile.lengthSync());
    });

    var decodedImage = await decodeImageFromList(croppedFile.readAsBytesSync());
    print(decodedImage.width);
    print(decodedImage.height);

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => PostToFeedPage(
          image: _imageFile,
          height: decodedImage.height,
          width: decodedImage.width,
        ),
      ),
    );
  }
}
