import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valuhworld/OnlyCompanyPages/ConnectionsPage.dart';
import 'package:valuhworld/OnlyCompanyPages/EmergenciesPage.dart';
import 'package:valuhworld/OnlyCompanyPages/EnrollmentPage.dart';
import 'package:valuhworld/OnlyGlobalPages/HostsPage.dart';
import 'package:valuhworld/OnlyGlobalPages/ChatsPage.dart';
import 'package:valuhworld/OnlyGlobalPages/FeedsPage.dart';
import 'package:valuhworld/OnlyGlobalPages/GettingStartedPage.dart';
import 'package:valuhworld/OnlyGlobalPages/MySubscriptionsPage.dart';
import 'package:valuhworld/OnlyGlobalPages/NavigatorPage.dart';
import 'package:valuhworld/OnlyGlobalPages/NotificationsPage.dart';
import 'package:valuhworld/OnlyGlobalPages/OnBoardingPage.dart';
import 'package:valuhworld/OnlyPersonalPages/ConnectedHostsPage.dart';
import 'package:valuhworld/OnlyPersonalPages/MyCircleListPage.dart';
import 'package:valuhworld/OnlyPersonalPages/MyCirclePage.dart';
import 'package:valuhworld/OnlyPersonalPages/PersonalProfilePage.dart';
import 'package:valuhworld/OnlyGlobalPages/SOSPage.dart';
import 'package:valuhworld/OnlyGlobalPages/SelectFromGalleryPage.dart';
import 'package:valuhworld/OnlyGlobalPages/SupportPage.dart';
import 'package:valuhworld/OnlyServices/profileData.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //bool isSignedIn = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  DateTime _date = DateTime.now();
  String _onlineUserId;

  bool userFlag = false;
  var details;
  String _userType = 'not_set';
  String _userPower = 'not_set';
  String _deviceToken = '';

  @override
  void initState() {
    super.initState();

    getUser().then(
      (user) async {
        if (user != null) {
          final User user = _auth.currentUser;
          _onlineUserId = user.uid;

          ProfileService()
              .getProfileInfo(_onlineUserId)
              .then((QuerySnapshot docs) {
            if (docs.docs.isNotEmpty) {
              setState(
                () {
                  userFlag = true;
                  details = docs.docs[0].data();
                  _userType = details['account_type'];
                  _userPower = details['user_authority'];
                  //_goWatchVideos();

                  getToken();
                },
              );
            }
          });
        }
      },
    );
  }

  Future<User> getUser() async {
    return _auth.currentUser;
  }

  Future _logOut() async {
    try {
      await FirebaseAuth.instance.signOut();

      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) => OnBoardingPage(),
          ),
          (r) => false);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  getToken() {
    _firebaseMessaging.getToken().then((deviceToken) {
      print('Device token: $deviceToken');
      setState(() {
        _deviceToken = deviceToken;
      });
    });
    updateToken();
  }

  Timer _timer;

  updateToken() {
    _timer = new Timer(const Duration(milliseconds: 1000), () {
      DocumentReference ds =
          FirebaseFirestore.instance.collection('Users').doc(_onlineUserId);
      Map<String, dynamic> _tasks = {
        'device_token': _deviceToken,
      };
      ds.update(_tasks).whenComplete(() {
        print('token updated: $_deviceToken');
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  //////
  PageController _pageController = PageController(initialPage: 0);
  int _selectedItemPosition = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3aa792),
        title: Text(
          'Valuhworld',
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: .5,
            ),
          ),
        ),
        actions: <Widget>[
          //_upgradeAction(),
          SizedBox(
            width: 10,
          ),
          _notificationBell(),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            StreamBuilder(
              stream: _fireStore
                  .collection('Users')
                  .where('user_id', isEqualTo: _onlineUserId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Color(0xff3aa792),
                    ),
                    accountName: Text(
                      'User not found',
                      style: GoogleFonts.quicksand(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    currentAccountPicture: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: Colors.blueGrey,
                        size: 40,
                      ),
                    ),
                    accountEmail: Text(
                      '...',
                      style: GoogleFonts.quicksand(),
                    ),
                  );
                } else {
                  if (snapshot.data.docs.length == 0) {
                    return UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: Color(0xff3aa792),
                      ),
                      accountName: Text(
                        'User not found',
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      currentAccountPicture: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          color: Colors.blueGrey,
                          size: 40,
                        ),
                      ),
                      accountEmail: Text(
                        '...',
                        style: GoogleFonts.quicksand(),
                      ),
                    );
                  } else {
                    DocumentSnapshot userInfo = snapshot.data.docs[0];
                    return UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: Color(0xff3aa792),
                      ),
                      accountName: Text(
                        userInfo['user_name'],
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      currentAccountPicture: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => PersonalProfilePage(
                                userId: _onlineUserId,
                                userSnap: details,
                              ),
                            ),
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: userInfo['user_image'],
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.white,
                            backgroundImage: imageProvider,
                          ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => CircleAvatar(
                            radius: 10,
                            backgroundImage:
                                AssetImage('assets/images/holder.png'),
                          ),
                        ),
                      ),
                      accountEmail: Text(
                        'Personal',
                        style: GoogleFonts.quicksand(),
                      ),
                    );
                  }
                }
              },
            ),

            //personal column
            Visibility(
              visible: true,
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      ('My circle').toUpperCase(),
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => MyCircleListPage(
                            userId: _onlineUserId,
                            userPlan: details['user_plan'],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            //Global column
            Column(
              children: [
                ListTile(
                  title: Text(
                    ('Support').toUpperCase(),
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => SupportPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text(
                    ('Log out').toUpperCase(),
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  onTap: () {
                    _logOut();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: PageView(
        onPageChanged: _onPageChanged,
        controller: _pageController,
        children: <Widget>[
          SOSPage(),
          ChatsPage(),
          //SelectFromGalleryPage(),
          FeedsPage(),
          // HostsPage(),
        ],
      ),
      bottomNavigationBar: SnakeNavigationBar.color(
        //height: 80,
        behaviour: SnakeBarBehaviour.pinned,
        snakeShape: SnakeShape.indicator,
        shape: null,
        padding: EdgeInsets.zero,

        ///configuration for SnakeNavigationBar.color
        snakeViewColor: Color(0xff008376),
        selectedItemColor: Color(0xff008376),
        unselectedItemColor: Color(0xff696969),

        ///configuration for SnakeNavigationBar.gradient
        // snakeViewGradient: selectedGradient,
        // selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
        // unselectedItemGradient: unselectedGradient,

        showUnselectedLabels: true,
        showSelectedLabels: true,

        currentIndex: _selectedItemPosition,
        onTap: (index) {
          _pageController.jumpToPage(index);
          setState(() {
            _selectedItemPosition = index;
          });
        },
        //=> setState(() => _selectedItemPosition = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.userShield,
            ),
            label: 'sos',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.comments,
            ),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list_alt,
            ),
            label: 'Feeds',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.business_rounded,
          //   ),
          //   label: 'Host',
          // ),
        ],
        selectedLabelStyle: const TextStyle(fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
      ),
    );
  }

  void _onPageChanged(int page) {
    switch (page) {
      case 0:
        setState(() {
          _selectedItemPosition = page;
        });
        break;
      case 1:
        setState(() {
          _selectedItemPosition = page;
        });
        break;

      case 2:
        setState(() {
          _selectedItemPosition = page;
        });
        break;
      case 3:
        setState(() {
          _selectedItemPosition = page;
        });
        break;
      case 4:
        setState(() {
          _selectedItemPosition = page;
        });
        break;
    }
  }

  Widget _notificationBell() {
    return StreamBuilder(
      stream: _fireStore
          .collection('Users')
          .where('user_id', isEqualTo: _onlineUserId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return IconButton(
              icon: Icon(FontAwesomeIcons.bell),
              onPressed: () {
                _onBellClick();
              });
        } else {
          if (snapshot.data.docs.length == 0) {
            return IconButton(
                icon: Icon(FontAwesomeIcons.bell),
                onPressed: () {
                  //_onBellClick();
                });
          } else {
            if (snapshot.data.docs[0]['notification_count'] == 0) {
              return IconButton(
                  icon: Icon(FontAwesomeIcons.bell),
                  onPressed: () {
                    _onBellClick();
                  });
            } else {
              int myCount = snapshot.data.docs[0]['notification_count'];
              return Stack(
                children: <Widget>[
                  IconButton(
                      icon: Icon(FontAwesomeIcons.bell),
                      onPressed: () {
                        _onBellClick();
                      }),
                  Positioned(
                    right: 11,
                    top: 11,
                    child: new Container(
                      padding: EdgeInsets.all(2),
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        myCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              );
            }
          }
        }
      },
    );
  }

  _onBellClick() {
    DocumentReference usersRef =
        _fireStore.collection('Users').doc(_onlineUserId);
    usersRef.update({'notification_count': 0});
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => NotificationsPage(),
      ),
    );
  }
}
