import 'dart:async';
import 'dart:developer' as dev show log;
import 'package:DriverApp/configMaps.dart';
import 'package:DriverApp/main.dart';
import 'package:DriverApp/views/carInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Assistants/assitantMethods.dart';
import '../Models/drivers.dart';
import '../Notifications/pushNotificationService.dart';

class HomeTabPage extends StatefulWidget {
  HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();

  GoogleMapController? newGoogleMapController;

  bool isDriverAvailable = false;
  @override
  void initState() {
    super.initState();
    getCurrentDriverInfo();
    AssistantMethods.retrieveHistoryInfo(context);
    // AssistantMethods.obtainTripRequestHistoryData(context);
    // dev.log("getCurrentDriverInfo did not work");
  }

  void getRideType() async {
    driversRef
        .child(currentfirebaseUser!.uid)
        .child("car_details")
        .child("type")
        .once()
        .then((DatabaseEvent databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        setState(() {
          rideType = databaseEvent.snapshot.value.toString();
        });
      }
    });
  }

  void getRating() {
    // update Ratings
    driversRef
        .child(currentfirebaseUser!.uid)
        .child("ratings")
        .once()
        .then((DatabaseEvent databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        String ratings = databaseEvent.snapshot.value.toString();
        setState(() {
          starCounter = double.parse(ratings);
        });

        if (starCounter <= 1.5) {
          setState(() {
            title = "Very Bad";
          });
          return;
        }
        if (starCounter <= 2.5) {
          setState(() {
            title = "Bad";
          });
          return;
        }
        if (starCounter <= 3.5) {
          setState(() {
            title = "Good";
          });
          return;
        }
        if (starCounter <= 4.5) {
          setState(() {
            title = "Very Good";
          });
          return;
        }
        if (starCounter <= 5) {
          setState(() {
            title = "Excellent";
          });
          return;
        }
      }
    });
  }

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

      currentPosition = position;

      LatLng latLngPosition = LatLng(position.latitude, position.longitude);
      CameraPosition cameraPosition =
          CameraPosition(target: latLngPosition, zoom: 14);
      newGoogleMapController!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      dev.log("This is your position:: " + position.toString());
      // String address =
      //     await AssistantMethods.searchCoordinateAddress(position, context);
      // dev.log("This is your address:: " + address);
    }
  }

  Future<void> getCurrentDriverInfo() async {
    currentfirebaseUser = await FirebaseAuth.instance.currentUser!;
    driversRef
        .child(currentfirebaseUser!.uid)
        .once()
        .then((DatabaseEvent databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        driversInformation = Drivers.fromSnapshot(databaseEvent.snapshot);
        // dev.log(driversInformation!.id.toString() + "line 161 fot hometabpage");
      }
    });
    // dev.log(driversInformation!.displayName.toString() + "line 163 fot hometabpage");
    // dev.log("line 164 from hometabpage ");
    PushNotificationService pushNotificationService = PushNotificationService();

    pushNotificationService.initialize(context);
    // dev.log("line 169 from hometabpage ");
    pushNotificationService.getToken();

    AssistantMethods.retrieveHistoryInfo(context);
    getRating();
    getRideType();
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          GoogleMap(
            // padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            // polylines: polylineSet,
            // markers: markersSet,
            // circles: circlesSet,
            initialCameraPosition: const CameraPosition(
              target: LatLng(23.7128, 72.0060),
              zoom: 10,
            ),
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              locatePosition();
            },
          ),

          // online offline driver container
          // Container(
          //   height: 140,
          //   width: double.infinity,
          //   color: Colors.black54,
          // ),

          // online offline driver container
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                      onPressed: () {
                        if (isDriverAvailable != true) {
                          makeDriverOnlineNow();
                          getLocationLiveUpdates();

                          setState(() {
                            driverStatusColor = Colors.green;
                            driverStatusText = "Online Now ";
                            isDriverAvailable = true;
                          });

                          displayToastMessage("You are Online Now", context);
                        } else {
                          makeDriverOfflinenow();
                          setState(() {
                            driverStatusColor = Colors.black;
                            driverStatusText = "Offline Now - Go Online ";
                            isDriverAvailable = false;
                          });

                          displayToastMessage("You are Offline Now", context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: driverStatusColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(17),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                driverStatusText,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: "Brand Bold",
                                ),
                              ),
                              Icon(
                                Icons.phone_android,
                                color: Colors.white,
                                size: 26,
                              ),
                            ],
                          ))),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void makeDriverOnlineNow() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    Geofire.initialize("availableDrivers");
    Geofire.setLocation(currentfirebaseUser!.uid, currentPosition!.latitude,
        currentPosition!.longitude);

    rideRequestRef.set("searching");

    rideRequestRef.onValue.listen((event) {});
  }

  void getLocationLiveUpdates() {
    homeTabPageStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;

      if (isDriverAvailable == true) {
        Geofire.setLocation(
            currentfirebaseUser!.uid, position.latitude, position.longitude);
        dev.log("isDriverAvailable == true");
      }

      LatLng latlng = LatLng(position.latitude, position.longitude);
      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latlng));
    });
  }

  void makeDriverOfflinenow() {
    Geofire.removeLocation(currentfirebaseUser!.uid);
    rideRequestRef.onDisconnect();
    rideRequestRef.remove();
    // rideRequestRef = Null;
  }
}
