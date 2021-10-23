import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:valuhworld/OnlyCompanyPages/AddCompanyPage.dart';
import 'package:valuhworld/OnlyCompanyPages/SetupCompanyAccount.dart';

class CompanyValidationPage extends StatefulWidget {
  @override
  _CompanyValidationPageState createState() => _CompanyValidationPageState();
}

class _CompanyValidationPageState extends State<CompanyValidationPage> {
  final _formKey = GlobalKey<FormState>();
  String _cui;
  bool _loading = false;
  bool _error = false;
  bool _resultVisibility = false;
  String _errorMessage = '';

  //Company data
  String _name = '';
  String _registrationCode = '';
  String _companyAdress = '';
  String _companyCity = '';
  String _businessAdress = '';
  String _phoneNumber = '';
  String _fiscalCode = '';

  getData() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.black87,
        ),
        actions: [
          IconButton(
            color: Colors.black87,
            icon: Icon(Icons.add_box_outlined),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => AddCompanyPage(),
                ),
              );
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(),
              ),
              Image.asset(
                "assets/images/verify_bg.png",
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ],
          ),
          LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return Container(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 100,
                              //color: Colors.red,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Container(),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Image.asset(
                                      "assets/images/search_mongers.png",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Enter your host name',
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: .5,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              maxLength: 10,
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                  fontSize: 18.0,
                                  letterSpacing: .5,
                                ),
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Company Reg. No',
                                helperText: 'Enter the company Reg. No',
                                prefixIcon: Icon(
                                  FontAwesomeIcons.penSquare,
                                ),
                                contentPadding: const EdgeInsets.all(15.0),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                errorStyle: GoogleFonts.quicksand(
                                  textStyle: TextStyle(
                                    letterSpacing: .5,
                                    color: Colors.brown,
                                  ),
                                ),
                              ),
                              onChanged: (val) {
                                setState(() => _cui = val);
                              },
                              validator: (val) =>
                                  val.length < 4 || val.length > 10
                                      ? ('Enter a valid Reg. No')
                                      : null,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            _loading
                                ? Container(
                                    decoration: new BoxDecoration(
                                      color: Color(0xff3aa792),
                                      borderRadius: new BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                    width: double.infinity,
                                    height: 48.0,
                                    child: Center(
                                      child: SpinKitThreeBounce(
                                        color: Colors.white,
                                        size: 20.0,
                                      ),
                                    ),
                                  )
                                : ButtonTheme(
                                    height: 48.0,
                                    child: FlatButton(
                                      color: Color(0xff3aa792),
                                      child: Text(
                                        'Search',
                                        style: GoogleFonts.quicksand(
                                          textStyle: TextStyle(
                                            fontSize: 18.0,
                                            letterSpacing: .5,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      shape: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xff3aa792),
                                          width: 2,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      onPressed: () async {
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                        if (_formKey.currentState.validate()) {
                                          getData();
                                          setState(() {
                                            _loading = true;
                                            _resultVisibility = false;
                                            _error = false;
                                          });
                                        } else {
                                          final snackBar = SnackBar(
                                            content: Text(
                                              'Please fill in all the fields!',
                                              textAlign: TextAlign.center,
                                            ),
                                          );
                                          Scaffold.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      },
                                    ),
                                  ),
                            SizedBox(
                              height: 20,
                            ),
                            Visibility(
                              visible: _resultVisibility,
                              child: _error
                                  ? Container(
                                      color: Colors.grey[200],
                                      width: double.infinity,
                                      padding: EdgeInsets.all(8.0),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.error_outline,
                                                  size: 24,
                                                  color: Colors.black87,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          _errorMessage,
                                                          style: GoogleFonts
                                                              .quicksand(
                                                            textStyle:
                                                                TextStyle(
                                                              fontSize: 14.0,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 6,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      color: Colors.grey[200],
                                      width: double.infinity,
                                      padding: EdgeInsets.all(8.0),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Company details',
                                                  style: GoogleFonts.quicksand(
                                                    textStyle: TextStyle(
                                                      fontSize: 18.0,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Icon(
                                                  FontAwesomeIcons.building,
                                                  size: 16,
                                                  //color: Colors.blue,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          _name,
                                                          style: GoogleFonts
                                                              .quicksand(
                                                            textStyle:
                                                                TextStyle(
                                                              fontSize: 14.0,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 6,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Icon(
                                                  FontAwesomeIcons.mapMarkerAlt,
                                                  size: 16,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          _companyCity,
                                                          style: GoogleFonts
                                                              .quicksand(
                                                            textStyle:
                                                                TextStyle(
                                                              fontSize: 14.0,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 6,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Icon(
                                                  FontAwesomeIcons.file,
                                                  size: 16,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          _registrationCode,
                                                          style: GoogleFonts
                                                              .quicksand(
                                                            textStyle:
                                                                TextStyle(
                                                              fontSize: 14.0,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 6,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Icon(
                                                  FontAwesomeIcons.phoneAlt,
                                                  size: 16,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          _phoneNumber,
                                                          style: GoogleFonts
                                                              .quicksand(
                                                            textStyle:
                                                                TextStyle(
                                                              fontSize: 14.0,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 6,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                TextButton(
                                                  child: Text(
                                                    'Continue',
                                                  ),
                                                  onPressed: () {
                                                    // Navigator.push(
                                                    //   context,
                                                    //   CupertinoPageRoute(
                                                    //     builder: (_) =>
                                                    //         SetupCompanyAccount(
                                                    //       companyName: _name,
                                                    //       companyCity:
                                                    //           _companyCity,
                                                    //       registrationCode:
                                                    //           _registrationCode,
                                                    //       phone: _phoneNumber,
                                                    //       fiscalCode:
                                                    //           _fiscalCode,
                                                    //     ),
                                                    //   ),
                                                    // );
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
