import 'dart:async';

import 'package:bronco_safe/map/code_blue.dart';
import 'package:bronco_safe/secrets.dart';
import 'package:bronco_safe/map/userPos.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Set<Polyline> geo_routes = {};
  List<String> destinations = ["Cal Poly Pomona Parking Lot C, Pomona, CA 91768"];

  //TODO: add a state variable to represent destination;

  late GoogleMapController _controller;

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bronco Map")),
      body: FutureBuilder(
        future: userPos.determinePositionAsLatLng(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            //set a marker for current user pos
            markers.add(
                Marker(markerId: MarkerId('userPos'), position: snapshot.data));

            markers.add(
                Marker(markerId: MarkerId('testMarker'), position: CodeBlue.BLUE_LIGHT_POS[0]));
            return GoogleMap(
              markers: markers,
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
    //add waypoints

    final request = DirectionsRequest(
        origin: await userPos.determinePositionAsString(),
        destination: destinations[0],
        waypoints: CodeBlue.convertToDirections(),
        optimizeWaypoints: true,
        travelMode: TravelMode.walking);

    ds.route(request,
        (DirectionsResult response, DirectionsStatus? status) async {
      final routes = response.routes?.toList();
      print(routes!.length);

      List<LatLng> points = [await userPos.determinePositionAsLatLng()];

      markers.add(Marker(
          markerId: const MarkerId('destination'),
          position: points[points.length - 1]));
      geo_routes.add(Polyline(
          polylineId: PolylineId('route'),
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          color: Colors.green,
          points: await converToLatLng(
              decodePolyline(routes![0].overviewPolyline!.points.toString()))));

      setState(() {});
    });

    //move camera to starting position
    _controller.animateCamera(CameraUpdate.newLatLngZoom(
        await userPos.determinePositionAsLatLng(), 19));
  }

  /// Function for converting a polyline string to LatLng coords
  Future<List<LatLng>> converToLatLng(List<List<num>> overview) async {
    List<LatLng> points = [];

    points.add(await userPos.determinePositionAsLatLng());

    overview.forEach((element) {
      points.add(LatLng(element[0].toDouble(), element[1].toDouble()));
    });

    return points;
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
