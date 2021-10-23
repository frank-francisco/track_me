import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewLocationPage extends StatefulWidget {
  final double latitudes;
  final double longitudes;
  ViewLocationPage({this.latitudes, this.longitudes});

  @override
  _ViewLocationPageState createState() =>
      _ViewLocationPageState(latitudes: latitudes, longitudes: longitudes);
}

class _ViewLocationPageState extends State<ViewLocationPage> {
  double latitudes;
  double longitudes;
  _ViewLocationPageState({this.latitudes, this.longitudes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3aa792),
        title: Text(
          'View location',
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
      body: GoogleMap(
        mapType: MapType.hybrid,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        myLocationEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        initialCameraPosition:
            CameraPosition(target: LatLng(latitudes, longitudes), zoom: 18),
        onMapCreated: (GoogleMapController controller) {
          //_controller.complete(controller);
        },
      ),
    );
  }
}
