import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:tiutiu/providers/location.dart';
import 'package:tiutiu/utils/constantes.dart';

class NewMap extends StatefulWidget {
  @override
  _NewMapState createState() => _NewMapState();
}

class _NewMapState extends State<NewMap> with SingleTickerProviderStateMixin {
  Location? locationProvider;

  @override
  void didChangeDependencies() {
    locationProvider = Provider.of<Location>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
          'Tem que arrumar um meio de selecionar local no mapa... antes era place picker'),
    );
  }

  @override
  void dispose() {
    super.dispose();
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
              .headline1!
              .copyWith(color: Colors.black),
        ),
      ),
    );
  }
}
