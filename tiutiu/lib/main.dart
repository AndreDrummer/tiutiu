import 'dart:async';
import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(
      MaterialApp(
        home: Home(),
      ),
    );

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  LatLng _center;
  Position userCurrentLocation;
  LatLng lastMapPosition;
  LatLng pinPosition = LatLng(37.3797536, -122.1017334);
  MapType _currentMapType;

  @override
  void initState() {
    _currentLocation();
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/pata.jpg',
    ).then((onValue) {
      pinLocationIcon = onValue;
    });
    setCustomMapPin();
    super.initState();
  }

  Future _currentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentLocation = position;
    setState(() {
      // placeAround =
      //     LatLng(userCurrentLocation.latitude, userCurrentLocation.longitude);
    });
    _currentMapType = MapType.normal;
    print("POSIÇÃO ATUAL: $userCurrentLocation");
    return position;
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/pata.jpg',
    );
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.4219983, -122.084),
    zoom: 15,
  );

  static final CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.4219983, -122.084),
    tilt: 59.440717697143555,
    zoom: 16,
  );

  void _addMarkeOnMap(postitionToAdd) {
    setState(
      () {
        _markers.add(
          Marker(
            markerId: MarkerId(postitionToAdd.toString()),
            position: postitionToAdd,
            infoWindow: InfoWindow(title: 'Ola, funcionou!!'),
            icon: pinLocationIcon,
          ),
        );
      },
    );
  }

  void _onCameraMove(CameraPosition position) async {
    lastMapPosition = position.target;
    _markers.clear();
    _addMarkeOnMap(lastMapPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter !"),
      ),
      body: Center(
        child: Container(
          child: GoogleMap(
            markers: _markers,
            mapType: MapType.normal,
            onTap: (latLng) {
              print(latLng);
              setState(() {
                _markers.add(
                  Marker(
                    markerId: MarkerId(latLng.toString()),
                    position: latLng,
                    infoWindow: InfoWindow(title: 'Ola, funcionou!!'),
                    icon: pinLocationIcon,
                  ),
                );
              });
            },
            initialCameraPosition: _kGooglePlex,
            onCameraMove: _onCameraMove,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              setState(
                () {
                  _markers.add(
                    Marker(
                      markerId: MarkerId('‘<MARKER_ID>’'),
                      position: LatLng(37.4219983, -122.084),
                      icon: pinLocationIcon,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
