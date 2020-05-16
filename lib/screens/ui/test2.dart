import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Test2 extends StatefulWidget {
  @override
  _Test2State createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Test2'),
      ),

      body: StreamBuilder(
        stream: Firestore.instance.collection('Parkings').snapshots(),
        builder: (context, snapshot){
          if (!snapshot.hasData) return const Text('Loading...');
          return Stack(
            children: <Widget>[
              GoogleMap(
              initialCameraPosition:CameraPosition(
                target: LatLng(6.43333,79.99972),
                zoom:13.00)),

              Text(snapshot.data.documents[0]['coords'].latitude.toString()),
              
              // Text(snapshot.data.documents[0]['coords'].longitude.toString()),  
            ],
          );
     
        },
               ),  
          
      
    );
  }
}