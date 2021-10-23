import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valuhworld/OnlyCompanyPages/PublicCompanyPage.dart';

class ConnectedHostsPage extends StatefulWidget {
  final String userId;
  ConnectedHostsPage({this.userId});

  @override
  _ConnectedHostsPageState createState() =>
      _ConnectedHostsPageState(userId: userId);
}

class _ConnectedHostsPageState extends State<ConnectedHostsPage> {
  String userId;
  _ConnectedHostsPageState({this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3aa792),
        title: Text(
          'Connected hosts',
          style: GoogleFonts.quicksand(
            color: Colors.white,
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
      body: StreamBuilder(
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
                  DocumentSnapshot myHost = snapshot.data.docs[index];
                  return hostItem(index, myHost, snapshot.data.docs.length);
                },
              );
            }
          }
        },
      ),
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
              'Your host list is empty',
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
              'Visit the hosts page to connect yourself with hosts. One of your hosts will be alerted incase of emergency.',
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

  Widget hostItem(
    int index,
    DocumentSnapshot myHost,
    int length,
  ) {
    //var height = 300.0;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .where('user_id', isEqualTo: myHost['host_id'])
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Image(
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      image:
                          NetworkImage('https://picsum.photos/200/300/?blur'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOADING',
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width - 140,
                          child: Text(
                            "This user is being loaded",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          if (snapshot.data.docs.length == 0) {
            return Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Image(
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        image:
                            NetworkImage('https://picsum.photos/200/300/?blur'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'USER NOT FOUND',
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width - 140,
                            child: Text(
                              "This user was not found",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            DocumentSnapshot userInfo = snapshot.data.docs[0];
            return Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => PublicCompanyPage(
                          userId: userId,
                          secondUserId: userInfo['user_id'],
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Image(
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        image: NetworkImage(userInfo['user_image']),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userInfo['user_name'],
                            style: GoogleFonts.quicksand(
                              textStyle: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width - 140,
                            child: Text(
                              userInfo['about_user'],
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }
}
