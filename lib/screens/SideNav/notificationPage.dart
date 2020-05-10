import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Widgets/header.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: 'Notifications'),
      body: ListView(
        
      ),

       
    );
  }
}


  
