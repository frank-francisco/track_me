import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatefulWidget {
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  Future<void> _launched;

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3aa792),
        title: Text(
          'Customer support',
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Image(
                image: AssetImage('assets/images/contact.png'),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Contact the team:',
              style: GoogleFonts.quicksand(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              ('Our team is currently working on live chat support. If there are any problems, do not hesitate to contact us via the information below.'),
              style: GoogleFonts.quicksand(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.envelopeOpenText,
                size: 24,
                color: Colors.blueGrey,
              ),
              title: Text(
                'Email',
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'suport@valuhworld.com',
                style: GoogleFonts.quicksand(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.facebookMessenger,
                size: 24,
                color: Colors.blueGrey,
              ),
              title: Text(
                'Messenger',
                style: GoogleFonts.quicksand(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'm.me/valuhworld',
                style: GoogleFonts.quicksand(),
              ),
              onTap: () {
                setState(() {
                  _launched = _launchInBrowser(
                      'https://www.facebook.com/2Value-109123317193036/');
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
