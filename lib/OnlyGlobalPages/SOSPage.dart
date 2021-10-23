import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valuhworld/OnlyGlobalPages/HotSpotsPage.dart';
import 'package:valuhworld/OnlyGlobalPages/PickTrackersPage.dart';
import 'package:valuhworld/OnlyGlobalPages/SafetyTipsPage.dart';
import 'package:valuhworld/OnlyServices/profileData.dart';

class SOSPage extends StatefulWidget {
  @override
  _SOSPageState createState() => _SOSPageState();
}

class _SOSPageState extends State<SOSPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  Timer timer;
  String userId = '';
  var userInfo;
  double _myLatitude;
  double _myLongitude;

  bool sendSOS = true;

  Location location = new Location();
  GoogleMapController _googleMapController;
  Marker _origin;

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _showDialog(BuildContext context) {
    showDialog(
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
                        sendSOS ? 'SOS sent!' : 'SOS canceled!',
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
                        sendSOS
                            ? 'The emergency alert has been initialized, the notifications has been sent out.'
                            : 'The emergency alert has been canceled, the notifications has not been sent out.',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                            onPressed: () {
                              print('go to feedback page');
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Okay',
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.blue,
                                  letterSpacing: .5,
                                ),
                              ),
                            ),
                          ),
                        ],
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getUID();
    getCurrentLocation();
    timer = Timer.periodic(
      Duration(seconds: 30),
      (Timer t) => getCurrentLocation(),
    );
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    timer.cancel();
    super.dispose();
  }

  getUID() {
    final User user = auth.currentUser;
    setState(() {
      userId = user.uid;
      ProfileService().getProfileInfo(userId).then((QuerySnapshot docs) {
        if (docs.docs.isNotEmpty) {
          setState(
            () {
              //userFlag = true;
              userInfo = docs.docs[0].data();
            },
          );
        }
      });
    });
  }

  getCurrentLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {
      _myLatitude = _locationData.latitude;
      _myLongitude = _locationData.longitude;
      print("Hello: $_myLatitude $_myLongitude");
    });

    updateLocation();

    _addMarker(
      LatLng(
        _myLatitude,
        _myLongitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: GoogleMap(
        mapType: MapType.satellite,
        initialCameraPosition: CameraPosition(
          target: _myLatitude == null
              ? LatLng(
                  37.4219983,
                  -122.084,
                )
              : LatLng(
                  _myLatitude,
                  _myLongitude,
                ),
          zoom: 11.5,
        ),
        myLocationEnabled: false,
        zoomControlsEnabled: false,
        onMapCreated: (controller) => _googleMapController = controller,
        markers: {
          if (_origin != null) _origin,
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonTheme(
                  height: 60,
                  minWidth: 60,
                  child: RaisedButton(
                    color: Color(0xff47c8b0),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    child: Icon(
                      Icons.priority_high_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => HotSpotsPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonTheme(
                  height: 60,
                  minWidth: 60,
                  child: RaisedButton(
                    color: Color(0xff47c8b0),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    child: Icon(
                      Icons.near_me,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      //showTrackDialog();
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => PickTrackersPage(
                            latitudes: _myLatitude,
                            longitudes: _myLongitude,
                            userId: userId,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonTheme(
                  height: 60,
                  minWidth: 60,
                  child: RaisedButton(
                    color: Color(0xff47c8b0),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    child: Icon(
                      Icons.campaign_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => SafetyTipsPage(
                            userId: userId,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 60,
                ),
                ButtonTheme(
                  height: 48,
                  minWidth: 120,
                  child: RaisedButton(
                    color: Color(0xffd81a60),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(24.0),
                    ),
                    child: Text(
                      'SOS',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                        letterSpacing: .5,
                      ),
                    ),
                    onPressed: () {
                      //_showDialog(context);
                      _showSnackBar();
                    },
                  ),
                ),
                ButtonTheme(
                  height: 60,
                  minWidth: 60,
                  child: RaisedButton(
                    color: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    child: Icon(Icons.my_location),
                    onPressed: () async {
                      // _serviceEnabled = await location.serviceEnabled();
                      // if (!_serviceEnabled) {
                      //   _serviceEnabled = await location.requestService();
                      //   if (!_serviceEnabled) {
                      //     return;
                      //   }
                      // }
                      //getCurrentLocation();
                      updateLocation();

                      _addMarker(
                        LatLng(
                          _myLatitude,
                          _myLongitude,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  showTrackDialog() {
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
                        'Track link sent!',
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
                        'Your track link has successfully been sent to your circle!',
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
                          },
                          child: Text(
                            "Okay",
                            style: TextStyle(
                              color: Colors.white,
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

  _showSnackBar() {
    sendSos();
    readSavedLatitude();
    readSavedLongitude();
    final snackBar = SnackBar(
      content: Text('Sending SOS in 5 sec...'),
      duration: Duration(seconds: 5),
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'Undo',
        onPressed: () {
          setState(() {
            sendSOS = false;
          });
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  readSavedLatitude() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_latitude';
    final value = prefs.getDouble(key) ?? 0.00;
    print('read: $value');
    setState(() {
      _myLatitude = value;
    });
  }

  readSavedLongitude() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_longitude';
    final value = prefs.getDouble(key) ?? 0.00;
    print('read: $value');
    setState(() {
      _myLongitude = value;
    });
  }

  sendSos() {
    Future.delayed(
      const Duration(seconds: 5),
      () {
        sendSOStoFriend();
        sendSOStoHost();
        setState(
          () {
            _showDialog(context);
          },
        );
      },
    );
  }

  Future sendSOStoFriend() async {
    firestoreInstance
        .collection("MyCircle")
        .doc(userId)
        .collection('AllFriends')
        .where('circle_action', isEqualTo: 'Accepted')
        .limit(5)
        .get()
        .then((querySnapshot) {
      print("length: " + querySnapshot.docs.length.toString());
      querySnapshot.docs.forEach((value) {
        print(value.data()['circle_id']);
        //sending notification
        DocumentReference ds = FirebaseFirestore.instance
            .collection('Notifications')
            .doc('important')
            .collection(value.data()['circle_id'])
            .doc();
        Map<String, dynamic> tasks = {
          'notification_tittle': 'SOS Emergency!',
          'notification_details':
              '${userInfo['user_name']} pressed the emergency button, view location on map. You are receiving this message because you are on ${userInfo['user_name']}\'s circle.',
          'notification_time': DateTime.now().millisecondsSinceEpoch,
          'notification_sender': 'Valuhworld',
          'action_title': 'SOS',
          'action_destination': '',
          'latitudes': _myLatitude,
          'longitudes': _myLongitude,
          'action_key': '',
          'post_id': 'extra',
        };
        ds.set(tasks).whenComplete(() {
          print('Notification sent');
          DocumentReference ds = FirebaseFirestore.instance
              .collection('Users')
              .doc(value.data()['circle_id']);
          Map<String, dynamic> _tasks = {
            'notification_count': FieldValue.increment(1),
          };
          ds.update(_tasks).whenComplete(() {
            print('notification count updated');
            print("$_myLongitude, $_myLatitude");
          });
        });
      });
    }).catchError((onError) {
      print("ERROR");
      print(onError);
    });
  }

  Future sendSOStoHost() async {
    firestoreInstance
        .collection("MyHosts")
        .doc(userId)
        .collection('AllHosts')
        .limit(1)
        .get()
        .then((querySnapshot) {
      print("length: " + querySnapshot.docs.length.toString());
      querySnapshot.docs.forEach((value) {
        print(value.data()['connection_requested']);
        //sending notification
        DocumentReference ds = FirebaseFirestore.instance
            .collection('Notifications')
            .doc('important')
            .collection(value.data()['connection_requested'])
            .doc();
        Map<String, dynamic> tasks = {
          'notification_tittle': 'SOS Emergency!',
          'notification_details':
              '${userInfo['user_name']} pressed the emergency button, view location on map. You are receiving this message because you are on ${userInfo['user_name']}\'s host.',
          'notification_time': DateTime.now().millisecondsSinceEpoch,
          'notification_sender': 'Valuhworld',
          'action_title': 'SOS',
          'action_destination': '',
          'latitudes': _myLatitude,
          'longitudes': _myLongitude,
          'action_key': '',
          'post_id': 'extra',
        };
        ds.set(tasks).whenComplete(() {
          print('Notification to host sent');
          DocumentReference ds = FirebaseFirestore.instance
              .collection('Users')
              .doc(value.data()['connection_requested']);
          Map<String, dynamic> _tasks = {
            'notification_count': FieldValue.increment(1),
          };
          ds.update(_tasks).whenComplete(() {
            print('notification to host count updated');
            print("$_myLongitude, $_myLatitude");
          });
        });
      });
    }).catchError((onError) {
      print("ERROR");
      print(onError);
    });
  }

  updateLocation() {
    _googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            _myLatitude,
            _myLongitude,
          ),
          zoom: 14.5,
          tilt: 50.0,
        ),
      ),
    );
  }

  void _addMarker(LatLng pos) async {
    setState(() {
      _origin = Marker(
        markerId: const MarkerId('origin'),
        infoWindow: const InfoWindow(title: 'Origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        position: pos,
      );
    });
  }
}
