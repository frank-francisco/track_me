import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:measured_size/measured_size.dart';
import 'package:valuhworld/OnlyGlobalPages/PublicProfilePage.dart';
import 'package:valuhworld/OnlyServices/profileData.dart';
import 'package:valuhworld/OnlyServices/time_ago_since_now_en.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ChatsEngagePage extends StatefulWidget {
  final String userId;
  final String secondUserId;
  final String userName;
  final String userImage;
  ChatsEngagePage(
      {this.userId, this.secondUserId, this.userName, this.userImage});

  @override
  _ChatsEngagePageState createState() => _ChatsEngagePageState(
      userId: userId,
      secondUserId: secondUserId,
      userName: userName,
      userImage: userImage);
}

class _ChatsEngagePageState extends State<ChatsEngagePage> {
  String userId;
  String secondUserId;
  String userName;
  String userImage;
  _ChatsEngagePageState(
      {this.userId, this.secondUserId, this.userName, this.userImage});

  TextEditingController textEditingController = new TextEditingController();
  String _message = '';
  String _uploadedFileURL = '';
  String _time = DateTime.now().millisecondsSinceEpoch.toString();
  var _height = 0.0;
  bool userFlag = false;
  var details;

  File _selectedFile;
  int _imageHeight = 0;
  int _imageWidth = 0;
  final ImagePicker _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        // aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
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
    var decodedImage = await decodeImageFromList(croppedFile.readAsBytesSync());
    print(decodedImage.width);
    print(decodedImage.height);

