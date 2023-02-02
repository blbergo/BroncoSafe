import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CodeBlue {
  static List<LatLng> BLUE_LIGHT_POS = [
    const LatLng(34.05765900983837, -117.82195196143006)
  ];

  static List<DirectionsWaypoint> convertToDirections() {
    List<DirectionsWaypoint> waypoints = [];

    BLUE_LIGHT_POS.forEach((element) {
      waypoints.add(DirectionsWaypoint(
          location:"34.05765900983837,-117.82195196143006",
          stopover: true));

      
    });
    return waypoints;
  }
}
