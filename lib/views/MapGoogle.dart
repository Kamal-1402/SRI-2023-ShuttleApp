import 'dart:async';
import 'dart:developer' as dev show log;
// import 'dart:html';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:flutter_map/plugin_api.dart';
// import 'package:flutter_map/src/layer/tile_layer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:UserApp/AllWidgets/CollectFareDialog.dart';
import 'package:UserApp/AllWidgets/HorizontalLine.dart';
import 'package:UserApp/Assistants/assitantMethods.dart';
import 'package:UserApp/Models/directDetails.dart';
import 'package:UserApp/main.dart';
import 'package:UserApp/views/loginPage.dart';
import 'package:UserApp/views/ratingScreen.dart';
import 'package:UserApp/views/searchScreen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../AllWidgets/noDriverAvailableDialog.dart';
import '../AllWidgets/progressDialog.dart';
import '../Assistants/geoFireAssistant.dart';
import '../DataHandler/appData.dart';
import '../Models/nearByAvailableDrivers.dart';
import '../Models/allUsers.dart';
import '../configMaps.dart';
import 'ProfilePage.dart';

class MapGoogle extends StatefulWidget {
  const MapGoogle({super.key});

  @override
  State<MapGoogle> createState() => _MapGoogleState();
}

class _MapGoogleState extends State<MapGoogle> with TickerProviderStateMixin {
  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();

  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  late double bottomPaddingOfMap = 0;
  Position? _currentPosition;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool drawerOpen = true;
  // price calulation
  DirectionDetails? tripDirectionDetails;
  bool nearByAvailableDriversKeysLoaded = false;
  BitmapDescriptor? nearByIcon;
  bool isRequestingPositionDetails = false;

  // polylines
  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  // colot text
  static const colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  static const colorizeTextStyle = TextStyle(
    fontSize: 20.0,
    fontFamily: 'Horizon',
  );

