import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/providers/location.dart' as provider_location;
import 'package:tiutiu/utils/constantes.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:tiutiu/backend/Model/geocoding_model.dart';

class Mapa extends StatefulWidget {
  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  BitmapDescriptor pinLocationIcon;
  final Set<Marker> _markers = {};
  final Completer<GoogleMapController> _controller = Completer();
  Position userCurrentLocation;
  static LatLng _center;
  LatLng lastMapPosition;
  CameraPosition initialCameraPosition;
  LatLng pinPosition;
  final MapType _currentMapType = MapType.normal;

  final geocoding = GoogleMapsGeocoding(
    apiKey: Constantes.WEB_API_KEY,
  );

  Future<String> coordsToAddress(LatLng coords) async {
    final location = Location(coords.latitude, coords.longitude);
    final response = await geocoding.searchByLocation(location);
    final address = GeocodingModel.fromSnapshot(response.results[0]).toMap();

    return Future.value(address['formattedAddress']);
  }

  @override
  void setState(fn) {
    if (!mounted) return;
    super.setState(fn);
  }

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
  bool viewLocalPopUp = false;

  void onViewDog(infoWindow) {
    setState(() {
      viewDogInfo['title'] = infoWindow['title'];
      viewDogInfo['info'] = infoWindow['info'];
      viewLocalPopUp = !viewLocalPopUp;
    });
  }

  void _currentLocation() async {
    var position = await Geolocator()
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

  Future<void> _addMarkeOnMap(LatLng postitionToAdd, [String name, String dogPhoto]) async {
    final localFormattedAddress = await coordsToAddress(postitionToAdd);
    setState(
      () {
        _markers.clear();
        _markers.add(
          Marker(
            onTap: () {},
            markerId: MarkerId(postitionToAdd.toString()),
            position: postitionToAdd,
            icon: pinLocationIcon,
          ),
        );              
        var infoWindow = {'title': 'Localização', 'info': localFormattedAddress};
        onViewDog(infoWindow);
        viewLocalPopUp = true;
      },
    );
  }

  void _onCameraMove(CameraPosition position) async {    
    lastMapPosition = position.target;
    await _addMarkeOnMap(lastMapPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _center == null
          ? Container(
              child: Center(
                child: Text(
                  'carregando...',
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
                            LatLng(_center.latitude,
                                _center.longitude),
                          );
                          final locationProvider =
                              Provider.of<provider_location.Location>(context,
                                  listen: false);
                          locationProvider.setLocation(_center);
                        },
                      );
                    },
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    onCameraMove: _onCameraMove,
                    myLocationEnabled: true,
                    compassEnabled: false,
                    myLocationButtonEnabled: false,
                  ),
                  viewLocalPopUp
                      ? Positioned(
                          bottom: 10,
                          child: Container(
                            width: MediaQuery.of(context).size.width - 10,
                            child: FittedBox(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                                color: Colors.black,
                                                style: BorderStyle.solid,
                                                width: 1)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset('assets/pata.jpg'),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            viewDogInfo['title'].toString(),
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          FittedBox(
                                            child: Text(
                                              '${viewDogInfo['info']}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // SizedBox(width: 10),
                                      // IconButton(
                                      //   icon: Icon(Icons.remove_red_eye),
                                      //   onPressed: () {},
                                      // )
                                    ],
                                  ),
                                ),
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
