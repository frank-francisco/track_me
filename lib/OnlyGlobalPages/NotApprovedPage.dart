import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotApprovedPage extends StatefulWidget {
  @override
  _NotApprovedPageState createState() => _NotApprovedPageState();
}

class _NotApprovedPageState extends State<NotApprovedPage> {
  @override
  void initState() {
    super.initState();
    readSavedLanguage();
  }

  String _selectedLanguage = 'Romanian';

  readSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_language';
    final value = prefs.getString(key) ?? 'Romanian';
    print('read: $value');
    setState(() {
      _selectedLanguage = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedLanguage == 'Romanian'
              ? 'Verificare in Asteptare'
              : 'Pending verification',
          style: GoogleFonts.openSans(
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
            Container(
              child: Icon(
                Icons.security,
                color: Colors.grey,
                size: 60,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              _selectedLanguage == 'Romanian'
                  ? 'Contul dvs. \nașteaptă verificarea'
                  : 'Your account \nis waiting for verification',
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.black87,
                  letterSpacing: .5,
                ),
              ),
            ),
            Text(
              _selectedLanguage == 'Romanian'
                  ? 'Din motive de securitate ale utilizatorilor noștri, verificăm fiecare cont care se înscrie. Vă vom notifica după finalizarea procesului. \nMultumesc!'
                  : 'For security reasons of our users, we verify every account that signs up. We will notify you once the process is complete. \nThank you!',
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                  letterSpacing: .5,
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            InkWell(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 0.0),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                ),
                child: Align(
                  child: Text(
                    _selectedLanguage == 'Romanian' ? 'Continua' : 'Continue',
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
