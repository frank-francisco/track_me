import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

myPostsItem(
  String txt,
  String img,
) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
      child: Container(
        //decoration: BoxDecoration(color: Colors.grey[100]),
        decoration: BoxDecoration(
          //color: Colors.grey[100]),
          image: DecorationImage(
            image: NetworkImage(img),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
    ),
  );
}
