import 'dart:math';

import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CodeBlue {
  static List<LatLng> BLUE_LIGHT_POS = [
    const LatLng(34.05765900983837, -117.82195196143006),
    const LatLng(34.05983738817185, -117.81640052389413),
    const LatLng(34.06067894406512, -117.81504981928316),
    const LatLng(34.060208976554584, -117.81808675031046),
    const LatLng(34.05463305231139, -117.81598658077762),
    const LatLng(34.05292337845148, -117.81564833778764),
    const LatLng(34.05474797628565, -117.81758206275191),
    const LatLng(34.05721866996159, -117.82592680842689)
  ];

  static List<DirectionsWaypoint> convertToDirections(
      LatLng origin, LatLng destination) {
    List<DirectionsWaypoint> waypoints = [];

    BLUE_LIGHT_POS.forEach((element) {
      if (withinBounds(element, origin, destination)) {
        waypoints.add(DirectionsWaypoint(
          location:
              element.latitude.toString() + "," + element.longitude.toString(),
        ));
      }
    });
    return waypoints;
  }

  static bool withinBounds(LatLng element, LatLng origin, LatLng destination) {
    //calculate 'box' with a small amount of leeway
    //long - y
    //lat - x
    double x = element.latitude;
    double y = element.longitude;

    double x1 = origin.latitude;
    double y1 = origin.longitude;

    double x2 = destination.latitude;
    double y2 = destination.longitude;

    //element x,y p
    //origin x1,y1 a
    //corner1 x1, y2 b
    //destination x2, y2 d
    //corner2 x2, y1 c

    double rectArea = (x2 - x1).abs() * (y2 - y1).abs();
    double apd = _calcTri(_calcDistance(x1, y1, x, y),
        _calcDistance(x, y, x2, y2), _calcDistance(x2, y2, x1, y1));

    double dpc = _calcTri(_calcDistance(x2, y2, x, y),
        _calcDistance(x, y, x2, y1), _calcDistance(x2, y1, x2, y2));

    double cpb = _calcTri(_calcDistance(x2, y1, x, y),
        _calcDistance(x, y, x1, y2), _calcDistance(x1, y2, x2, y1));
    double pba = _calcTri(_calcDistance(x, y, x1, y2),
        _calcDistance(x1, y2, x1, y1), _calcDistance(x1, y1, x, y));

    double total = dpc + apd + cpb + pba;

    print("Difference:" + (rectArea - total).toString());

    if (rectArea - total > 0) {
      return true;
    }

    return false;
  }

  static double _calcDistance(double x1, double y1, double x2, double y2) {
    return sqrt(pow((x2 - x1), 2) + pow((y2 - y1), 2));
  }

  static double _calcTri(double a, double b, double c) {
    double s = (a + b + c) / 2;
    return sqrt(s * (s - a) * (s - b) * (s - c));
  }

  static List<Marker> testMarkers(LatLng origin, LatLng destination) {
    //double x = element.latitude;
    //double y = element.longitude;

    double x1 = origin.latitude;
    double y1 = origin.longitude;

    double x2 = destination.latitude;
    double y2 = destination.longitude;

    //element x,y
    //origin x1,y1
    //corner1 x1, y2
    //destination x2, y2
    //corner2 x2, y1

    Marker c1 = Marker(
        position: LatLng(x1, y2),
        markerId: MarkerId('c1'),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta));
    Marker c2 = Marker(
        position: LatLng(x2, y1),
        markerId: MarkerId('c2'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan));

    return [c1, c2];
  }
}
