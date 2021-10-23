import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valuhworld/OnlyCompanyPages/AdminAuthorizeUserPage.dart';

class EnrollmentPage extends StatefulWidget {
  @override
  _EnrollmentPageState createState() => _EnrollmentPageState();
}

class _EnrollmentPageState extends State<EnrollmentPage> {
  TextEditingController nameController = TextEditingController();
  int _radioValue = 0;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          break;
        case 1:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3aa792),
        title: Text(
          'Enrollment options',
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16.0,
            ),
            Text(
              'Choose enrollment option,',
              style: GoogleFonts.quicksand(
                color: Colors.black87,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                new Radio(
                  value: 0,
                  activeColor: Color(0xff3aa792),
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                ),
                new Text(
                  'Enroll with password',
                  style: new TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                new Radio(
                  value: 1,
                  activeColor: Color(0xff3aa792),
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                ),
                new Text(
                  'Enroll with emails',
                  style: new TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              'Description:',
              style: GoogleFonts.quicksand(
                color: Colors.black87,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            _radioValue == 0
                ? Text(
                    'All members joining your host will have to enter the '
                    'enrollment password which you created earlier. '
                    'You can provide them with the enrollment password '
                    'for them to join. \nNB: The enrollment password '
                    'should be different from your authentication password.',
                    style: GoogleFonts.quicksand(
                      color: Colors.black87,
                      fontSize: 16.0,
                    ),
                  )
                : Text(
                    'All members joining your host needs their emails to be authorized by you. You authorize their emails by adding them in the from the authorization page.',
                    style: GoogleFonts.quicksand(
                      color: Colors.black87,
                      fontSize: 16.0,
                    ),
                  ),
            _radioValue == 0
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => AdminAuthorizeUserPage(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red[500],
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 10.0,
                          ),
                          child: Text(
                            'Authorize user',
                            style: GoogleFonts.quicksand(
                              color: Colors.red[500],
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
