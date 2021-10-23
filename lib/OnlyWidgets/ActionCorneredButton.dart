import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

actionCorneredButton(
  String txt,
  String img,
) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          CachedNetworkImage(
            height: 70,
            width: 70,
            imageUrl: img,
          ),
          Expanded(
            child: Container(),
          ),
          Text(
            txt,
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    ),
  );
}
