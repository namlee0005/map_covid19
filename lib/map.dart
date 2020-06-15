import 'dart:collection';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:covid19_map/api.dart';
import 'dart:ui' as ui;
import 'api.dart';


class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = HashSet<Marker>();
  final MyLocaiton myLocaiton = new MyLocaiton();

  void _onMapCreated(Completer<GoogleMapController> controller) async {
    _controller = controller;
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/danger.png', 100);
    BitmapDescriptor pinLocationIcon = BitmapDescriptor.fromBytes(markerIcon);

    List<CovidInfo> lists = new List();
    lists.add(new CovidInfo("BN-1", "Xuân Lôi ,Vĩnh Phúc", 21.38475, 105.4594));
    lists.add(
        new CovidInfo("BN-2", "125 Trúc bạch ,Hà Nội", 21.04515, 105.84189));
    lists.add(new CovidInfo("BN-3", "Ba Đình, Hà Nội", 21.04254, 105.84469));
    lists.add(new CovidInfo("BN-4", "Cầu Giấy, Hà Nội", 21.03265, 105.79854));
    lists.add(new CovidInfo("BN-5", "TP.Phan thiết. Bình thuận", 10.81619, 106.65765));
    lists.add(new CovidInfo("BN-10", "Sân bay Nội bài", 21.217666, 105.799009));
    lists.add(new CovidInfo("BN-29", "Hạ Lôi, Mê Linh, HN", 21.156908, 105.725791));
    lists.add(new CovidInfo("BN-43", "KDT Tiền phong, Mê linh, HN", 21.146859, 105.762347));
    lists.add(new CovidInfo("BN-15", "Sân bay Nội bài", 21.21784, 105.797962));
    lists.add(new CovidInfo("BN-2", "125 Trúc bạch ,Hà Nội", 21.04515, 105.84189));

    for (CovidInfo covidInfo in lists) {
      setState(() {
        _markers.add(Marker(
            markerId: MarkerId(covidInfo.name),
            position: LatLng(covidInfo.lat, covidInfo.long),
            icon: pinLocationIcon,
            infoWindow: InfoWindow(
              title: covidInfo.name,
              snippet: covidInfo.address,
            )));
      });
    }
  }

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
          appBar: AppBar(
            title: new Text("Map")
          ),
          body: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: setLocation(myLocaiton),
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _onMapCreated(_controller);
            },
            markers: _markers,
            
      ));
    } else {
      return Scaffold();
    }
  }
}

CameraPosition setLocation(MyLocaiton myLocaiton) {
  CameraPosition kLake =
      CameraPosition(target: LatLng(myLocaiton.lat, myLocaiton.long), zoom: 12);
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

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
      .buffer
      .asUint8List();
}
