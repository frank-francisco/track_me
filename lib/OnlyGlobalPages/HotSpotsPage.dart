import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HotSpotsPage extends StatefulWidget {
  @override
  _HotSpotsPageState createState() => _HotSpotsPageState();
}

class _HotSpotsPageState extends State<HotSpotsPage> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3aa792),
        title: Text(
          'Hotspot',
          style: GoogleFonts.quicksand(
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
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 48,
              ),
              Icon(
                Icons.privacy_tip_outlined,
                color: Colors.black38,
                size: 42,
              ),
              SizedBox(
                height: 48,
              ),
              Text(
                'No hot spots detected',
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
                'There are no hotspots in your location to display.',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    letterSpacing: .5,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
