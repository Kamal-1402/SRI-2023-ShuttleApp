// // // make basic map usi using map constructor using mapbox gl
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map/plugin_api.dart';
// import 'package:mapbox_gl/mapbox_gl.dart' as Mapbox;
// // import 'package:latlong2/latlong.dart';
// import 'package:geolocator/geolocator.dart';
// // import assets
// // import 'package:learn_flutter/assets/map_styles/Streets.json';


// class AppConstants {
//   static const String mapBoxAccessToken =
//       'pk.eyJ1IjoiaXNvYmVsMzVyYW10bzM1IiwiYSI6ImNsaWhiOTN2ZDBpcG0zanA1c3VxZDdkNjMifQ.CV3WZC4Jh9mzyz-XbpRm7A';

//   static const String mapBoxStyleId = 'mapbox.satellite';
// }
// // // in this page we will search for location and then we will get the lat and long of that location and then we will show that location on the map

// class MapBase extends StatefulWidget {
//   @override
//   _MapBaseState createState() => _MapBaseState();
// }

// // input destination location and source location

// class _MapBaseState extends State<MapBase> {
//   Position? currentLocation;
//   String sourceLocation = '';
//   String destinationLocation = '';

//   late MapController _mapController;
//   // assign lat and long to latlng



//   // LatLng latLng = LatLng(0, 0);
//   // String searchAddr;
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentPosition();
//     _mapController = MapController();
//   }
//   @override
//   void dispose() {
//     _mapController.dispose();
//     super.dispose();
//   }

//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw Exception('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Exception('Location permissions are denied.');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       throw Exception('Location permissions are permanently denied.');
//     }

//     // When we reach here, permissions are granted, and we can
//     // continue accessing the position of the device.
//     return await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//       // forceAndroidLocationManager: true
//     );
//   }

//   void _onMapCreated(Mapbox.MapboxMapController controller) {
//     mapboxMapController = controller;
//   }

//   void _updateSourceLocation(String value) {
//     setState(() {
//       sourceLocation = value;
//     });
//   }

//   void _updateDestinationLocation(String value) {
//     setState(() {
//       destinationLocation = value;
//     });
//   }

//   // void _showOnMap() {
//   //   if (_sourceLatLng != null && _destinationLatLng != null) {
//   //     mapboxMapController.addSymbol(SymbolOptions(
//   //       geometry: _sourceLatLng!,
//   //       iconImage: 'assets/driving_pin.png',
//   //       iconSize: 1.5,
//   //       draggable: false,
//   //     ));
//   //     final bounds = LatLngBounds().extend(_sourceLatLng!).extend(_destinationLatLng!)
//   //     )
//   //   }
//   // }

//   void _getCurrentPosition() async {
//     try {
//       Position position = await _determinePosition();
//       // dev.log(
//       // 'My location is ${position.latitude} ${position.longitude} get current position');
//       setState(() {
//         currentLocation = position;
//       });
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Map Base'),
//       ),
//       body: Mapbox.MapboxMap(
//         accessToken: AppConstants.mapBoxAccessToken,
//         styleString: AppConstants.mapBoxStyleId,

//         onMapCreated: _onMapCreated,
//         initialCameraPosition: Mapbox.CameraPosition(
//           target: Mapbox.LatLng(currentLocation!.latitude, currentLocation!.longitude),
//           zoom: 11.0,
//         ),
//         children: [
          
//           urlTemplate:
//           "https://api.mapbox.com/search/searchbox/v1/suggest?q={query}&access_token=${AppConstants.mapBoxAccessToken}",
//         ]
//       ),
//     );
//   }
// }





// // // Widget build(BuildContext context) {
// // //   return Scaffold(
// // //     appBar: AppBar(
// // //       title: Text('Map Page'),
// // //     ),
// // //     body: Column(
// // //       children: [
// // //         TextField(
// // //           onChanged: _updateSourceLocation,
// // //           decoration: InputDecoration(labelText: 'Source Location'),
// // //         ),
// // //         TextField(
// // //           onChanged: _updateDestinationLocation,
// // //           decoration: InputDecoration(labelText: 'Destination Location'),
// // //         ),
// // //         ElevatedButton(
// // //           onPressed: _showOnMap,
// // //           child: Text('Show on Map'),
// // //         ),
// // //         Expanded(
// // //           child: MapboxMap(
// // //             onMapCreated: _onMapCreated,
// // //             initialCameraPosition: CameraPosition(
// // //               target: LatLng(0.0, 0.0),
// // //               zoom: 10.0,
// // //             ),
// // //             accessToken: 'YOUR_MAPBOX_ACCESS_TOKEN',
// // //             styleString: MapboxStyles.LIGHT,
// // //             trackCameraPosition: false,
// // //             onMapClick: (point, latLng) {
// // //               if (_sourceLatLng == null) {
// // //                 setState(() {
// // //                   _sourceLatLng = latLng;
// // //                 });
// // //               } else if (_destinationLatLng == null) {
// // //                 setState(() {
// // //                   _destinationLatLng = latLng;
// // //                 });
// // //               }
// // //             },
// // //             annotations: [
// // //               if (_sourceLatLng != null)
// // //                 MarkerAnnotation(
// // //                   marker: Marker(
// // //                     markerId: MarkerId('source'),
// // //                     position: _sourceLatLng!,
// // //                   ),
// // //                 ),
// // //               if (_destinationLatLng != null)
// // //                 MarkerAnnotation(
// // //                   marker: Marker(
// // //                     markerId: MarkerId('destination'),
// // //                     position: _destinationLatLng!,
// // //                   ),
// // //                 ),
// // //             ],
// // //           ),
// // //         ),
// // //       ],
// // //     ),
// // //   );
// // // }


// // // // same for the destination location also




// // // // we will use mapbox gl for this purpose
// // // // than we will show path between these two locations
