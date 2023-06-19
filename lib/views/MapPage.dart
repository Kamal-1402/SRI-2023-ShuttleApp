// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:flutter_map/plugin_api.dart';
// // import 'package:flutter_map/src/layer/tile_layer.dart';

// class AppConstants {
//   static const String mapBoxAccessToken =
//       // 'pk.eyJ1IjoiaXNvYmVsMzVyYW10bzM1IiwiYSI6ImNsaWhiOTN2ZDBpcG0zanA1c3VxZDdkNjMifQ.CV3WZC4Jh9mzyz-XbpRm7A';
//       'pk.eyJ1IjoiaXNvYmVsMzVyYW10bzM1IiwiYSI6ImNsaWhiOTN2ZDBpcG0zanA1c3VxZDdkNjMifQ.CV3WZC4Jh9mzyz-XbpRm7A';

//   static const String mapBoxStyleId = 'mapbox.satellite';

//   static final myLocation = LatLng(51.5090214, -0.1982948);
// }

// class MapPage extends StatefulWidget {
//   const MapPage({super.key});

//   @override
//   State<MapPage> createState() => _MapPageState();
//   // final mapState = FlutterMapState.of(_MapPageState)
// }

// class _MapPageState extends State<MapPage> {
//   @override
//   Widget build(BuildContext context) {
//     return FlutterMap(
//       options: MapOptions(
//         minZoom: 5,
//         maxZoom: 18,
//         zoom: 13,
//         center: AppConstants.myLocation,
//       ),
//       children: [
//         TileLayer(
//           urlTemplate:
//               "https://api.mapbox.com/styles/v1/isobel35ramto35/clik2cxj500al01qpe9j20u93/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiaXNvYmVsMzVyYW10bzM1IiwiYSI6ImNsaWhiOTN2ZDBpcG0zanA1c3VxZDdkNjMifQ.CV3WZC4Jh9mzyz-XbpRm7A",
//           additionalOptions: const {
//             'mapStyleId': AppConstants.mapBoxStyleId,
//             'accessToken': AppConstants.mapBoxAccessToken,
//           },
//           userAgentPackageName: 'com.example.learn_flutter',
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:flutter_map/plugin_api.dart';
// import 'package:geolocator/geolocator.dart' as geolocator;
// // import 'package:location/location.dart';
// import 'dart:developer' as dev show log;

// class AppConstants {
//   static const String mapBoxAccessToken =
//       'pk.eyJ1IjoiaXNvYmVsMzVyYW10bzM1IiwiYSI6ImNsaWhiOTN2ZDBpcG0zanA1c3VxZDdkNjMifQ.CV3WZC4Jh9mzyz-XbpRm7A';

//   static const String mapBoxStyleId = 'mapbox.satellite';
// }

// class MapPage extends StatefulWidget {
//   const MapPage({Key? key}) : super(key: key);

//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   geolocator.Position? _currentPosition;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentPosition();
//   }

//   Future<void> _getCurrentPosition() async {
//     try {
//       final position = await _determinePosition();
//       dev.log(
//           'My location is ${position.latitude} ${position.longitude} get current position');
//       setState(() {
//         _currentPosition = position;
//       });
//     } catch (e) {
//       dev.log('Error: $e');
//       setState(() {
//         _currentPosition = null;
//       });
//     }
//   }

//   Future<geolocator.Position> _determinePosition() async {
//     bool serviceEnabled;
//     geolocator.LocationPermission permission;

//     // Test if location services are enabled.
//     serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw Exception('Location services are disabled.');
//     }

//     permission = await geolocator.Geolocator.checkPermission();
//     if (permission == geolocator.LocationPermission.denied) {
//       permission = await geolocator.Geolocator.requestPermission();
//       if (permission == geolocator.LocationPermission.denied) {
//         throw Exception('Location permissions are denied.');
//       }
//     }

