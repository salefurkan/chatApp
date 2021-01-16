import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Image.asset(
      "assets/images/appBar.jpeg",
      width: double.infinity,
    ),
    backgroundColor: Colors.black87,
    shadowColor: Colors.transparent,
  );
}

InputDecoration textFieldInputDecoration(String hintText, {String labelText}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.white54),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white54),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white54),
    ),
  );
}

TextStyle simpleTextFieldStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 16,
  );
}

TextStyle mediumTextFieldStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 14,
  );
}
