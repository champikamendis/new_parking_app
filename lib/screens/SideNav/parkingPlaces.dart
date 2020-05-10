import 'package:flutter/material.dart';
import '../../Widgets/header.dart';

class ParkingPlaces extends StatefulWidget {
  ParkingPlaces({Key key}) : super(key: key);

  @override
  _ParkingPlacesState createState() => _ParkingPlacesState();
}

class _ParkingPlacesState extends State<ParkingPlaces> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Parking Places"),
       body: DefaultTabController(
         length: 3,
         child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(height: 50),
              child: TabBar(
                labelColor: Colors.black,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold
                ),
                tabs: [
                Tab(text: "All"),
                Tab(text: "Available Places"),
                Tab(text: "Full Places")
              ]),
            ),
            Expanded(
              child: Container(
                child: TabBarView(children: [
                  Container(
                    child: Text("All Body"),
                  ),
                  Container(
                    child: Text("Completed Body"),
                  ),
                  Container(
                    child: Text("Cancelled Body"),
                  ),
                ]),
              ),
            )
          ],
        ),
       ),
    );
  }
}