//     if (permission == geolocator.LocationPermission.deniedForever) {
//       throw Exception('Location permissions are permanently denied.');
//     }

//     // When we reach here, permissions are granted, and we can
//     // continue accessing the position of the device.
//     return await geolocator.Geolocator.getCurrentPosition(
//         desiredAccuracy: geolocator.LocationAccuracy.high);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_currentPosition != null) {
//       dev.log(
//           'My location is ${_currentPosition!.latitude} ${_currentPosition!.longitude} _currentPosition');
//     }

//     return FlutterMap(
//       options: MapOptions(
//         minZoom: 5,
//         maxZoom: 18,
//         zoom: 13,
//         center: _currentPosition != null
//             ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
//             : const LatLng(51.5090214,-0.1982948), // Default location if current location is not available
//       ),
//       children: [
//         TileLayer(
//           urlTemplate:
//               "https://api.mapbox.com/styles/v1/isobel35ramto35/clik2cxj500al01qpe9j20u93/tiles/256/{z}/{x}/{y}@2x?access_token=${AppConstants.mapBoxAccessToken}",
//           additionalOptions: const {
//             'mapStyleId': AppConstants.mapBoxStyleId,
//           },
//           userAgentPackageName: 'com.example.learn_flutter',
//         ),
//         MarkerLayer(
//           markers: [
//             Marker(
//               width: 80.0,
//               height: 80.0,
//               point: _currentPosition != null
//                   ? LatLng(
//                       _currentPosition!.latitude, _currentPosition!.longitude)
//                   : const LatLng(51.5090214,
//                       -0.1982948), // Default location if current location is not available
//               builder: (ctx) => const Icon(
//                 Icons.location_on,
//                 color: Colors.red,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:flutter_map/plugin_api.dart';
// import 'package:geolocator/geolocator.dart' as geolocator;
// import 'dart:developer' as dev show log;

// class AppConstants {
//   static const String mapBoxAccessToken =
//       'pk.eyJ1IjoiaXNvYmVsMzVyYW10bzM1IiwiYSI6ImNsaWhiOTN2ZDBpcG0zanA1c3VxZDdkNjMifQ.CV3WZC4Jh9mzyz-XbpRm7A';

//   static const String mapBoxStyleId = 'mapbox.satellite';
// }

// class MapPage extends StatefulWidget {
//   const MapPage({Key? key}) : super(key: key);

//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   geolocator.Position? _currentPosition;
//   final MapController _mapController = MapController();

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentPosition();
//   }

//   Future<void> _getCurrentPosition() async {
//     try {
//       final position = await _determinePosition();
//       dev.log(
//           'My location is ${position.latitude} ${position.longitude} get current position');
//       setState(() {
//         _currentPosition = position;
//       });
//     } catch (e) {
//       dev.log('Error: $e');
//     }
//   }

//   Future<geolocator.Position> _determinePosition() async {
//     bool serviceEnabled;
//     geolocator.LocationPermission permission;

//     // Test if location services are enabled.
//     serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw Exception('Location services are disabled.');
//     }

//     permission = await geolocator.Geolocator.checkPermission();
//     if (permission == geolocator.LocationPermission.denied) {
//       permission = await geolocator.Geolocator.requestPermission();
//       if (permission == geolocator.LocationPermission.denied) {
//         throw Exception('Location permissions are denied.');
//       }
//     }

//     if (permission == geolocator.LocationPermission.deniedForever) {
//       throw Exception('Location permissions are permanently denied.');
//     }

//     // When we reach here, permissions are granted, and we can
//     // continue accessing the position of the device.
//     return await geolocator.Geolocator.getCurrentPosition(
//         desiredAccuracy: geolocator.LocationAccuracy.high);
//   }

//   void _zoomIn() {
//     _mapController.move(_mapController.center, _mapController.zoom + 1);
//   }

