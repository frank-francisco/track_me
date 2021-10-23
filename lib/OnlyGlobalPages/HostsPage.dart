import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valuhworld/OnlyCompanyPages/PublicCompanyPage.dart';

class HostsPage extends StatefulWidget {
  @override
  _HostsPageState createState() => _HostsPageState();
}

class _HostsPageState extends State<HostsPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String userId = '';
  String input = '';

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
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.name,
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black54,
                    letterSpacing: .5,
                  ),
                ),
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Search',
                  contentPadding: const EdgeInsets.all(0.0),
                  errorStyle: TextStyle(color: Colors.brown),
                ),
                onChanged: (val) {
                  setState(() => input = val.trim());
                },
              ),
            ),
            StreamBuilder(
              stream: (input != "" && input != null)
                  ? FirebaseFirestore.instance
                      .collection('Users')
                      .where('account_type', isEqualTo: 'Company')
                      .where('searchKeywords', arrayContains: input)
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection('Users')
                      .where('account_type', isEqualTo: 'Company')
                      .orderBy('creation_date', descending: true)
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
                      primary: false,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot myHosts = snapshot.data.docs[index];
                        return hostItem(
                            index, myHosts, snapshot.data.docs.length);
                      },
                    );
                  }
                }
              },
            ),
          ],
        ),
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
              'There are no hosts',
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
              'There are no hosts on the platform matching, hosts will appear here when they available.',
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
    DocumentSnapshot myHosts,
    int length,
  ) {
    //var height = 300.0;
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
                  secondUserId: myHosts['user_id'],
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Row(
              children: [
                Image(
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  image: NetworkImage(myHosts['user_image']),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      myHosts['user_name'],
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
                        myHosts['about_user'],
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
      ),
    );
  }
}
