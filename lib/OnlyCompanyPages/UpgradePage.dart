import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valuhworld/OnlyCompanyPages/PurchasePage.dart';

class UpgradePage extends StatefulWidget {
  final String userId;
  UpgradePage({this.userId});

  @override
  _UpgradePageState createState() => _UpgradePageState(userId: userId);
}

class _UpgradePageState extends State<UpgradePage> {
  String userId;
  _UpgradePageState({this.userId});

  String _silverBody =
      'This package includes up to 25 safety personnel including the admin, the host account will be able to connect with every guest with a password and be able to receive their location data, which is sent to the nearest safety personnel during an emergency.';
  String _goldBody =
      'This package includes up to 50 safety personnel including the admin, the host account will be able to connect with every guest with a password and be able to receive their location data, which is sent to the nearest safety personnel during an emergency';
  String _platinumBody =
      'This package includes up to 100 safety personnel including the admin, the host account will be able to connect with every guest with a password and be able to receive their location data, which is sent to the nearest safety personnel during an emergency';
  String _palladiumBody =
      'This package includes unlimited safety personnel including the admin, the host account will be able to connect with every guest with a password and be able to receive their location data, which is sent to the nearest safety personnel during an emergency';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3aa792),
        title: Text(
          'Upgrade',
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            item('Silver', '15 USD', _silverBody, 'Silver', 'up to 25 members'),
            item('Gold', '30 USD', _goldBody, 'Gold', 'up to 50 members'),
            item('Platinum', '60 USD', _platinumBody, 'Platinum',
                'up to 100 members'),
            item('Palladium', '120 USD', _palladiumBody, 'Palladium',
                'unlimited members'),
            SizedBox(
              height: 20,
            ),
            // ItemTwo(),
            // ItemThree(),
          ],
        ),
      ),
    );
  }

  Widget item(String title, String price, String body, String id, String size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color(0xff3aa792),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        color: Color(0xff3aa792),
                        height: 1,
                        width: 16,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        title,
                        style: GoogleFonts.quicksand(
                          fontSize: 18,
                          color: Color(0xff3aa792),
                          fontWeight: FontWeight.bold,
                          letterSpacing: .5,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    price,
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                  Text(
                    size,
                    style: GoogleFonts.quicksand(
                      textStyle: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      body,
                      style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: Colors.lightGreen[100],
                      ),
                      child: Align(
                        child: Text(
                          'Purchase now!',
                          style: GoogleFonts.quicksand(
                            textStyle: TextStyle(
                              color: Color(0xff3aa792),
                              fontSize: 18,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      print("---------- Buy Item Button Pressed");
                      if (id == 'Silver') {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => PurchasePage(
                              userId: userId,
                              packageId: 'Silver',
                            ),
                          ),
                        );
                      } else if (id == 'Gold') {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => PurchasePage(
                              userId: userId,
                              packageId: 'Gold',
                            ),
                          ),
                        );
                      } else if (id == 'Platinum') {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => PurchasePage(
                              userId: userId,
                              packageId: 'Platinum',
                            ),
                          ),
                        );
                      } else if (id == 'Palladium') {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => PurchasePage(
                              userId: userId,
                              packageId: 'Palladium',
                            ),
                          ),
                        );
                      }
                    },
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
    );
  }
}