//   void _zoomOut() {
//     _mapController.move(_mapController.center, _mapController.zoom - 1);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_currentPosition != null) {
//       dev.log(
//           'My location is ${_currentPosition!.latitude} ${_currentPosition!.longitude} _currentPosition');
//     }

//     return Scaffold(
//       body: FlutterMap(
//         options: MapOptions(
//           minZoom: 5,
//           maxZoom: 18,
//           zoom: 6,
//           center: _currentPosition == null
//               ? const LatLng(34.968,89.956)//LatLng(20.60,78.05) // Default location if current location is not available
//               : LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
//           onPositionChanged: (position, hasGesture) {
//             // Update the center position when the map is moved
//             setState(() {
//               _currentPosition = geolocator.Position(
//                 latitude: position.center?.latitude ?? 0.0,
//                 longitude: position.center?.longitude ?? 0.0,
//                 timestamp:DateTime.now(),
//                 accuracy: 90,
//                 altitude: 1,
//                 heading: 6,
//                 speed: 4,
//                 speedAccuracy: 70,
//               );
//             });
//           },
//         ),
//         mapController: _mapController,
//         children: [
//           TileLayer(
//             urlTemplate:
//                 "https://api.mapbox.com/styles/v1/isobel35ramto35/clik2cxj500al01qpe9j20u93/tiles/256/{z}/{x}/{y}@2x?access_token=${AppConstants.mapBoxAccessToken}",
//             additionalOptions: const {
//               'mapStyleId': AppConstants.mapBoxStyleId,
//             },
//             userAgentPackageName: 'com.example.learn_flutter',
//           ),
//           MarkerLayer(
//             markers: [
//               Marker(
//                 width: 80.0,
//                 height: 80.0,
//                 point: _currentPosition != null
//                     ? LatLng(
//                         _currentPosition!.latitude, _currentPosition!.longitude)
//                     : const LatLng(51.5090214,
//                         -0.1982948), // Default location if current location is not available
//                 builder: (ctx) => const Icon(
//                   Icons.location_on,
//                   color: Colors.red,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),

//       floatingActionButton: Align(
//         alignment: Alignment.bottomLeft,

//         child: Padding(
//           padding: const EdgeInsets.all(50),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               FloatingActionButton(
//                 onPressed: _zoomIn,
//                 child: const Icon(Icons.add),
//               ),
//               const SizedBox(height: 8),
//               FloatingActionButton(
//                 onPressed: _zoomOut,
//                 child: const Icon(Icons.remove),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:flutter_map/plugin_api.dart';
// import 'package:geolocator/geolocator.dart' as geolocator;
// import 'dart:developer' as dev show log;

// class AppConstants {
//   static const String mapBoxAccessToken =
//       'pk.eyJ1IjoiaXNvYmVsMzVyYW10bzM1IiwiYSI6ImNsaWhiOTN2ZDBpcG0zanA1c3VxZDdkNjMifQ.CV3WZC4Jh9mzyz-XbpRm7A';

//   static const String mapBoxStyleId = 'mapbox.satellite';
// }

// class MapPage extends StatefulWidget {
//   const MapPage({Key? key}) : super(key: key);

//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   geolocator.Position? _currentPosition;
//   final MapController _mapController = MapController();

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentPosition();
//   }
//   @override
//   void dispose() {
//     super.dispose();
//   }
//   Future<geolocator.Position> _determinePosition() async {
//     bool serviceEnabled;
//     geolocator.LocationPermission permission;

//     // Test if location services are enabled.
//     serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw Exception('Location services are disabled.');
//     }

//     permission = await geolocator.Geolocator.checkPermission();
//     if (permission == geolocator.LocationPermission.denied) {
//       permission = await geolocator.Geolocator.requestPermission();
//       if (permission == geolocator.LocationPermission.denied) {
//         throw Exception('Location permissions are denied.');
//       }
//     }