  // markers
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};
  double driverDetailsContainerHeight = 0;

  double rideDetailsContainerHeight = 0;
  double requestRideContainerHeight = 0;
  double searchContainerHeight = 300.0;
  String? state = "normal";

  List<NearByAvailableDrivers>? availableDrivers;
  // StreamSubscription<Event>? rideStreamSubscription;
  StreamSubscription<DatabaseEvent>? rideStreamSubscription;
  String? uName = "";
  String? uEmail = "";

  @override
  void initState() {
    super.initState();
    AssistantMethods.getCurrentOnlineUserInfo();
  }

  void resetApp() {
    setState(() {
      drawerOpen = true;
      searchContainerHeight = 300.0;
      rideDetailsContainerHeight = 0;
      bottomPaddingOfMap = 300.0;
      requestRideContainerHeight = 0;
      polylineSet.clear();
      markersSet.clear();
      circlesSet.clear();
      pLineCoordinates.clear();
      statusRide = "";
      driverName = "";
      driverphone = "";
      carDetailsDriver = "";
      rideStatus = "Driver is Coming";
      driverDetailsContainerHeight = 0.0;
    });
    locatePosition();
  }

  DatabaseReference? rideRequestRef;

  void saveRideRequest() {
    // ignore: deprecated_member_use

    rideRequestRef =
        FirebaseDatabase.instance.ref().child('Ride Requests').push();

    var pickUp = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var dropOff = Provider.of<AppData>(context, listen: false).dropOffLocation;
    dev.log("pickUp is here, $pickUp, $dropOff");
    Map pickUpLocMap = {
      "latitude": pickUp.latitude.toString(),
      "longitude": pickUp.longitude.toString(),
    };

    Map dropOffLocMap = {
      "latitude": dropOff.latitude.toString(),
      "longitude": dropOff.longitude.toString(),
    };

    Map rideInfoMap = {
      "driver_id": "waiting",
      "payment_method": "cash",
      "pickup": pickUpLocMap,
      "dropoff": dropOffLocMap,
      "created_at": DateTime.now().toString(),
      "rider_name": userCurrentInfo!.displayName ?? "Ricky ",
      // "rider_name": "ricky ",
      "rider_phone": userCurrentInfo!.phoneNumber ?? "99999999 ",
      // "rider_phone": "99999999999 ",
      "pickup_address": pickUp.placeName,
      "dropoff_address": dropOff.placeName,
      "ride_type": carRideType,
    };
    dev.log("saverideinfo,rideInfoMap is here");
    rideRequestRef!.set(rideInfoMap);

    // error can be here
    rideStreamSubscription = rideRequestRef!.onValue.listen((event) async {
      if (event.snapshot.value == null) {
        dev.log("event snapshot from RideRequestRef from MapGoogle is null");
        return;
      }
      if ((event.snapshot.value as Map)["car_details"] != null) {
        setState(() {
          carDetailsDriver =
              (event.snapshot.value as Map)["car_details"].toString();
        });
      }
      if ((event.snapshot.value as Map)["driver_name"] != null) {
        setState(() {
          driverName = (event.snapshot.value as Map)["driver_name"].toString();
        });
      }
      if ((event.snapshot.value as Map)["driver_phone"] != null) {
        setState(() {
          driverphone =
              (event.snapshot.value as Map)["driver_phone"].toString();
        });
      }
      if ((event.snapshot.value as Map)["driver_location"] != null) {
        double driverLat = double.parse(
            (event.snapshot.value as Map)["driver_location"]["latitude"]
                .toString());
        double driverLng = double.parse(
            (event.snapshot.value as Map)["driver_location"]["longitude"]
                .toString());
        LatLng driverCurrentLocation = LatLng(driverLat, driverLng);
        if (statusRide == "accepted") {
          updateRideTimeToPickUpLoc(driverCurrentLocation);
        } else if (statusRide == "onride") {
          updateRideTimeToDropOffLoc(driverCurrentLocation);
        } else if (statusRide == "arrived") {
          setState(() {
            rideStatus = "Driver has Arrived";
          });
        } // else {
        //   displayDriverOnMap(driverCurrentLocation);
        // }
      }
      if ((event.snapshot.value as Map)["status"] != null) {
        setState(() {
          statusRide = (event.snapshot.value as Map)["status"].toString();
        });
      }
      if (statusRide == "accepted") {
        displayDriverDetailsContainer();
        Geofire.stopListener();
        deleteGeoFireMarkers();
      }
      if (statusRide == "ended") {
        if ((event.snapshot.value as Map)["fares"] != null) {
          double fares =
              double.parse((event.snapshot.value as Map)["fares"].toString());
          var res = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => CollectFareDialog(
                    paymentMethod: "cash",
                    fareAmount: fares,
                  ));
          String driverId = "";
          if (res == "close") {
            if ((event.snapshot.value as Map)["driver_id"] != null) {
              driverId = (event.snapshot.value as Map)["driver_id"].toString();
            }
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RatingScreen(
                      driverId: driverId,
                    )));
            rideRequestRef!.onDisconnect();
            rideRequestRef = null;
            rideStreamSubscription!.cancel();
            rideStreamSubscription = null;
            resetApp();
          }
        }
      }
    }); //as StreamSubscription<DataSnapshot>?;
  }

  void deleteGeoFireMarkers() {
    setState(() {
      markersSet
          .removeWhere((element) => element.markerId.value.contains("driver"));
    });
  }

  void updateRideTimeToPickUpLoc(LatLng driverCurrentLocation) async {
    if (isRequestingPositionDetails == false) {
      isRequestingPositionDetails = true;
      var positionUserLatLng =
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
      var details = await AssistantMethods.obtainPlaceDirectionDetails(
          driverCurrentLocation, positionUserLatLng);
      if (details == null) {
        return;
      }
      setState(() {
        rideStatus = "Driver is Arriving - ${details.durationValue!}";
      });
      isRequestingPositionDetails = false;
    }
  }

  void updateRideTimeToDropOffLoc(LatLng driverCurrentLocation) async {
    if (isRequestingPositionDetails == false) {
      isRequestingPositionDetails = true;
      var dropOff =
          Provider.of<AppData>(context, listen: false).dropOffLocation;
      var dropOffLatLng = LatLng(dropOff.latitude!, dropOff.longitude!);
      var details = await AssistantMethods.obtainPlaceDirectionDetails(
          driverCurrentLocation, dropOffLatLng);
      if (details == null) {
        return;
      }
      setState(() {
        rideStatus = "Going to Destination - ${details.durationValue!}";
      });
      isRequestingPositionDetails = false;
    }
  }

  void cancelRideRequest() {
    rideRequestRef!.remove();
    setState(() {
      state = "normal";
    });
  }

  void displayRequestRideContainer() {
    setState(() {
      requestRideContainerHeight = 250.0;
      rideDetailsContainerHeight = 0;
      bottomPaddingOfMap = 230.0;
      drawerOpen = true;
    });
    dev.log("displayRequestRideContainer is here");
    saveRideRequest();
  }

  void displayDriverDetailsContainer() async {
    // await getPlaceDirection();
    setState(() {
      requestRideContainerHeight = 0;
      rideDetailsContainerHeight = 0;
      bottomPaddingOfMap = 280;
      driverDetailsContainerHeight = 310;
      // drawerOpen = true;
    });
  }

  void displayRideDetailsContainer() async {
    await getPlaceDirection();
    setState(() {
      rideDetailsContainerHeight = 340;
      searchContainerHeight = 0;
      bottomPaddingOfMap = 360;
      drawerOpen = false;
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

      _currentPosition = position;

      LatLng latLngPosition = LatLng(position.latitude, position.longitude);
      CameraPosition cameraPosition =
          CameraPosition(target: latLngPosition, zoom: 14);
      newGoogleMapController!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      dev.log("This is your position:: $position");
      String address =
          await AssistantMethods.searchCoordinateAddress(position, context);
      dev.log("This is your address:: $address");

      initGeoFIreListner();
      uName = userCurrentInfo!.displayName;
      uEmail = userCurrentInfo!.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    String pickUpLocationName =
        Provider.of<AppData>(context).pickUpLocation.placeName ?? "Add Home";
    createIconMarker();
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        drawer: Container(
          color: Colors.white,
          width: 300,
          child: Drawer(
            child: ListView(
              children: [
                // Drawer Header
                UserAccountsDrawerHeader(
                  accountName: Text(uName ?? "User Name"),
                  accountEmail: Text(uEmail ?? "User Email"),
                  currentAccountPicture: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.grey),
                  ),
                ),

                // Drawer Body
                const SizedBox(height: 12),
                // ListTile(
                //   leading: Icon(Icons.history),
                //   title: Text("History"),
                // ),
                GestureDetector(
                  onTap: () {
                    // Redirect to another page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileTabPage()),
                    );
                  },
                  child: const ListTile(
                    leading: Icon(Icons.person),
                    title: Text("View Profile"),
                  ),
                ),

                // ListTile(
                //   leading: Icon(Icons.info),
                //   title: Text("About"),
                // ),
                GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    displayToastMessage("Signed Out! Succesfully", context);
                    // firebaseAuth.signOut();
                    // Redirect to another page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const loginPage()),
                    );
                  },
                  child: const ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text("Sign Out"),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              // padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
              padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              polylines: polylineSet,
              markers: markersSet,
              circles: circlesSet,
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

            // HamburgerButton for Drawer
            Positioned(
              top: 38,
              left: 22,
              child: GestureDetector(
                onTap: () {
                  if (drawerOpen) {
                    scaffoldKey.currentState!.openDrawer();
                  } else {
                    resetApp();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 6,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: Icon(
                      (drawerOpen) ? Icons.menu : Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            // Search UI
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 160),
                curve: Curves.bounceIn,
                child: Container(
                  height: searchContainerHeight,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 30),
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
                          style:
                              TextStyle(fontSize: 20, fontFamily: "Brand-Bold"),
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
                              // await getPlaceDirection();
                              displayRideDetailsContainer();
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
                              width: 6,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(pickUpLocationName)),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                const Text(
                                  "Your current location",
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.black54),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // const HorizontalLine(),
                        // const SizedBox(height: 10),
                        // const Row(
                        //   children: [
                        //     Icon(
                        //       Icons.work,
                        //       color: Colors.grey,
                        //     ),
                        //     SizedBox(
                        //       width: 12,
                        //     ),
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text("Add add"),
                        //         SizedBox(
                        //           height: 4,
                        //         ),
                        //         Text(
                        //           "Your office home address",
                        //           style: TextStyle(
                        //               fontSize: 11, color: Colors.black54),
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Ride Details UI
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedSize(
                duration: const Duration(milliseconds: 160),
                curve: Curves.bounceIn,
                child: Container(
                  height: rideDetailsContainerHeight,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 18),
                    child: Column(
                      children: [
                        // auto Ride
                        GestureDetector(
                          onTap: () {
                            displayToastMessage(
                                "Searching Shuttle Auto", context);
                            setState(() {
                              state = "requesting";
                              carRideType = "auto";
                            });
                            displayRequestRideContainer();
                            availableDrivers =
                                GeoFireAssistant.nearByAvailableDriversList;
                            searchNearestDriver();

                            dev.log("Request Button Pressed");
                          },
                          child: Container(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "images/bike.png",
                                    height: 70,
                                    width: 80,
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Shuttle Auto",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "Brand-Bold"),
                                      ),
                                      Text(
                                        ((tripDirectionDetails != null)
                                            ? "${tripDirectionDetails!.distanceValue!.toStringAsFixed(2)} Km"
                                            : ''),
                                        // "Distance -10Km",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                  const Expanded(child: SizedBox()),
                                  // Text(
                                  //   ((tripDirectionDetails != null)
                                  //       ? 'Rs ${AssistantMethods.calculateFares(tripDirectionDetails!).toString()}'
                                  //       : ''),
                                  //   style: const TextStyle(
                                  //       fontSize: 18, fontFamily: "Brand-Bold"),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(
                            height: 2, thickness: 2, color: Colors.grey),

                        const SizedBox(height: 10),

                        // van Ride
                        GestureDetector(
                          onTap: () {
                            displayToastMessage(
                                "Searching Special Auto", context);
                            setState(() {
                              state = "requesting";
                              carRideType = "van";
                            });
                            displayRequestRideContainer();
                            availableDrivers =
                                GeoFireAssistant.nearByAvailableDriversList;
                            searchNearestDriver();

                            dev.log("Request Button Pressed");
                          },
                          child: Container(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "images/ubergo.png",
                                    height: 70,
                                    width: 80,
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Special Auto",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: "Brand-Bold"),
                                      ),
                                      Text(
                                        ((tripDirectionDetails != null)
                                            ? "${tripDirectionDetails!.distanceValue!.toStringAsFixed(2)} Km"
                                            : ''),
                                        // "Distance -10Km",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                  const Expanded(child: SizedBox()),
                                  // Text(
                                  //   ((tripDirectionDetails != null)
                                  //       ? 'Rs ${AssistantMethods.calculateFares(tripDirectionDetails!).toString()}'
                                  //       : ''),
                                  //   style: const TextStyle(
                                  //       fontSize: 18, fontFamily: "Brand-Bold"),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Divider(height: 2, thickness: 2, color: Colors.grey),

                        // const SizedBox(height: 10),

                        // bus Ride
                        // GestureDetector(
                        //   onTap: () {
                        //     displayToastMessage("seraching Bus", context);
                        //     setState(() {
                        //       state = "requesting";
                        //       carRideType = "bus";
                        //     });
                        //     displayRequestRideContainer();
                        //     availableDrivers =
                        //         GeoFireAssistant.nearByAvailableDriversList;
                        //     searchNearestDriver();

                        //     dev.log("Request Button Pressed");
                        //   },
                        //   child: Container(
                        //     width: double.infinity,
                        //     child: Padding(
                        //       padding: const EdgeInsets.symmetric(
                        //           horizontal: 16, vertical: 8),
                        //       child: Row(
                        //         children: [
                        //           Image.asset(
                        //             "images/uberx.png",
                        //             height: 70,
                        //             width: 80,
                        //           ),
                        //           const SizedBox(width: 16),
                        //           Column(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               const Text(
                        //                 "Shuttle Bus",
                        //                 style: TextStyle(
                        //                     fontSize: 18,
                        //                     fontFamily: "Brand-Bold"),
                        //               ),
                        //               Text(
                        //                 ((tripDirectionDetails != null)
                        //                     ? tripDirectionDetails!
                        //                             .distanceValue!
                        //                             .toStringAsFixed(4) +
                        //                         " Km"
                        //                     : ''),
                        //                 // "Distance -10Km",
                        //                 style: TextStyle(
                        //                     fontSize: 16,
                        //                     color: Colors.grey[600]),
                        //               ),
                        //             ],
                        //           ),
                        //           const Expanded(child: SizedBox()),
                        //           Text(
                        //             ((tripDirectionDetails != null)
                        //                 ? 'Rs ${AssistantMethods.calculateFares(tripDirectionDetails!).toString()}'
                        //                 : ''),
                        //             style: const TextStyle(
                        //                 fontSize: 18, fontFamily: "Brand-Bold"),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 10),
                        Divider(height: 2, thickness: 2, color: Colors.grey),

                        const SizedBox(height: 10),

                        // const Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 16),
                        //   // child: Row(
                        //   //   children: [
                        //   //     Icon(
                        //   //       FontAwesomeIcons.moneyBillAlt,
                        //   //       size: 18,
                        //   //       color: Colors.black54,
                        //   //     ),
                        //   //     SizedBox(width: 16),
                        //   //     Text("Cash"),
                        //   //     SizedBox(width: 6),
                        //   //     Icon(Icons.keyboard_arrow_down,
                        //   //         color: Colors.black54, size: 16),
                        //   //   ],
                        //   // ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Request or cancel UI
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                height: requestRideContainerHeight,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 12.5,
                      ),
                      Positioned(
                        right: 0,
                        left: 0,
                        bottom: 0,
                        child: SizedBox(
                          width: double.infinity,
                          child: AnimatedTextKit(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => const ConfirmSheet()),
                              // );
                              dev.log("Clicked on Animated Text");
                            },
                            animatedTexts: [
                              ColorizeAnimatedText(
                                'Requesting a Ride..',
                                textStyle: colorizeTextStyle,
                                colors: colorizeColors,
                              ),
                              ColorizeAnimatedText(
                                'Please Wait..',
                                textStyle: colorizeTextStyle,
                                colors: colorizeColors,
                              ),
                              ColorizeAnimatedText(
                                'Finding a Driver..',
                                textStyle: colorizeTextStyle,
                                colors: colorizeColors,
                              ),
                            ],
                            isRepeatingAnimation: true,
                            // textAlign: TextAlign.center,
                            // aligment: AlignmentDirectional.topStart,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          cancelRideRequest();
                          resetApp();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(
                                  width: 2, color: Colors.grey[300]!),
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: double.infinity,
                        child: const Text(
                          "Cancel Ride",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            // Display assigned driver info
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                height: driverDetailsContainerHeight,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            rideStatus,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20, fontFamily: "Brand-Bold"),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Divider(
                        height: 2,
                        thickness: 2.0,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Car Details: $carDetailsDriver",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "Name: $driverName",
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(
                        height: 2,
                        thickness: 2.0,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //  call button
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextButton(
                              onPressed: () async {
                                var url = Uri.parse('tel:$driverphone');
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                backgroundColor: Colors.tealAccent[700],
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.call,
                                      color: Colors.white,
                                      size: 26,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Call Driver",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
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
    dev.log("This is your pickUpLatLng MapGoogle:: $pickUpLatLng");
    dev.log("This is your dropOffLatLng MapGoogle:: $dropOffLatLng");
    showDialog(
        context: context,
        builder: (BuildContext context) => const ProgressDialog(
              message: "Please wait... this is MapGoogle",
            ));
    var details = await AssistantMethods.obtainPlaceDirectionDetails(
        pickUpLatLng, dropOffLatLng);
    setState(() {
      tripDirectionDetails = details;
    });

    Navigator.pop(context);
    dev.log("This is Encoded Points :: ");
    dev.log(details!.encodedPoints.toString());

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints!);

    pLineCoordinates.clear();
    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        polylineId: const PolylineId("PolylineId"),
        color: Colors.blue,
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polylineSet.add(polyline);
    });

    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
        pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
          northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    }

    newGoogleMapController
        ?.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow:
          InfoWindow(title: initialPos.placeName, snippet: "My Location"),
      position: pickUpLatLng,
      markerId: const MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: finalPos.placeName, snippet: "DropOff Location"),
      position: dropOffLatLng,
      markerId: const MarkerId("dropOffId"),
    );

    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
      fillColor: Colors.blueAccent,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId: const CircleId("pickUpId"),
    );

    Circle dropOffLocCircle = Circle(
      fillColor: Colors.deepPurple,
      center: dropOffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.deepPurple,
      circleId: const CircleId("dropOffId"),
    );

    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });
  }

  void initGeoFIreListner() {
    Geofire.initialize("availableDrivers");
    Geofire.queryAtLocation(
            _currentPosition!.latitude, _currentPosition!.longitude, 15)!
        .listen((map) {
      // dev.log(map.toString());
      // dev.log("This is from 1245 line in MapGoogle");
      if (map != null) {
        var callBack = map["callBack"];
        switch (callBack) {
          case Geofire.onKeyEntered:
            NearByAvailableDrivers nearByAvailableDrivers =
                NearByAvailableDrivers();
            nearByAvailableDrivers.key = map["key"];
            nearByAvailableDrivers.latitude = map["latitude"];
            nearByAvailableDrivers.longitude = map["longitude"];
            GeoFireAssistant.nearByAvailableDriversList
                .add(nearByAvailableDrivers);
            if (nearByAvailableDriversKeysLoaded) {
              updateAvailableDriversOnMap();
            }
            break;

          case Geofire.onKeyExited:
            GeoFireAssistant.removeDriverFromList(map["key"]);
            updateAvailableDriversOnMap();
            break;

          case Geofire.onKeyMoved:
            NearByAvailableDrivers nearByAvailableDrivers =
                NearByAvailableDrivers();
            nearByAvailableDrivers.key = map["key"];
            nearByAvailableDrivers.latitude = map["latitude"];
            nearByAvailableDrivers.longitude = map["longitude"];
            GeoFireAssistant.updateDriverNearbyLocation(nearByAvailableDrivers);
            updateAvailableDriversOnMap();
            break;

          case Geofire.onGeoQueryReady:
            updateAvailableDriversOnMap();
            break;
        }
      }
      setState(() {});
    });
    setState(() {});
  }

  void updateAvailableDriversOnMap() {
    setState(() {
      markersSet.clear();
    });
    Set<Marker> tMarkers = Set<Marker>();
    for (NearByAvailableDrivers driver
        in GeoFireAssistant.nearByAvailableDriversList) {
      LatLng driverAvailablePosition =
          LatLng(driver.latitude ?? 0.0, driver.longitude ?? 0.0);
      Marker marker = Marker(
        markerId: MarkerId("driver${driver.key}"),
        position: driverAvailablePosition,
        icon: nearByIcon!,
        rotation: AssistantMethods.createRandomNumber(360),
      );
      tMarkers.add(marker);
    }
    setState(() {
      markersSet = tMarkers;
    });
  }

  void createIconMarker() {
    if (nearByIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(0.2, 0.2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, "images/car_ios.png")
          .then((value) {
        nearByIcon = value;
      });
    }
  }

  void noDriverFound() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const NoDriverAvailableDialog());
  }

  void searchNearestDriver() {
    if (availableDrivers!.isEmpty) {
      cancelRideRequest();
      resetApp();
      noDriverFound();
      return;
    }
    var driver = availableDrivers?[0];
    driversRef
        .child(driver!.key!)
        .child("car_details")
        .child("type")
        .once()
        .then((DatabaseEvent databaseEvent) async {
      if (databaseEvent.snapshot.value != null) {
        String carType = databaseEvent.snapshot.value.toString();
        if (carType == carRideType || carType == "auto") {
          dev.log(driver.key.toString());
          notifyDriver(driver);
          availableDrivers!.removeAt(0);
        } else {
          displayToastMessage(
              "No driver found with the selected car type, try again", context);
        }
      } else {
        displayToastMessage("No Shuttle Found, try again", context);
        // return;
      }
    });
  }

  void notifyDriver(NearByAvailableDrivers driver) {
    driversRef.child(driver.key!).child("newRide").set(rideRequestRef!.key);
    driversRef
        .child(driver.key!)
        .child("token")
        .once()
        .then((DatabaseEvent databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        String token = databaseEvent.snapshot.value.toString();
        AssistantMethods.sendNotificationToDriver(
            token, context, rideRequestRef!.key!);
      } else {
        return;
      }
      // const timeout = Duration(seconds: 30);
      // const ms = Duration(milliseconds: 1);
      // Timer.periodic(timeout, (Timer t) {
      //   driversRef.child(driver.key!).child("newRide").set("cancelled");
      //   driversRef.child(driver.key!).child("newRide").onDisconnect();
      //   driverRequestTimeOut = 30;
      //   t.cancel();
      // });

      const oneSecondPassed = Duration(seconds: 1);
      var timer = Timer.periodic(oneSecondPassed, (timer) {
        if (state != "requesting") {
          driversRef.child(driver.key!).child("newRide").set("cancelled");
          driversRef.child(driver.key!).child("newRide").onDisconnect();
          driverRequestTimeOut = 240;
          timer.cancel();
          driversRef.child(driver.key!).child("newRide").set("searching");
        }
        driverRequestTimeOut--;

        driversRef.child(driver.key!).child("newRide").onValue.listen((event) {
          if (event.snapshot.value.toString() == "accepted") {
            driversRef.child(driver.key!).child("newRide").onDisconnect();
            driverRequestTimeOut = 240;
            timer.cancel();
          }
        });
        if (driverRequestTimeOut == 0) {
          driversRef.child(driver.key!).child("newRide").set("timeout");
          driversRef.child(driver.key!).child("newRide").onDisconnect();
          cancelRideRequest();
          resetApp();
          driverRequestTimeOut = 240;
          timer.cancel();

          searchNearestDriver();
          driversRef.child(driver.key!).child("newRide").set("searching");
        }
      });
    });
  }
}
