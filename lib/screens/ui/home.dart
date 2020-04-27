import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:new_parking_app/screens/SideNav/menu.dart';

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
  Set<Marker> _markers = {};
  // List <LatLng> routeCoords;
  int _polylineCount = 1;
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};
  GoogleMapPolyline _googleMapPolyline =
      new GoogleMapPolyline(apiKey: "AIzaSyC1N_DmXtxP9DPr_qVJ-vqSgO8JqyjuCiw");

  //Polyline patterns
  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[], //line
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)], //dash
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)], //dot
    <PatternItem>[
      //dash-dot
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
  ];

  LatLng _mapInitLocation = LatLng(6.4204138, 80.0049826);

  LatLng _originLocation;
  
  LatLng _destinationLocation;
  
  LatLng parking1 = LatLng(6.434959, 79.997053);

  LatLng parking2 = LatLng(6.353738, 80.113079);

  _getPolylinesWithLocation(LatLng parkingLocation) async {
    _destinationLocation = parkingLocation;
    List<LatLng> _coordinates =
        await _googleMapPolyline.getCoordinatesWithLocation(
            origin: _originLocation,
            destination: _destinationLocation,
            mode: RouteMode.driving);

    setState(() {
      _polylines.clear();
    });
    _addPolyline(_coordinates);
  }

  _addPolyline(List<LatLng> _coordinates) {
    PolylineId id = PolylineId("poly$_polylineCount");
    Polyline polyline = Polyline(
        polylineId: id,
        patterns: patterns[0],
        color: Colors.blueAccent,
        points: _coordinates,
        width: 5,
        onTap: () {});

    setState(() {
      _polylines[id] = polyline;
      _polylineCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    getCurrentLocation();

    return Scaffold(
      appBar: AppBar(
        title: Text("Parking Mobile"),
        centerTitle: true,
      ),
      drawer: new Drawer(
        child: ListView(children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white)),
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.black87,
                  Color.fromARGB(255, 3, 27, 47).withOpacity(0.8),
                ],
              ),
            ),
            accountName: new Text('Raja'),
            accountEmail: new Text('testemail@test.com'),
            currentAccountPicture: new CircleAvatar(
              backgroundImage: new NetworkImage('http://i.pravatar.cc/300'),
            ),
          ),
          CustomListTile(Icons.calendar_today, 'Parking List', () => {print("parking list should here")}),
          CustomListTile(Icons.info, 'About Us', () => {print("About us page here")}),
          CustomListTile(Icons.help, 'Help', () => {print("help page here")}),
          CustomListTile(Icons.settings, 'Settings', () => {print("settings Page here")}),
          CustomListTile(Icons.input, 'Logout', () => {print("Logout function")})
        ]),
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition:
            CameraPosition(target: _mapInitLocation, zoom: 15.00),
        // initialCameraPosition:
        // CameraPosition(target: LatLng(6.4204138, 80.0049826), zoom: 15.00),
        polylines: Set<Polyline>.of(_polylines.values),
        markers: _markers,
        // markers: Set.of([marker, parking1Marker, parking2Marker]),
        // markers: Set.of([parking1Marker, parking2Marker]),

        circles: Set.of((circle != null) ? [circle] : []),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          setState(() {
            // _markers.add(Marker(
            //     markerId: MarkerId('Marker1'),
            //     position: LatLng(6.4204138, 80.0049826),
            //     icon: BitmapDescriptor.defaultMarkerWithHue(
            //         BitmapDescriptor.hueRed),
            //     onTap: () {
            //       _showModalBottomSheet();
            //     }));

            // Markers for the parking places
            Marker parking1Marker = Marker(
              markerId: MarkerId('Parking No.1'),
              position: parking1,
              onTap: () {
                _destinationLocation = parking1;
               String btmSheetTitle = 'Parking No.1';
                _showModalBottomSheet(btmSheetTitle, parking1);
              },
              infoWindow: InfoWindow(title: 'Public Park'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
            );

            Marker parking2Marker = Marker(
              markerId: MarkerId('Parking No.2'),
              position: parking2,
              onTap: () {
                _destinationLocation = parking2;
                String btmSheetTitle = 'Parking No.2';
                _showModalBottomSheet(btmSheetTitle, parking2);
              },
              infoWindow: InfoWindow(title: 'Beach Park'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
            );
            _markers.add(parking1Marker);
            _markers.add(parking2Marker);
          });
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _getPolylinesWithLocation,
      //   child: Icon(Icons.map),
      // ),
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
                  zoom: 14)));
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
      _originLocation = latlng;


      Marker myLocation = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          onTap: () {
            print("Tapped on my position");
          },
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

      _markers.add(myLocation);
    });
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

   _showModalBottomSheet(String title, LatLng parkingLocation) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
            height: 150,
            child: Column(children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text(title,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  )),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                  child: Text(
                    "Get Directions",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.blue,
                  onPressed: (){
                    _getPolylinesWithLocation(parkingLocation);
                  }),
            ])));
  }
}

// Widget bottomSheet(BuildContext context) {
//   return Container(
//       child: Column(children: <Widget>[
//     ListTile(
//       leading: Icon(Icons.email),
//       title: Text("Emails"),
//       onTap: () {
//         print("object");
//       },
//     )
//   ]));
// }
