import 'dart:async';
import 'dart:developer' as dev show log;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
// import 'package:flutter_map/src/layer/tile_layer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:learn_flutter/AllWidgets/HorizontalLine.dart';
import 'package:learn_flutter/Assistants/assitantMethods.dart';
import 'package:learn_flutter/views/searchScreen.dart';
import 'package:provider/provider.dart';

import '../AllWidgets/progressDialog.dart';
import '../DataHandler/appData.dart';

class MapGoogle extends StatefulWidget {
  const MapGoogle({super.key});

  @override
  State<MapGoogle> createState() => _MapGoogleState();
}

class _MapGoogleState extends State<MapGoogle> {
  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  late double bottomPaddingOfMap = 0;
  Position? _currentPosition;

  Future<bool> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    // When we reach here, permissions are granted, and we can
    // continue accessing the position of the device.
    return true;
  }

  void locatePosition() async {
    bool isLocationEnabled = await _determinePosition();
    if (isLocationEnabled) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      _currentPosition = position;

      LatLng latLngPosition = LatLng(position.latitude, position.longitude);
      CameraPosition cameraPosition =
          CameraPosition(target: latLngPosition, zoom: 14);
      newGoogleMapController!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      dev.log("This is your position:: " + position.toString());
      String address =
          await AssistantMethods.searchCoordinateAddress(position, context);
      dev.log("This is your address:: " + address);
    }
  }

  @override
  Widget build(BuildContext context) {
    String pickUpLocationName =
        Provider.of<AppData>(context).pickUpLocation.placeName ?? "Add Home";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Google'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            initialCameraPosition: const CameraPosition(
              target: LatLng(23.7128, 72.0060),
              zoom: 10,
            ),
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                bottomPaddingOfMap = 300.0;
              });

              locatePosition();
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 16,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    const Text(
                      "Hi there,",
                      style: TextStyle(fontSize: 12),
                    ),
                    const Text(
                      "Where to?",
                      style: TextStyle(fontSize: 20, fontFamily: "Brand-Bold"),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                        var res = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SearchScreen()),
                        );
                        if (res == "obtainDirection") {
                          await getPlaceDirection();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              spreadRadius: 0.5,
                              offset: Offset(0.7, 0.7),
                            ),
                          ],
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.blueAccent,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Search Drop Off"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Icon(
                          Icons.home,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pickUpLocationName),
                            const SizedBox(
                              height: 4,
                            ),
                            const Text(
                              "Your living home address",
                              style: TextStyle(
                                  fontSize: 11, color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const HorizontalLine(),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Icon(
                          Icons.work,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Add add"),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Your office home address",
                              style: TextStyle(
                                  fontSize: 11, color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getPlaceDirection() async {
    var initialPos =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLatLng =
        LatLng(initialPos.latitude ?? 0.0, initialPos.longitude ?? 0);
    var dropOffLatLng =
        LatLng(finalPos.latitude ?? 0.0, finalPos.longitude ?? 0);

    showDialog(
        context: context,
        builder: (BuildContext context) =>const ProgressDialog(
              message: "Please wait...",
            ));
    var details = await AssistantMethods.obtainPlaceDirectionDetails(
        pickUpLatLng, dropOffLatLng);
    Navigator.pop(context);
    dev.log("This is Encoded Points :: ");
    dev.log(details!.encodedPoints.toString());
  }
}