//     if (permission == geolocator.LocationPermission.deniedForever) {
//       throw Exception('Location permissions are permanently denied.');
//     }

//     // When we reach here, permissions are granted, and we can
//     // continue accessing the position of the device.
//     return await geolocator.Geolocator.getCurrentPosition(
//         desiredAccuracy: geolocator.LocationAccuracy.high,
//         forceAndroidLocationManager: true
//         );
//   }

//   Future<void> _getCurrentPosition() async {
//     try {
//       final position = await _determinePosition();
//       dev.log(
//           'My location is ${position.latitude} ${position.longitude} get current position');
//       setState(() {
//         _currentPosition = position;
//       });
//     } catch (e) {
//       dev.log('Error: $e');
//     }
//   }

//   void _zoomIn() {
//     _mapController.move(_mapController.center, _mapController.zoom + 1);
//   }

//   void _zoomOut() {
//     _mapController.move(_mapController.center, _mapController.zoom - 1);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_currentPosition != null) {
//       dev.log(
//           'My location is ${_currentPosition!.latitude} ${_currentPosition!.longitude} _currentPosition');
//     }
//     // Future.delayed(const Duration(seconds: 2));
//     return Scaffold(
//       body: FlutterMap(
//         options: MapOptions(
//           minZoom: 5,
//           maxZoom: 18,
//           zoom: 6,
//           center: _currentPosition != null
//               ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
//               : const LatLng(34.968,
//                   89.956), //LatLng(20.60,78.05) // Default location if current location is not available
//           onPositionChanged: (position, hasGesture) {
//             // Update the center position when the map is moved
//             setState(() {
//               _currentPosition = geolocator.Position(
//                 latitude: position.center?.latitude ?? 0.0,
//                 longitude: position.center?.longitude ?? 0.0,
//                 timestamp: DateTime.now(),
//                 accuracy: 90,
//                 altitude: 1,
//                 heading: 6,
//                 speed: 4,
//                 speedAccuracy: 70,
//               );
//             });
//           },
//         ),
//         mapController: _mapController,
//         children: [
//           TileLayer(
//             urlTemplate:
//                 "https://api.mapbox.com/styles/v1/isobel35ramto35/clik2cxj500al01qpe9j20u93/tiles/256/{z}/{x}/{y}@2x?access_token=${AppConstants.mapBoxAccessToken}",
//             additionalOptions: const {
//               'mapStyleId': AppConstants.mapBoxStyleId,
//             },
//             userAgentPackageName: 'com.example.learn_flutter',
//           ),
//           MarkerLayer(
//             markers: [
//               Marker(
//                 width: 80.0,
//                 height: 80.0,
//                 point: _currentPosition != null
//                     ? LatLng(
//                         _currentPosition!.latitude, _currentPosition!.longitude)
//                     : const LatLng(51.5090214,
//                         -0.1982948), // Default location if current location is not available
//                 builder: (ctx) => const Icon(
//                   Icons.location_on,
//                   color: Colors.red,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       floatingActionButton: Align(
//         alignment: Alignment.bottomLeft,
//         child: Padding(
//           padding: const EdgeInsets.all(50),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               FloatingActionButton(
//                 onPressed: _zoomIn,
//                 child: const Icon(Icons.add),
//               ),
//               const SizedBox(height: 8),
//               FloatingActionButton(
//                 onPressed: _zoomOut,
//                 child: const Icon(Icons.remove),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// // import 'package:latlong2/latlong.dart';
// // import 'package:latlng/latlng.dart';
// import 'package:flutter_map/plugin_api.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:async';
// import 'dart:developer' as dev show log;

// import 'package:mapbox_gl/mapbox_gl.dart';

// class AppConstants {
//   static const String mapBoxAccessToken =
//       'pk.eyJ1IjoiaXNvYmVsMzVyYW10bzM1IiwiYSI6ImNsaWhiOTN2ZDBpcG0zanA1c3VxZDdkNjMifQ.CV3WZC4Jh9mzyz-XbpRm7A';

