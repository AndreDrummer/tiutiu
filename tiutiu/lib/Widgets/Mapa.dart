import 'dart:async';
import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Mapa extends StatefulWidget {
  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();  
  Position userCurrentLocation =
      Position(latitude: 37.4219983, longitude: -122.084);
  CameraPosition initialCamera;
  LatLng lastMapPosition;
  LatLng pinPosition = LatLng(37.3797536, -122.1017334);
  MapType _currentMapType;  

  @override
  void initState() {
    _currentLocation();

    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/pin-dog.jpg',
    ).then((onValue) {
      pinLocationIcon = onValue;
    });

    setCustomMapPin();

    initialCamera = CameraPosition(
      target: LatLng(
        userCurrentLocation.latitude,
        userCurrentLocation.longitude,
      ),
      zoom: 15,
    );

    super.initState();
  }

  Future _currentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userCurrentLocation = position;
    });
    _currentMapType = MapType.normal;
    print("POSIÇÃO ATUAL: $userCurrentLocation");
    return position;
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/pin-dog.jpg',
    );
  }

  void _addMarkeOnMap(LatLng postitionToAdd, [String name, String dogPhoto]) {
    setState(
      () {
        _markers.add(
          Marker(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: Text(name),
                      content: Row(
                        children: <Widget>[
                          CircleAvatar(
                            child: Image.network(dogPhoto),
                            radius: 20,
                            backgroundColor: Colors.transparent,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text("$postitionToAdd"),
                          )
                        ],
                      ));
                },
              );
            },
            markerId: MarkerId(postitionToAdd.toString()),
            position: postitionToAdd,
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
    print(_markers.length);
    return Scaffold(
        body: GoogleMap(
      mapToolbarEnabled: false,
      markers: _markers,
      mapType: _currentMapType,
      initialCameraPosition: initialCamera,
      onCameraMove: _onCameraMove,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        setState(
          () {
            _markers.add(
              Marker(
                markerId: MarkerId('‘<MARKER_ID>’'),
                position: LatLng(userCurrentLocation.latitude,
                    userCurrentLocation.longitude),
                icon: pinLocationIcon,
              ),
            );
          },
        );
      },
    ));
  }
}
