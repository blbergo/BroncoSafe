import 'dart:async';

import 'package:bronco_safe/secrets.dart';
import 'package:bronco_safe/userPos.dart';
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
  List<String> destinations = ["Disneyland", "Yorba Linda", "Anaheim"];

  //TODO: add a state variable to represent destination;

  late GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bronco Map")),
      body: FutureBuilder(
        future: userPos.determinePositionAsLatLng(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition:
                  CameraPosition(target: snapshot.data, zoom: 19),
              polylines: geo_routes,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
            );
          } else {
            return const Text("Map Error");
          }
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

  void getDirections() async {
    print("init");

    //init google directions api
    DirectionsService.init(Secrets.GOOGLE_MAPS_API_KEY);
    final ds = DirectionsService();

    //sub the origin out for user current location
    //add waypoints
    final request = DirectionsRequest(
        origin: await userPos.determinePositionAsString(),
        destination: destinations[0],
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
            polylineId: PolylineId('1'), points: points, color: Colors.green));

        setState(() {});
      });

       
    });

    _controller.animateCamera(CameraUpdate.newLatLngZoom(
        await userPos.determinePositionAsLatLng(), 19));
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
