import 'dart:async';
import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/providers/location.dart';

class Mapa extends StatefulWidget {
  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  Position userCurrentLocation;
  static LatLng _center;
  LatLng lastMapPosition;
  CameraPosition initialCameraPosition;
  LatLng pinPosition;
  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    super.initState();

    _currentLocation();

    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/pin-dog.jpg',
    ).then((onValue) {
      pinLocationIcon = onValue;
    });

    setCustomMapPin();
  }

  Map viewDogInfo = {};
  bool viewingDog = false;
  onViewDog(algo) {
    setState(() {
      viewDogInfo['name'] = algo['name'];
      viewDogInfo['breed'] = algo['breed'];
      viewDogInfo['size'] = algo['size'];
      viewingDog = !viewingDog;
    });
  }

  void _currentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      userCurrentLocation = position;
      _center = LatLng(position.latitude, position.longitude);
    });
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
              Map teste = {
                'name': "Dogão",
                'breed': 'Bravo',
                'size': 'Grandão'
              };
              onViewDog(teste);
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
    return Scaffold(
      body: _center == null
          ? Container(
              child: Center(
                child: Text(
                  'loading map..',
                  style: TextStyle(
                      fontFamily: 'Avenir-Medium', color: Colors.grey[400]),
                ),
              ),
            )
          : Container(
              child: Stack(
                children: <Widget>[
                  GoogleMap(
                    markers: _markers,
                    mapType: _currentMapType,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 14.4746,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      setState(
                        () {
                          _controller.complete(controller);
                          _addMarkeOnMap(
                            LatLng(userCurrentLocation.latitude,
                                userCurrentLocation.longitude),
                          );
                          final locationProvider =
                              Provider.of<Location>(context, listen: false);
                          locationProvider.setLocation(_center);
                        },
                      );
                    },
                    zoomGesturesEnabled: true,
                    onCameraMove: _onCameraMove,
                    myLocationEnabled: true,
                    compassEnabled: true,
                    myLocationButtonEnabled: false,
                  ),
                  viewingDog
                      ? Positioned(
                          bottom: 10,
                          child: Card(
                            margin: const EdgeInsets.symmetric(horizontal: 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  CircleAvatar(
                                    child: Image.asset('assets/pata.jpg'),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        viewDogInfo['name'].toString(),
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                        '${viewDogInfo['breed']} ° ${viewDogInfo['size']}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10),
                                  IconButton(
                                    icon: Icon(Icons.remove_red_eye),
                                    onPressed: () {},
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : SizedBox()
                ],
              ),
            ),
    );
  }
}
