import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/providers/location.dart';
import 'package:tiutiu/utils/constantes.dart';

class NewMap extends StatefulWidget {
  @override
  _NewMapState createState() => _NewMapState();
}

class _NewMapState extends State<NewMap> with SingleTickerProviderStateMixin {
  AnimationController controllerAnimation;

  @override
  void initState() {
    super.initState();
    controllerAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      reverseDuration: Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<Location>(context, listen: false);

    return PlacePicker(
      pinBuilder: (context, state) {
        print(
            '${locationProvider.location.latitude}, ${locationProvider.location.longitude}');
        return Image.asset('assets/new-pin2.png', width: 150, height: 150);
      },
      autoCompleteDebounceInMilliseconds: 1000,
      autocompleteLanguage: 'pt-BR',
      automaticallyImplyAppBarLeading: false,
      autocompleteOnTrailingWhitespace: true,
      apiKey: Constantes.WEB_API_KEY,
      selectedPlaceWidgetBuilder:
          (context, PickResult result, state, isSearchBarFocused) {
        if (isSearchBarFocused) {
          return Container();
        } else {
          if (state != SearchingState.Searching) {
            locationProvider.setLocation(
              currentLocation: LatLng(
                result.geometry.location.lat,
                result.geometry.location.lng,
              ),
            );
          }
          return FloatingCard(
            bottomPosition: 70.0,
            leftPosition: 0.0,
            rightPosition: 0.0,
            width: 500,
            borderRadius: BorderRadius.circular(12.0),
            child: state == SearchingState.Searching
                ? Center(
                    child: LoadingBumpingLine.circle(
                      size: 30,
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  )
                : CardTextLocation(result.formattedAddress),
          );
        }
      },
      initialPosition: LatLng(locationProvider.location.latitude,
          locationProvider.location.longitude),
      useCurrentLocation: true,
      selectInitialPosition: true,
    );
  }
}

class CardTextLocation extends StatelessWidget {
  CardTextLocation(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(color: Colors.black),
        ),
      ),
    );
  }
}
