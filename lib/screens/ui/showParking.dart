import 'package:flutter/material.dart';
import '../../Widgets/header.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowParking extends StatefulWidget {


  @override
  _ShowParkingState createState() => _ShowParkingState();
  // String titleText;
  // LatLng parkingCoords; 


    // getParkingDetails(String title, LatLng parkingLocation) {
      
    //   titleText = title;
    //   parkingCoords = parkingLocation;

    // }
}

class _ShowParkingState extends State<ShowParking> {
  List<int> _selectedSlots = [];
  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText:"Parking Names" ),
      body: Container(
          child: Column(children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Container(
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 5,
            children: List.generate(20, (index) {
              return GestureDetector(
                onTap: (){
                  _selectedSlots.clear();

                  setState(() {
                    _selectedSlots.add(index);
                  });
                  
                },

                 child: Container(
                  margin: const EdgeInsets.all(5),
                  color: _selectedSlots.contains(index)? Colors.blue : Colors.grey[300],
                  child: Center(
                    child: Text(
                      'Slot ${index + 1}',
                      style: Theme.of(context).textTheme.headline,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(height: 20),
        RaisedButton(
            child: Text(
              "Get Directions",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            color: Colors.blue,
            onPressed: () {
              // _getPolylinesWithLocation(parkingLocation);
            }),
      ])),
    );
  }
}
