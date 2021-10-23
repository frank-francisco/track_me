import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valuhworld/OnlyGlobalPages/PublicProfilePage.dart';

class SearchUsersPage extends StatefulWidget {
  final String userId;
  SearchUsersPage({this.userId});

  @override
  _SearchUsersPageState createState() => _SearchUsersPageState(userId: userId);
}

class _SearchUsersPageState extends State<SearchUsersPage> {
  String userId;
  _SearchUsersPageState({this.userId});
  String _searchField = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: ConstrainedBox(
          constraints: BoxConstraints.expand(height: 40),
          child: Container(
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
                hintText: 'Search',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0.0),
                errorStyle: TextStyle(color: Colors.brown),
              ),
              onChanged: (val) {
                setState(() => _searchField = val);
              },
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black87,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .where('searchKeywords', arrayContains: _searchField)
            .where('user_id', isNotEqualTo: userId)
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
              return Center(
                child: Container(
                  height: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    children: [
                      Icon(
                        FontAwesomeIcons.searchengin,
                        size: 32,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Text(
                        'Searched users appear here',
                        style: GoogleFonts.quicksand(
                          textStyle: TextStyle(
                            fontSize: 18.0,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot userInfo = snapshot.data.docs[index];
                  return userItem(userInfo);
                },
              );
            }
          }
        },
      ),
    );
  }

  Widget userItem(DocumentSnapshot userInfo) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (_) => PublicProfilePage(
                  userId: userId,
                  secondUserId: userInfo['user_id'],
                ),
              ),
            );
          },
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: userInfo['user_image'],
                imageBuilder: (context, imageProvider) => CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.green,
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    backgroundImage: imageProvider,
                  ),
                ),
                placeholder: (context, url) => CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.green,
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/holder.png'),
                  ),
                ),
                errorWidget: (context, url, error) => CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.green,
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/images/holder.png'),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${userInfo['user_name']}',
                      style: GoogleFonts.quicksand(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        letterSpacing: .5,
                      ),
                    ),
                    //setCompanyName(myInterviews),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      '${userInfo['about_user']}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.quicksand(
                        color: Colors.black87,
                        fontSize: 16.0,
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
    );
  }
}