//   static const String mapBoxStyleId = 'mapbox.satellite';
//   // static const String mapBoxStyleId = 'https://api.mapbox.com/styles/v1/isobel35ramto35/clik2cxj500al01qpe9j20u93/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiaXNvYmVsMzVyYW10bzM1IiwiYSI6ImNsaWhiOTN2ZDBpcG0zanA1c3VxZDdkNjMifQ.CV3WZC4Jh9mzyz-XbpRm7A';
// }

// class MapPage extends StatefulWidget {
//   const MapPage({Key? key}) : super(key: key);

//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   Position? _currentPosition;
//   final MapController _mapController = MapController();
//   bool _isDefaultLocation = false;
//   late StreamSubscription<Position> _positionStreamSubscription;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentPosition();
//     _determinePosition();
//     _acquireCurrentPosition();
//   }

//   @override
//   void dispose() {
//     // _positionStreamSubscription.cancel();
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

//   _getCurrentPosition() async {
//     try {
//       // _positionStreamSubscription =
//       //     geolocator.Geolocator.getPositionStream().listen((position) {
//       //   setState(() {
//       //     _currentPosition = position;
//       //     _isDefaultLocation = false;
//       //   });
//       // });
//       Position position = await _determinePosition();
//       dev.log(
//           'My location is ${position.latitude} ${position.longitude} get current position');
//       setState(() {
//         _currentPosition = position;
//       });
//     } catch (e) {
//       setState(() {
//         _isDefaultLocation = true;
//       });
//     }
//   }

//   void _zoomIn() {
//     if (mounted) {
//       _mapController.move(_mapController.center, _mapController.zoom + 1);
//     }
//   }

//   void _zoomOut() {
//     if (mounted) {
//       _mapController.move(_mapController.center, _mapController.zoom - 1);
//     }
//   }

//   Future<Position> _acquireCurrentPosition() async {
//     Position position = await _determinePosition();
//     return position;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder(
//         future: _acquireCurrentPosition(),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           return snapshot.hasData
//               ? MapboxMap(
//                   accessToken: AppConstants.mapBoxAccessToken,
//                   // styleString: AppConstants.mapBoxStyleId,
//                   styleString: AppConstants.mapBoxStyleId,
//                   // userAgentPackageName: 'com.example.learn_flutter',
//                   onMapCreated: (controller) {
//                     controller.setTelemetryEnabled(false);
//                   },

//                   compassEnabled: false,
//                   myLocationEnabled: true,
//                   myLocationRenderMode: MyLocationRenderMode.GPS,
//                   trackCameraPosition: true,
//                   onCameraTrackingDismissed: () {
//                     setState(() {
//                       _isDefaultLocation = false;
//                     });
//                   },
//                   onCameraIdle: () async {
//                     if (_isDefaultLocation) {
//                       return;
//                     }
//                     final position = await _determinePosition();
//                     // final center = await _mapController.getCenter();
//                     // final zoom = await _mapController.getZoom();
//                     // dev.log('My location is ${center.latitude} ${center.longitude} on camera idle');
//                     setState(() {
//                       _currentPosition = Position(
//                         latitude: position.latitude,
//                         longitude: position.longitude,
//                         accuracy: 0.0,
//                         altitude: 0.0,
//                         heading: 0.0,
//                         speed: 0.0,
//                         speedAccuracy: 0.0,
//                         timestamp: DateTime.now(),
//                       );
//                     });
//                   },
//                   minMaxZoomPreference: const MinMaxZoomPreference(6.0, 15.0),
//                   initialCameraPosition: CameraPosition(
//                     target: _currentPosition != null
//                         ? LatLng(_currentPosition!.latitude,
//                             _currentPosition!.longitude)
//                         : const LatLng(0.0, 0.0),
//                   ),
//                 )
//               : const Center(
//                   child: CircularProgressIndicator(),
//                 );
//         },
//       ),
//       floatingActionButton: Align(
//         alignment: Alignment.bottomLeft,
//         child: Padding(
//           padding: const EdgeInsets.all(50),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               FloatingActionButton(
//                 onPressed: _zoomIn,
//                 child: const Icon(Icons.add),
//               ),
//               const SizedBox(height: 8),
//               FloatingActionButton(
//                 onPressed: _zoomOut,
//                 child: const Icon(Icons.remove),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';

