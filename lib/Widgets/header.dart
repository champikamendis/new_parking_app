import 'package:flutter/material.dart';

AppBar header(BuildContext context,
    {bool isAppTitle = false, String titleText}) {
  return AppBar(
    backgroundColor: Colors.lightBlue,
    leading: IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    title: Text(
      isAppTitle ? 'Enter your title' : titleText,
      style: TextStyle(fontSize: 20.0, color: Colors.white),
    ),
  );
} // TODO Implement this library.
