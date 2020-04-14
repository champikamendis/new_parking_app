import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../menu/menu.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    getCurrentLocation();

    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
            icon: new Icon(Icons.local_parking),
            onPressed: () => debugPrint("Tapped logo")),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Menu.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
        title: Text("Parking Mobile"),
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition:
            CameraPosition(target: LatLng(6.25, 80.21), zoom: 15.00),
        markers: Set.of([marker, parking1Marker, parking2Marker]),
        circles: Set.of((circle != null) ? [circle] : []),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => debugPrint("Tapped on flotbtn"),
        child: Icon(Icons.map),
      ),
    );
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged().listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.833491395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 19.5)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });
    } catch (error) {
      if (error.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/car_icon.png");

    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);

    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }
}

// Markers for the parking places
Marker parking1Marker = Marker(
  markerId: MarkerId('Parking1'),
  position: LatLng(6.4204138, 80.0049826),
  infoWindow: InfoWindow(title: 'Public Park'),
  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
);

Marker parking2Marker = Marker(
  markerId: MarkerId('Parking2'),
  position: LatLng(6.421276, 79.9999034),
  infoWindow: InfoWindow(title: 'Beach Park'),
  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
);

void choiceAction(String choice) {
  if (choice == Menu.listView) {
    print("Selected LIST");
  } else if (choice == Menu.logout) {
    print("Selected LOGOUT");
  } else if (choice == Menu.quit) {
    print("Selected QUIT");
  }
}