// import 'package:flutter/material.dart';
// // import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// // import 'package:flutter_map/plugin_api.dart';
// import 'package:geolocator/geolocator.dart' as geolocator;
// import 'dart:async';
// import 'dart:developer' as dev show log;
// import 'package:http/http.dart' as http;


// class AppConstants {
//   static const String mapBoxAccessToken =
//       'pk.eyJ1IjoiaXNvYmVsMzVyYW10bzM1IiwiYSI6ImNsaWhiOTN2ZDBpcG0zanA1c3VxZDdkNjMifQ.CV3WZC4Jh9mzyz-XbpRm7A';

//   static const String mapBoxStyleId = 'mapbox.satellite';
// }

// class MapPage extends StatefulWidget {
//   const MapPage({Key? key}) : super(key: key);

//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   geolocator.Position? _currentPosition;
//   // late final MapController _mapController;
//   bool _isDefaultLocation = false;
//   late StreamSubscription<geolocator.Position> _positionStreamSubscription;
  
//   // get http => null;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentPosition();
//     _determinePosition();
//     // _mapController = MapController();
//   }

//   @override
//   void dispose() {
//     // _positionStreamSubscription.cancel();
//     super.dispose();
//   }

//   Future<geolocator.Position> _determinePosition() async {
//     bool serviceEnabled;
//     geolocator.LocationPermission permission;

//     // Test if location services are enabled.
//     serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw Exception('Location services are disabled.');
//     }

//     permission = await geolocator.Geolocator.checkPermission();
//     if (permission == geolocator.LocationPermission.denied) {
//       permission = await geolocator.Geolocator.requestPermission();
//       if (permission == geolocator.LocationPermission.denied) {
//         throw Exception('Location permissions are denied.');
//       }
//     }

//     if (permission == geolocator.LocationPermission.deniedForever) {
//       throw Exception('Location permissions are permanently denied.');
//     }

//     // When we reach here, permissions are granted, and we can
//     // continue accessing the position of the device.
//     return await geolocator.Geolocator.getCurrentPosition(
//       desiredAccuracy: geolocator.LocationAccuracy.high,
//       // forceAndroidLocationManager: true
//     );
//   }

//   _getCurrentPosition() async {
//     try {
//       // _positionStreamSubscription =
//       //     geolocator.Geolocator.getPositionStream().listen((position) {
//       //   setState(() {
//       //     _currentPosition = position;
//       //     _isDefaultLocation = false;
//       //   });
//       // });
//       geolocator.Position position = await _determinePosition();
//       dev.log(
//           'My location is ${position.latitude} ${position.longitude} get current position');
//       setState(() {
//         _currentPosition = position;
//       });
//     } catch (e) {
//       setState(() {
//         _isDefaultLocation = true;
//       });
//     }
//   }

//   void _zoomIn() {
//   //   if (mounted) {
//   //     _mapController.move(_mapController.center, _mapController.zoom + 1);
//   //   }
//   // }

