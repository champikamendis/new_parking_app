import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:new_parking_app/screens/SideNav/about_us.dart';
import 'package:new_parking_app/screens/SideNav/menu.dart';
import 'package:new_parking_app/screens/SideNav/notificationPage.dart';
import 'package:new_parking_app/screens/SideNav/parkingPlaces.dart';
import 'package:new_parking_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AuthService _auth = AuthService();
  // ShowParking showParking = ShowParking();

  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
  Set<Marker> _markers = {};
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

  LatLng parking1;

  LatLng parking2;
  MapType setMap;
  int counter = 0;

  MapType map_type = MapType.normal;

  int _count = 0;

  String currentUserFirstName;

  String currentUserLastName;

  String currentUserEmail;

  String currentUserImage;

  dynamic currentUserData;

  List<int> _selectedSlots = [];

  Future<dynamic> getData() async {
    String userID = (await FirebaseAuth.instance.currentUser()).uid;

    final DocumentReference document =
        Firestore.instance.collection("users").document(userID);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        currentUserData = snapshot.data;
        currentUserFirstName = currentUserData['firstName'];
        currentUserLastName = currentUserData['lastName'];
        currentUserEmail = currentUserData['email'];
        currentUserImage = currentUserData['profilePicture'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    print(currentUserData);
  }

  getProfileImage() {
    FirebaseAuth.instance.currentUser().then((user) {
      Firestore.instance.collection('prof_pic/').where('field');
    });
  }

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
              accountName: new Text(currentUserFirstName),
              accountEmail: new Text(currentUserEmail),
              currentAccountPicture: new CircleAvatar(
                backgroundImage:
                    new NetworkImage('https://picsum.photos/250?image=9'),
              ),
            ),
            CustomListTile(
                Icons.calendar_today,
                'Parking List',
                () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ParkingPlaces()))
                    }),
            CustomListTile(
                Icons.notifications,
                'Notifications',
                () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationPage()))
                    }),
            CustomListTile(
                Icons.info,
                'About Us',
                () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AboutPage()))
                    }),
            CustomListTile(Icons.input, 'Logout', () async {
              await _auth.logOut();
            })
          ]),
        ),
        body: StreamBuilder(
            stream: Firestore.instance.collection('Parkings').snapshots(),
            builder: (context, snapshot) {
              return GoogleMap(
                mapType: map_type,
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
                initialCameraPosition:
                    CameraPosition(target: _mapInitLocation, zoom: 15.00),
                polylines: Set<Polyline>.of(_polylines.values),
                markers: _markers,
                circles: Set.of((circle != null) ? [circle] : []),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                  setState(() {
                    double lat1 = snapshot.data.documents[0]['coords'].latitude;
                    double lon1 =
                        snapshot.data.documents[0]['coords'].longitude;

                    parking1 = LatLng(lat1, lon1);

                    double lat2 = snapshot.data.documents[1]['coords'].latitude;
                    double lon2 =
                        snapshot.data.documents[1]['coords'].longitude;

                    parking2 = LatLng(lat2, lon2);

                    // Markers for the parking places
                    Marker parking1Marker = Marker(
                      markerId: MarkerId('Parking No.1'),
                      position: parking1,
                      onTap: () {
                        _destinationLocation = parking1;
                        String btmSheetTitle = 'Parking No.1';
                        _showModalBottomSheet(btmSheetTitle, parking1);
                      },
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
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue),
                    );
                    _markers.add(parking1Marker);
                    _markers.add(parking2Marker);
                  });
                },
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _count = _count + 1;
            setMapType(_count);
          },
          child: Icon(
            Icons.map,
          ),
          backgroundColor: Colors.blue,
        ));
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
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              
                child: Column(children: <Widget>[
                   SizedBox(
                height: 20,
              ),
                  Container(
                    child: Text("$title",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight:FontWeight.w700
                    ),
                    
                    ),),
              SizedBox(
                height: 20,
              ),

              Container(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 5,
                  children: List.generate(20, (index) {
                    return GestureDetector(
                      onTap: () {
                        _selectedSlots.clear();

                        setState(() {
                          _selectedSlots.add(index);
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        color: _selectedSlots.contains(index)
                            ? Colors.blue
                            : Colors.grey[300],
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
                    _getPolylinesWithLocation(parkingLocation);
                  }),
            ]));
          });
        });
  }

  setMapType(int count) {
    if (count % 2 != 0) {
      print(count);
      setState(() {
        map_type = MapType.hybrid;
      });
    } else {
      setState(() {
        map_type = MapType.normal;
      });
    }
  }
}
