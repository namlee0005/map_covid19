import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:covid19_map/api.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  final MyLocaiton myLocaiton = new MyLocaiton();

  @override
  void initState() {
    super.initState();
    getMyLocation().then((value) => setState(() {
          this.myLocaiton.lat = value.latitude;
          this.myLocaiton.long = value.longitude;
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (myLocaiton.lat != null) {
      return Scaffold(
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: setLocation(myLocaiton),
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        )
      );
    } else {
      return Scaffold();
    }
  }
}

CameraPosition setLocation(MyLocaiton myLocaiton) {
  CameraPosition kLake =
      CameraPosition(target: LatLng(myLocaiton.lat, myLocaiton.long), zoom: 15);
  return kLake;
}

Future<LocationData> getMyLocation() async {
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return null;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  _locationData = await location.getLocation();
  return _locationData;
}
