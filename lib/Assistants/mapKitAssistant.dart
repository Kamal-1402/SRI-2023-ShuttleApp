import 'package:maps_toolkit/maps_toolkit.dart';

class MapKitAssistant
{
  static num getMarkerRotation(slat,sLng,dlat,dLng)
  {
    var rot =SphericalUtil.computeHeading(LatLng(slat,sLng), LatLng(dlat,dLng));
    return rot;
  }
}