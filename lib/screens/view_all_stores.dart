import 'dart:async';
import 'package:ema_ass2/models/api_keys.dart';
import 'package:ema_ass2/models/location_helper.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:ema_ass2/models/place.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewAllStores extends StatefulWidget {
  const ViewAllStores({Key? key}) : super(key: key);

  @override
  State<ViewAllStores> createState() => _ViewAllStoresState();
}

class _ViewAllStoresState extends State<ViewAllStores> {
  static Position? position;
  bool showButton = false;
  Set<Marker> markers = {};
  Completer<GoogleMapController> _mapController = Completer();
  // ignore: cancel_subscriptions
  StreamSubscription? subscription;
  static CameraPosition _myCurrentlocationCameraPosition = CameraPosition(
    bearing: 0.0,
    target: LatLng(position!.latitude, position!.longitude),
    tilt: 0.0,
    zoom: 15,
  );

  Future<List<Place>> getPlaces(double lat, double lng) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?location=$lat,$lng&type=store&rankby=distance&key=${ApiKeys.googleMaps}';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    return jsonResults.map((place) => Place.fromJson(place)).toList();
  }

  Future<void> setMarkers(List<Place> places) async {
    final List<Place> places =
        await getPlaces(position!.latitude, position!.longitude);
    if (places.length > 0) {
      for (int i = 0; i < places.length; i++) {
        Marker marker = Marker(
          markerId: MarkerId('Store $i'),
          position: LatLng(
            places[i].geometry!.location!.lat!,
            places[i].geometry!.location!.lng!,
          ),
          flat: true,
          draggable: false,
          zIndex: 2,
        );
        setState(() {
          markers.add(marker);
        });
        setState(() {});
      }
    }
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
    final List<Place> places =
        await getPlaces(position!.latitude, position!.longitude);
    setState(() {
      setMarkers(places);
    });
  }

  @override
  initState() {
    super.initState();
    getCurrentLocation();
    getStores();
  }

  @override
  dispose() {
    super.dispose();
    subscription!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stores'),
      ),
      body: (position != null)
          ? GoogleMap(
              markers: markers,
              zoomControlsEnabled: true,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              initialCameraPosition: _myCurrentlocationCameraPosition,
              onMapCreated: (GoogleMapController mapController) {
                _mapController.complete(mapController);
              },
              onCameraMove: (position) {
                if (_myCurrentlocationCameraPosition == position &&
                    showButton == true) {
                  setState(() {
                    showButton = false;
                  });
                } else if (_myCurrentlocationCameraPosition != position &&
                    showButton == false) {
                  setState(() {
                    showButton = true;
                  });
                }
              },
            )
          : Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
    );
  }
}
