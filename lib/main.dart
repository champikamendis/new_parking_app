import 'package:flutter/material.dart';
import 'package:new_parking_app/screens/authenticate/login.dart';
import 'package:new_parking_app/screens/ui/home.dart';
import 'package:new_parking_app/screens/ui/test2.dart';
import './screens/authenticate/register.dart';
import 'package:new_parking_app/services/auth.dart';
import 'package:provider/provider.dart';
import './wrapper.dart';
import 'models/user.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value:AuthService().user,
          child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ParkMobile',
        theme: ThemeData(
          primarySwatch: Colors.blue, 
        ),
        home: Register(),
      ),
    );
  }
}






