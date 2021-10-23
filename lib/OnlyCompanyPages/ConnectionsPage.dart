import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ConnectionsPage extends StatefulWidget {
  @override
  _ConnectionsPageState createState() => _ConnectionsPageState();
}

class _ConnectionsPageState extends State<ConnectionsPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userId = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUid();
  }

  getUid() {
    final User user = auth.currentUser;
    setState(() {
      userId = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('MyHosts')
          .doc(userId)
          .collection('AllHosts')
          .orderBy('connected_time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: SpinKitThreeBounce(
              color: Colors.black54,
              size: 20.0,
            ),
          );
        } else {
          if (snapshot.data.docs.length == 0) {
            return emptyView();
          } else {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot myCircle = snapshot.data.docs[index];
                return connectionItem(
                    index, myCircle, snapshot.data.docs.length);
              },
            );
          }
        }
      },
    );
  }

  Widget emptyView() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 48,
            ),
            Text(
              'Your connections is empty',
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
              'When people connect to you, they will appear here.',
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  fontSize: 16.0,
                  letterSpacing: .5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget connectionItem(
    int index,
    DocumentSnapshot myCircle,
    int length,
  ) {
    //var height = 300.0;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .where('user_id', isEqualTo: myCircle['connection_requested'])
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              index == 0
                  ? SizedBox(
                      height: 10.0,
                    )
                  : SizedBox(
                      height: 0.0,
                    ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: InkWell(
                    onTap: () {},
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl: 'https://picsum.photos/200/300/?blur',
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white,
                            backgroundImage: imageProvider,
                          ),
                          placeholder: (context, url) => CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                AssetImage('assets/images/holder.png'),
                          ),
                          errorWidget: (context, url, error) => CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                AssetImage('assets/images/holder.png'),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'LOADING',
                                style: GoogleFonts.quicksand(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  letterSpacing: .5,
                                ),
                              ),
                              //setCompanyName(myInterviews),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                'This user is loading',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.quicksand(
                                  color: Colors.black87,
                                  fontSize: 14.0,
                                  letterSpacing: .5,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
            ],
          );
        } else {
          if (snapshot.data.docs.length == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                index == 0
                    ? SizedBox(
                        height: 10.0,
                      )
                    : SizedBox(
                        height: 0.0,
                      ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: 'https://picsum.photos/200/300/?blur',
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white,
                              backgroundImage: imageProvider,
                            ),
                            placeholder: (context, url) => CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  AssetImage('assets/images/holder.png'),
                            ),
                            errorWidget: (context, url, error) => CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  AssetImage('assets/images/holder.png'),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'USER NOT FOUND',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    letterSpacing: .5,
                                  ),
                                ),
                                //setCompanyName(myInterviews),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  'This user was not found',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.quicksand(
                                    color: Colors.black87,
                                    fontSize: 14.0,
                                    letterSpacing: .5,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            );
          } else {
            DocumentSnapshot userInfo = snapshot.data.docs[0];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                index == 0
                    ? SizedBox(
                        height: 10.0,
                      )
                    : SizedBox(
                        height: 0.0,
                      ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl: userInfo['user_image'],
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white,
                              backgroundImage: imageProvider,
                            ),
                            placeholder: (context, url) => CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  AssetImage('assets/images/holder.png'),
                            ),
                            errorWidget: (context, url, error) => CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  AssetImage('assets/images/holder.png'),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${userInfo['user_name']}',
                                  style: GoogleFonts.quicksand(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                    letterSpacing: .5,
                                  ),
                                ),
                                //setCompanyName(myInterviews),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Text(
                                  '${userInfo['about_user']}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.quicksand(
                                    color: Colors.black87,
                                    fontSize: 14.0,
                                    letterSpacing: .5,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            );
          }
        }
      },
    );
  }
}
