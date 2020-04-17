import 'package:flutter/material.dart';
import 'package:new_parking_app/screens/authenticate/login.dart';
import 'package:new_parking_app/screens/ui/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parking Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue, 
      ),
      home: MyHomePage(),
    );
  }
}
