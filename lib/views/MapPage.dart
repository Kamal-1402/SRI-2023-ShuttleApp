import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
// import 'package:flutter_map/src/layer/tile_layer.dart';

class AppConstants {
  static const String mapBoxAccessToken =
      // 'pk.eyJ1IjoiaXNvYmVsMzVyYW10bzM1IiwiYSI6ImNsaWhiOTN2ZDBpcG0zanA1c3VxZDdkNjMifQ.CV3WZC4Jh9mzyz-XbpRm7A';
      'pk.eyJ1IjoiaXNvYmVsMzVyYW10bzM1IiwiYSI6ImNsaWhiOTN2ZDBpcG0zanA1c3VxZDdkNjMifQ.CV3WZC4Jh9mzyz-XbpRm7A';

  static const String mapBoxStyleId = 'mapbox.satellite';

  static final myLocation = LatLng(51.5090214, -0.1982948);
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
  // final mapState = FlutterMapState.of(_MapPageState)
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        minZoom: 5,
        maxZoom: 18,
        zoom: 13,
        center: AppConstants.myLocation,
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://api.mapbox.com/styles/v1/isobel35ramto35/clik2cxj500al01qpe9j20u93/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiaXNvYmVsMzVyYW10bzM1IiwiYSI6ImNsaWhiOTN2ZDBpcG0zanA1c3VxZDdkNjMifQ.CV3WZC4Jh9mzyz-XbpRm7A",
          additionalOptions: const {
            'mapStyleId': AppConstants.mapBoxStyleId,
            'accessToken': AppConstants.mapBoxAccessToken,
          },
          userAgentPackageName: 'com.example.learn_flutter',
        ),
      ],
    );
  }
}
