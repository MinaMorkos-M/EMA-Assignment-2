import 'dart:async';

import 'package:ema_ass2/models/api_keys.dart';
import 'package:ema_ass2/models/location_helper.dart';
import 'package:ema_ass2/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class AddToFav extends StatefulWidget {
  const AddToFav({Key? key}) : super(key: key);

  @override
  State<AddToFav> createState() => _AddToFavState();
}

class _AddToFavState extends State<AddToFav> {
  static Position? position;
  List<Place>? places;
  StreamSubscription? subscription;
  Future<List<Place>> getPlaces(double lat, double lng) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?location=$lat,$lng&type=store&rankby=distance&key=${ApiKeys.googleMaps}';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    return jsonResults.map((place) => Place.fromJson(place)).toList();
  }

  getCurrentLocation() async {
    try {
      position = await LocationHelper.getCurrentLocation().whenComplete(() {
        setState(() {});
      });

      if (subscription != null) {
        subscription!.cancel();
      }
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  getStores() async {
    places = await getPlaces(position!.latitude, position!.longitude);
    setState(() {});
  }

  @override
  void initState() {
    getCurrentLocation();
    getStores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('add to favorites'),
      ),
      body: (position != null && places != null)
          ? ListView.builder(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Divider(),
                    ListTile(
                      title: Text(
                        places![index].name.toString(),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.favorite),
                        onPressed: () {
                          // name = places![index].name.toString(),
                          // lat = places[index].geometry!.location!.lat!
                          // lng = places[i].geometry!.location!.lng!,
                        },
                      ),
                    ),
                    Divider(),
                  ],
                );
              },
              itemCount: places!.length,
            )
          : Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
    );
  }
}
