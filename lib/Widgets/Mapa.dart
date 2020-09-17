import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/Widgets/auto_complete_search.dart';
import 'package:tiutiu/Widgets/badge.dart';
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
  final List<String> placesFound = [];
  final Completer<GoogleMapController> _controller = Completer();
  Position userCurrentLocation;
  static LatLng _center;
  LatLng lastMapPosition;
  CameraPosition initialCameraPosition;
  LatLng pinPosition;
  MapType _currentMapType = MapType.normal;
  GoogleMapController _mapController;
  bool isSearching = false;

  final geocoding = GoogleMapsGeocoding(
    apiKey: Constantes.WEB_API_KEY,
  );

  final places = GoogleMapsPlaces(
    apiKey: Constantes.WEB_API_KEY,
  );

  Future<String> coordsToAddress(LatLng coords) async {
    final location = Location(coords.latitude, coords.longitude);
    final response = await geocoding.searchByLocation(location);
    final address = GeocodingModel.fromSnapshot(response.results[0]).toMap();

    return Future.value(address['formattedAddress']);
  }

  Future<Location> addressToCoords(String address) async {
    final response = await geocoding.searchByAddress(address);
    final coords = response.results[0].geometry.viewport.northeast;

    _setCurrentLocation(location: coords);

    return Future.value(coords);
  }

  Future<void> _moveCamera() {
    setState(() {});
    _mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _center, zoom: 14.4746),
      ),
    );
    _addMarkeOnMap(_center);
    return Future.value();
  }

  @override
  void setState(fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();

    _setCurrentLocation();

    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/pin-dog.jpg',
    ).then((onValue) {
      pinLocationIcon = onValue;
    });

    setCustomMapPin();
  }

  Map petLocalInfo = {};
  bool viewLocalPopUp = false;

  void onPetLocalInfo(infoWindow) {
    setState(() {
      petLocalInfo['title'] = infoWindow['title'];
      petLocalInfo['info'] = infoWindow['info'];
      viewLocalPopUp = !viewLocalPopUp;
    });
  }

  void _setCurrentLocation({Location location}) async {
    if (location == null) {
      var position = LatLng(16.7453989,-49.2740054);
      // var position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        // userCurrentLocation = position;
        _center = LatLng(position.latitude, position.longitude);
      });
    } else {
      setState(() {
        userCurrentLocation =
            Position(latitude: location.lat, longitude: location.lng);
        _center = LatLng(location.lat, location.lng);
      });
    }
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/pin-dog.jpg',
    );
  }

  Future<void> _addMarkeOnMap(LatLng postitionToAdd,
      [String name, String dogPhoto]) async {
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
        var infoWindow = {
          'title': 'Localização',
          'info': localFormattedAddress
        };
        onPetLocalInfo(infoWindow);
        viewLocalPopUp = true;
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    final locationProvider = Provider.of<provider_location.Location>(context, listen: false);
    _addMarkeOnMap(_center);
    setState(() {
      _mapController = controller;
      if (!_controller.isCompleted) {
        _controller.complete(controller);
      }
      locationProvider.setLocation(currentLocation: _center);
    });
  }

  void _onCameraMove(CameraPosition position) async {
    setState(() {
      lastMapPosition = position.target;
    });
    await _addMarkeOnMap(lastMapPosition);
  }

  Future<void> searchAutocomplete(String value) async {
    var res = await places.autocomplete(value);

    if (res.isOkay) {
      // list autocomplete prediction

      setState(() {
        placesFound.clear();
        for (var p in res.predictions) {
          placesFound.add(p.description);
          print('- ${p.description}');
        }
      });

      // get detail of the first result
      var details =
          await places.getDetailsByPlaceId(res.predictions.first.placeId);

      print('\nDetails :');
      print(details.result.formattedAddress);
      print(details.result.geometry.viewport.northeast);
      print(details.result.formattedPhoneNumber);
      print(details.result.url);
    } else {
      print(res.errorMessage);
    }
  }

  void setMapType() {
    if (_currentMapType == MapType.satellite) {
      setState(() {
        _currentMapType = MapType.normal;
      });
    } else {
      setState(() {
        _currentMapType = MapType.satellite;
      });
    }
  }

  void setIsSearchingStatus(bool status) {
    setState(() {
      isSearching = status;
    });
  }

  void onAutoCompleteClose() {
    setIsSearchingStatus(false);
  }

  @override
  void dispose() {
    super.dispose();
    places.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget mapa;
    if(_center == null) {
      mapa = Center(
        child: CircularProgressIndicator(),
      );
    } else {
      mapa = GoogleMap(
        markers: _markers,
        mapType: _currentMapType,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 14.4746,
        ),
        onMapCreated: _onMapCreated,
        zoomGesturesEnabled: true,

        zoomControlsEnabled: false,
        onCameraMove: _onCameraMove,
        myLocationEnabled: true,
        compassEnabled: false,
        myLocationButtonEnabled: true,
      );
    }

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
              decoration: BoxDecoration(
                  border: Border.all(
                      style: BorderStyle.solid,
                      color: Theme.of(context).accentColor)),
              child: Stack(
                children: <Widget>[
                  mapa,
                  Positioned(
                    bottom: 120,
                    right: 17,
                    child: Badge(callback: setMapType, icon: Icons.map),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 2,
                    left: 2,
                    child: isSearching
                        ? AutoCompleteSearch(
                            onAutoCompleteClose: onAutoCompleteClose,
                            autoCompleteCallback: searchAutocomplete,
                            placesList: placesFound,
                            onLocalSelected: (String value) {
                              setIsSearchingStatus(false);
                              addressToCoords(value).then(
                                (value) async {
                                  await _moveCamera();
                                },
                              );
                            },
                          )
//                        : SizedBox()
                        : _PopUpInfo(
                            info: petLocalInfo['info'] ?? '',
                            callback: () => setIsSearchingStatus(true),
                          ),
                  )
                ],
              ),
            ),
    );
  }
}

class _PopUpInfo extends StatelessWidget {
  _PopUpInfo({this.info = 'Carregando localização...', this.callback});

  final info;
  final Function() callback;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Stack(
      children: <Widget>[
        Container(
          height: 95,
          width: width - 10,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/pata.jpg'),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        info,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 10,
          bottom: 45,
          child: Badge(
            icon: Icons.edit,
            callback: callback,
          ),
        )
      ],
    );
  }
}