//   // void _zoomOut() {
//   //   if (mounted) {
//   //     _mapController.move(_mapController.center, _mapController.zoom - 1);
//   //   }
//   // }
//   // void _locateMe() async {
//   //   if (mounted) {
//   //     _mapController.move(LatLng(_currentPosition!.latitude,_currentPosition!.longitude), _mapController.zoom);
//   //   }
//     // try {
//     //   geolocator.Position position = await _determinePosition();
//     //   dev.log(
//     //       'My location is ${position.latitude} ${position.longitude} get current position');
//     //   setState(() {
//     //     _currentPosition = position;
//     //   });
//     // } catch (e) {
//     //   setState(() {
//     //     _isDefaultLocation = true;
//     //   });
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_currentPosition != null) {
//       dev.log(
//           'My location is ${_currentPosition!.latitude} ${_currentPosition!.longitude} _currentPosition');
//     }
//     return Scaffold(
//       // body: FlutterMap(
//     //     mapController: _mapController,
//     //     options: MapOptions(
//     //       minZoom: 5,
//     //       maxZoom: 18,
//     //       zoom: 6,
//     //       center: _currentPosition == null
//     //           ? const LatLng(34.968,
//     //               89.956) // Default location if current location is not available
//     //           : LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
//     //       onPositionChanged: (position, hasGesture) {
//     //         // if (mounted) {
//     //         //   setState(() {
//     //         //     _isDefaultLocation = false;
//     //         //     _currentPosition = geolocator.Position(
//     //         //       latitude: position.center?.latitude ?? 0.0,
//     //         //       longitude: position.center?.longitude ?? 0.0,
//     //         //       timestamp: DateTime.now(),
//     //         //       accuracy: 90,
//     //         //       altitude: 1,
//     //         //       heading: 6,
//     //         //       speed: 4,
//     //         //       speedAccuracy: 70,
//     //         //     );
//     //         //   });
//     //         // }
//     //       },
//     //     ),
//     //     children: [
//     //       TileLayer(
//     //         urlTemplate:
//     //             // "https://api.mapbox.com/search/searchbox/v1/suggest?q=Orlando&language=en&session_token=052be7b1-6f1a-42e1-888b-9a3c92d0cd35&access_token=${AppConstants.mapBoxAccessToken}",
//     //             "https://api.mapbox.com/styles/v1/isobel35ramto35/clik2cxj500al01qpe9j20u93/tiles/256/{z}/{x}/{y}@2x?access_token=${AppConstants.mapBoxAccessToken}",
//     //         additionalOptions: const {
//     //           'mapStyleId': AppConstants.mapBoxStyleId,
//     //         },
//     //         userAgentPackageName: 'com.example.learn_flutter',
//     //       ),
//     //       MarkerLayer(
//     //         markers: [
//     //           Marker(
//     //             width: 80.0,
//     //             height: 80.0,
//     //             point: _currentPosition != null
//     //                 ? LatLng(
//     //                     _currentPosition!.latitude, _currentPosition!.longitude)
//     //                 : const LatLng(34.968,
//     //                     89.956), // Default location if current location is not available
//     //             builder: (ctx) => const Icon(
//     //               Icons.location_on,
//     //               color: Colors.red,
//     //             ),
//     //           ),
//     //         ],
//     //       ),
//     //     ],
//     //   ),
//     //   floatingActionButton: Align(
//     //     alignment: Alignment.bottomLeft,
//     //     child: Padding(
//     //       padding: const EdgeInsets.all(50),
//     //       child: Row(
//     //         mainAxisAlignment: MainAxisAlignment.end,
//     //         crossAxisAlignment: CrossAxisAlignment.end,
//     //         children: [
//     //           FloatingActionButton(
//     //             onPressed: _zoomIn,
//     //             child: const Icon(Icons.add),
//     //           ),
//     //           const SizedBox(height: 8),
//     //           FloatingActionButton(
//     //             onPressed: _zoomOut,
//     //             child: const Icon(Icons.remove),
//     //           ),
//     //           const SizedBox(height: 8),
//     //           FloatingActionButton(
//     //             onPressed: _locateMe,
//     //             child: const Icon(Icons.my_location),
//     //           ),
//     //         ],
//     //       ),
//     //     ),
//     //   ),
//     // );
//   }
// }

import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}