    setState(
      () {
        _selectedFile = croppedFile;
        _imageHeight = decodedImage.height;
        _imageWidth = decodedImage.width;
        print(_selectedFile.lengthSync());
      },
    );
  }

  Widget popupMenuButton() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        size: 26.0,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: '0',
          child: Row(
            children: [
              Icon(
                FontAwesomeIcons.trash,
                color: Colors.black87,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Clear chat',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                    letterSpacing: .5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      onSelected: (retVal) async {
        if (retVal == '0') {
          FirebaseFirestore.instance
              .collection('Chats')
              .doc(userId)
              .collection(secondUserId)
              .get()
              .then((snapshot) {
            for (DocumentSnapshot ds in snapshot.docs) {
              ds.reference.delete();
              print("chat Deleted");
            }
            ;
          });

          FirebaseFirestore.instance
              .collection('Chats')
              .doc(userId)
              .collection(secondUserId)
              .get()
              .then((snapshot) {
            for (DocumentSnapshot ds in snapshot.docs) {
              ds.reference.delete();
              print("chat Deleted");
            }
            ;
          });

          DocumentReference ds = FirebaseFirestore.instance
              .collection('MyChatHeads')
              .doc(userId)
              .collection('Heads')
              .doc(secondUserId);
          ds.delete().then((value) => print("chat head Deleted")).catchError(
                (error) => print("Failed to delete chat head: $error"),
              );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();

    ProfileService().getProfileInfo(userId).then((QuerySnapshot docs) {
      if (docs.docs.isNotEmpty) {
        setState(
          () {
            userFlag = true;
            details = docs.docs[0].data();
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3aa792),
        titleSpacing: 0,
        title: Container(
          child: ConstrainedBox(
            constraints: BoxConstraints.expand(height: 40),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => PublicProfilePage(
                          userId: userId,
                          secondUserId: secondUserId,
                        ),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: userImage,
                    imageBuilder: (context, imageProvider) => CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white54,
                      child: CircleAvatar(
                        radius: 19,
                        backgroundColor: Colors.white,
                        backgroundImage: imageProvider,
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => CircleAvatar(
                      radius: 10,
                      backgroundImage: AssetImage('assets/images/holder.png'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Text(
                    userName,
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        leading: Container(
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        actions: [
          popupMenuButton(),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.grey[100],
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Chats')
                  .doc(userId)
                  .collection(secondUserId)
                  .orderBy('message_time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: SpinKitThreeBounce(
                        color: Colors.black54,
                        size: 20.0,
                      ),
                    ),
                  );
                } else {
                  if (snapshot.data.documents.length == 0) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Image(
                            image: AssetImage('assets/images/empty.png'),
                            width: double.infinity,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        // physics: NeverScrollableScrollPhysics(),
                        // primary: false,
                        padding: EdgeInsets.zero,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot myPresses =
                              snapshot.data.documents[index];
                          if (myPresses['message_owner'] == userId) {
                            return Padding(
                              padding: index == 0
                                  ? EdgeInsets.only(bottom: _height + 26)
                                  : EdgeInsets.only(bottom: 0),
                              child: Container(
                                child: Bubble(
                                  margin: BubbleEdges.only(top: 10),
                                  nip: BubbleNip.rightTop,
                                  alignment: Alignment.topRight,
                                  color: Colors.lightGreen[100],
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: myPresses['message_extra'] ==
                                                'image'
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: AspectRatio(
                                                  aspectRatio: 4 / 3,
                                                  child: Container(
                                                    child: CachedNetworkImage(
                                                      imageUrl: myPresses[
                                                          'message_file_url'],
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Image(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      placeholder:
                                                          (context, url) =>
                                                              Image(
                                                        image: AssetImage(
                                                            'assets/images/place_holder.png'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image(
                                                        image: AssetImage(
                                                            'assets/images/place_holder.png'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: 0,
                                                height: 0,
                                              ),
                                      ),
                                      myPresses['message_body'] == ''
                                          ? Container()
                                          : Text(
                                              myPresses['message_body'],
                                              style: GoogleFonts.quicksand(
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                      Text(
                                        timeAgoSinceDateEn(
                                          DateTime.fromMillisecondsSinceEpoch(
                                            myPresses['message_time'],
                                          ).toString(),
                                        ),
                                        //postSnap['press_formatted_date'],
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Padding(
                              padding: index == 0
                                  ? EdgeInsets.only(bottom: _height + 26)
                                  : EdgeInsets.only(bottom: 0),
                              child: Bubble(
                                margin: BubbleEdges.only(top: 10),
                                alignment: Alignment.topLeft,
                                nip: BubbleNip.leftTop,
                                color: Color(0xffd4eaf5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    myPresses['message_extra'] == 'image'
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0),
                                            child: AspectRatio(
                                              aspectRatio: 4 / 3,
                                              child: Container(
                                                //height: 200,
                                                child: CachedNetworkImage(
                                                  imageUrl: myPresses[
                                                      'message_file_url'],
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Image(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Image(
                                                    image: AssetImage(
                                                        'assets/images/place_holder.png'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Image(
                                                    image: AssetImage(
                                                        'assets/images/place_holder.png'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 0,
                                            width: 0,
                                          ),
                                    myPresses['message_body'] == ''
                                        ? Container()
                                        : Text(
                                            myPresses['message_body'],
                                            style: GoogleFonts.quicksand(
                                              fontSize: 16,
                                              color: Colors.black87,
                                            ),
                                          ),
                                    Text(
                                      timeAgoSinceDateEn(
                                        DateTime.fromMillisecondsSinceEpoch(
                                          myPresses['message_time'],
                                        ).toString(),
                                      ),
                                      //postSnap['press_formatted_date'],
                                      style: GoogleFonts.quicksand(
                                        textStyle: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  }
                }
              },
            ),
          ),
          Positioned(
            bottom: 10.0,
            left: 10.0,
            right: 10.0,
            child: MeasuredSize(
              onChange: (Size size) {
                setState(() {
                  print(size);
                  _height = size.height;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                //height: 58,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  child: Column(
                    children: [
                      _selectedFile == null
                          ? Container()
                          : _imageWidth == 0
                              ? Container()
                              : Stack(
                                  children: [
                                    AspectRatio(
                                      aspectRatio: (_imageWidth / _imageHeight),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: FileImage(_selectedFile),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomRight,
                                              colors: [
                                                Colors.black,
                                                Colors.black.withOpacity(.1),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 10.0,
                                      right: 14.0,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _selectedFile = null;
                                            _imageHeight = 0;
                                            _imageWidth = 0;
                                          });
                                        },
                                        child: CircleAvatar(
                                          radius: 14,
                                          backgroundColor: Colors.white,
                                          //backgroundImage: imageProvider,
                                          child: Icon(
                                            FontAwesomeIcons.times,
                                            color: Colors.grey,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              getImage();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 8.0,
                                bottom: 20,
                              ),
                              child: Icon(
                                FontAwesomeIcons.image,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: textEditingController,
                              keyboardType: TextInputType.multiline,
                              textCapitalization: TextCapitalization.sentences,
                              maxLines: null,
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black54,
                                  letterSpacing: .5,
                                ),
                              ),
                              decoration: InputDecoration(
                                labelText: 'Message',
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 0.0, vertical: 0.0),
                                errorStyle: TextStyle(color: Colors.brown),
                              ),
                              onChanged: (val) {
                                setState(() => _message = val);
                              },
                              validator: (val) =>
                                  val.length < 1 ? ('Too short') : null,
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          InkWell(
                            onTap: () {
                              _submitMessage();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 8.0, bottom: 20),
                              child: Icon(
                                Icons.send_rounded,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _submitMessage() {
    setState(() {
      //_imageHeight = 0;
      // _imageHeight = 0;
      _imageWidth = 0;
    });
    //To my all list of chats
    DocumentReference ds = FirebaseFirestore.instance
        .collection('Chats')
        .doc(userId)
        .collection(secondUserId)
        .doc();
    Map<String, dynamic> _tasks = {
      'message_owner': userId,
      'message_read': '-',
      'message_time': DateTime.now().millisecondsSinceEpoch,
      'message_body': _message.trim(),
      'message_id': ds.id,
      'message_file_url': '-',
      'message_extra': _selectedFile == null ? 'extra' : 'image',
    };
    ds.set(_tasks).whenComplete(() {
      print('Message sent');
    });

    //To His/her all list of chats
    DocumentReference ds2 = FirebaseFirestore.instance
        .collection('Chats')
        .doc(secondUserId)
        .collection(userId)
        .doc();
    Map<String, dynamic> _tasks2 = {
      'message_owner': userId,
      'message_read': '-',
      'message_time': DateTime.now().millisecondsSinceEpoch,
      'message_body': _message.trim(),
      'message_id': ds2.id,
      'message_file_url': '-',
      'message_extra': _selectedFile == null ? 'extra' : 'image',
    };
    ds2.set(_tasks2).whenComplete(() {
      print('Duplicate message sent');
    });

    //To my heads list
    DocumentReference headsDs1 = FirebaseFirestore.instance
        .collection('MyChatHeads')
        .doc(userId)
        .collection('Heads')
        .doc(secondUserId);
    Map<String, dynamic> _headsTask = {
      'head_subject': secondUserId,
      'head_subject_online': '-',
      'head_time': DateTime.now().millisecondsSinceEpoch,
      'head_last_message': _message.trim(),
      'head_id': secondUserId,
      'head_extra': _selectedFile == null ? 'extra' : 'image',
    };
    headsDs1.set(_headsTask, SetOptions(merge: true)).whenComplete(() {
      print('Head list created');
    });

    //To his/her heads list
    DocumentReference headsDs2 = FirebaseFirestore.instance
        .collection('MyChatHeads')
        .doc(secondUserId)
        .collection('Heads')
        .doc(userId);
    Map<String, dynamic> _headsTask2 = {
      'head_subject': userId,
      'head_subject_online': '-',
      'head_time': DateTime.now().millisecondsSinceEpoch,
      'head_last_message': _message.trim(),
      'head_id': userId,
      'head_extra': _selectedFile == null ? 'extra' : 'image',
    };
    textEditingController.text = '';
    headsDs2.set(_headsTask2, SetOptions(merge: true)).whenComplete(
      () {
        print('Head list created');
      },
    );

    _sendNotification();

    checkForUploads(ds.id, ds2.id);
  }

  checkForUploads(String id1, String id2) {
    if (_selectedFile == null) {
    } else {
      _startUpload(id1, id2);
    }
  }

  Future<void> _startUpload(String id1, String id2) async {
    final User user = FirebaseAuth.instance.currentUser;
    final uid = user.uid;
    final userEmail = user.email;

    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      await storage.ref('Chats/$_time.jpg').putFile(_selectedFile);
      print('File Uploaded');

      String downloadURL =
          await storage.ref('Chats/$_time.jpg').getDownloadURL();

      setState(
        () {
          _uploadedFileURL = downloadURL;
          updateData(id1, id2);
          _selectedFile = null;
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
        //_loading = false;
      });
    }
  }

  updateData(String id1, String id2) {
    //To my all list of chats
    DocumentReference ds = FirebaseFirestore.instance
        .collection('Chats')
        .doc(userId)
        .collection(secondUserId)
        .doc(id1);
    Map<String, dynamic> _tasks = {
      'message_file_url': _uploadedFileURL,
    };
    ds.update(_tasks).whenComplete(() {
      print('Message updated');
    });

    //To His/her all list of chats
    DocumentReference ds2 = FirebaseFirestore.instance
        .collection('Chats')
        .doc(secondUserId)
        .collection(userId)
        .doc(id2);
    Map<String, dynamic> _tasks2 = {
      'message_file_url': _uploadedFileURL,
    };
    ds2.update(_tasks2).whenComplete(() {
      print('Duplicate message updated');
    });
  }

  _sendNotification() {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('Notifications')
        .doc('important')
        .collection(secondUserId)
        .doc(secondUserId);
    Map<String, dynamic> tasks = {
      'notification_tittle': 'New message!',
      'notification_details':
          '${details['user_name']} sent you a text message open message tab to see.',
      'notification_time': DateTime.now().millisecondsSinceEpoch,
      'notification_sender': 'Valuhworld',
      'action_title': 'Message',
      'action_destination': '',
      'latitudes': '',
      'longitudes': '-',
      'action_key': '',
      'post_id': 'extra',
    };
    ds.set(tasks).whenComplete(() {
      print('Notification sent');
      DocumentReference ds =
          FirebaseFirestore.instance.collection('Users').doc(secondUserId);
      Map<String, dynamic> _tasks = {
        'notification_count': FieldValue.increment(1),
      };
      ds.update(_tasks).whenComplete(() {
        print('notification count updated');
      });
    });
    _sendTrigger();
  }

  _sendTrigger() {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('Notifications')
        .doc('important')
        .collection(secondUserId)
        .doc();
    Map<String, dynamic> tasks = {
      'notification_tittle': 'New trigger!',
      'notification_details': 'This is a notification trigger',
      'notification_time': 0,
      'notification_sender': 'invisible',
      'action_title': 'invisible',
      'action_destination': '',
      'latitudes': '',
      'longitudes': '-',
      'action_key': '',
      'post_id': 'extra',
    };
    ds.set(tasks);
  }
}
