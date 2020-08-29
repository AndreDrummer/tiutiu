import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_webservice/distance.dart' as distanceMatrix;
import 'package:provider/provider.dart';
import 'package:tiutiu/providers/location.dart' as provider_location;
import 'package:tiutiu/utils/constantes.dart';

class CardList extends StatefulWidget {
  CardList({this.petInfo, this.donate = true});

  final petInfo;
  final bool donate;

  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {

  Future calculateDistance(double latitude, double longitude) async {
    provider_location.Location currentLoction = Provider.of(context, listen: false);
    final distance = distanceMatrix.GoogleDistanceMatrix(apiKey: Constantes.WEB_API_KEY);    

    var origins = [
      distanceMatrix.Location(currentLoction.location.latitude, currentLoction.location.longitude),      
    ];
    var destinations = [      
      distanceMatrix.Location(latitude, longitude),
    ];

    var responseForLocation = await distance.distanceWithLocation(
      origins,
      destinations,
    );    

    if (responseForLocation.isOkay) {
      print(responseForLocation.destinationAddress.length);
      for (var row in responseForLocation.results) {
        for (var element in row.elements) {
          return ['${element.distance.text}', '${element.duration.text}'];
        }
      }
    } else {
      print('ERROR: ${responseForLocation.errorMessage}');
    }   
}


  @override
  Widget build(BuildContext context) {      
calculateDistance(widget.petInfo.toMap()['latitude'], widget.petInfo.toMap()['longitude']);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: FutureBuilder(
        future: calculateDistance(widget.petInfo.toMap()['latitude'], widget.petInfo.toMap()['longitude']),
        builder: (_, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        return Card(
        // color: Colors.white70,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    style: BorderStyle.solid,
                    color: Colors.blueGrey[50],
                  ),
                ),
                margin: const EdgeInsets.all(8.0),
                child: ClipOval(
                  child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.transparent,
                      child: FadeInImage(
                        placeholder: AssetImage('assets/logo.png'),
                        image: NetworkImage(widget.petInfo.toMap()['avatar']),
                        height: 1000,
                        width: 1000,
                        fit: BoxFit.fitWidth,
                      )

                      // Image.asset(
                      //   'assets/pelo.jfif',
                      //   height: 1000,
                      //   fit: BoxFit.fitHeight,
                      // ),
                      ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.petInfo.toMap()['name'],
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
                  Text(widget.petInfo.toMap()['breed']),
                  SizedBox(height: 20),
                  SizedBox(
                    // width: MediaQuery.of(context).size.width * 0.525,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${widget.petInfo.toMap()['ownerName']} está ${widget.donate ? 'doando' : 'procurando'}.',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7.0),
                          child: Row(
                            children: [
                              Text(
                                'Está a ${snapshot.data[0]}, ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 2),
                              Text(
                                '${snapshot.data[1]} daqui',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      })
    );
  }
}
