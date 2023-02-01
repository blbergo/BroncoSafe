import 'dart:async';

import 'package:bronco_safe/secrets.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_directions_api/google_directions_api.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Set<Polyline> geo_routes = {};

  //TODO: add a state variable to represent destination;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  //TODO: update this to cal poly's location
   static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(34.0555994, -117.8214517),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bronco Map")),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        polylines: geo_routes,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: getDirections,
        label: const Text('Get Directions'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  //code for checking permission, will be moved to when the user first logs
  //in in the future
  Future<LatLng> _determinePositionAsLatLng() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position pos = await Geolocator.getCurrentPosition();

    return LatLng(pos.latitude, pos.longitude);
  }

  void getDirections() async {
    print("init");

    //init google directions api
    DirectionsService.init(Secrets.GOOGLE_MAPS_API_KEY);
    final ds = DirectionsService();

    //sub the origin out for user current location
    //add waypoints
    final request = DirectionsRequest(
        origin: await _determinePositionAsLatLng().toString(),
        destination: 'Yorba Linda',
        travelMode: TravelMode.walking);

    ds.route(request, (DirectionsResult response, DirectionsStatus? status) {
      final data = response.routes!
          .map((e) => e.legs!.map((e) => e.steps!.map((e) => e.startLocation)));

      List<LatLng> points = [];

      data.forEach((element) {
        element.forEach((element) {
          int index = 0;
          element.forEach((element) {
            index += 1;
            points.add(LatLng(element!.latitude, element.longitude));
          });
        });

        geo_routes.add(Polyline(
            polylineId: PolylineId('1'), points: points, color: Colors.blue));

        setState(() {});
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }
  /*
  Process:
  get user current location, if offline display blue lights on the map, allow
  the user to select where they want to go and then hard calculate the route
  fetch route data paired with waypoints (blue lights) if online
  draw routes on map
  walk the user through directions using map controller

  LATER: add live tracking status
  */
}
