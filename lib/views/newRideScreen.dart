import 'dart:async';
import 'dart:developer' as dev show log;
import 'package:DriverApp/Models/ridedetails.dart';
import 'package:DriverApp/configMaps.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../AllWidgets/CollectFareDialog.dart';
import '../AllWidgets/progressDialog.dart';
import '../Assistants/assitantMethods.dart';
import '../Assistants/mapKitAssistant.dart';
import '../DataHandler/appData.dart';
import '../main.dart';

class NewRideScreen extends StatefulWidget {
  final RideDetails? rideDetails;
  // NewRideScreen({this.rideDetails});
  const NewRideScreen({super.key, this.rideDetails});

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  State<NewRideScreen> createState() => _NewRideScreenState();
}

class _NewRideScreenState extends State<NewRideScreen> {
  Completer<GoogleMapController> controllerGoogleMap = Completer();
  late GoogleMapController newRideGoogleMapController;
  Set<Marker> markersSet = Set<Marker>();
  Set<Circle> circlesSet = Set<Circle>();
  Set<Polyline> polyLineSet = Set<Polyline>();
  List<LatLng> polyLineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  double mapPaddingFromBottom = 0;
  // var geoLocator = Geolocator();
  // var locationOptions =
  //     LocationOptions(accuracy: LocationAccuracy.bestForNavigation);
  BitmapDescriptor? animatingMarkerIcon;
  Position? myPosition;
  String status = "accepted";
  String durationRide = "";
  bool isRequestingDirection = false;
  String btnTitle = "Arrived";
  Color btnColor = Colors.deepPurpleAccent;
  Timer? timer;
  int durationCounter = 0;

  @override
  void initState() {
    super.initState();
    acceptRideRequest();
  }

  void createIconMarker() {
    if (animatingMarkerIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, "images/car_android.png")
          .then((value) {
        animatingMarkerIcon = value;
      });
    }
  }

  void getRideLiveLocationUpdates() {
    LatLng oldPos = LatLng(0, 0);
    rideStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      myPosition = position;
      LatLng mPosition = LatLng(position.latitude, position.longitude);

      var rot = MapKitAssistant.getMarkerRotation(oldPos.latitude,
          oldPos.longitude, mPosition.latitude, mPosition.longitude);

      Marker animatingMarker = Marker(
        markerId: MarkerId("animating"),
        position: mPosition,
        icon: animatingMarkerIcon!,
        rotation: rot.toDouble(),
        infoWindow: InfoWindow(title: "Current Location"),
        // rotation: AssistantMethods.createRandomNumber(360),
        // infoWindow: InfoWindow(title: "Current Location"),
      );
      setState(() {
        CameraPosition cameraPosition =
            new CameraPosition(target: mPosition, zoom: 17);
        newRideGoogleMapController
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        markersSet
            .removeWhere((marker) => marker.markerId.value == "animating");
        markersSet.add(animatingMarker);
      });
      oldPos = mPosition;
      updateRideDetails();
      String rideRequestId = widget.rideDetails!.ride_request_id!;
      Map locMap = {
        "latitude": currentPosition!.latitude.toString(),
        "longitude": currentPosition!.longitude.toString(),
      };
      newRequestsRef.child(rideRequestId).child("driver_location").set(locMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    createIconMarker();

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPaddingFromBottom),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: NewRideScreen._kGooglePlex,
            myLocationEnabled: true,
            markers: markersSet,
            circles: circlesSet,
            polylines: polyLineSet,
            onMapCreated: (GoogleMapController controller) async {
              controllerGoogleMap.complete(controller);
              newRideGoogleMapController = controller;

              setState(() {
                mapPaddingFromBottom = 265.0;
              });

              var currentLatLng =
                  LatLng(currentPosition!.latitude, currentPosition!.longitude);
              var pickUpLatLng = widget.rideDetails!.pickup!;
              // locatePosition();
              await getPlaceDirection(currentLatLng, pickUpLatLng);

              getRideLiveLocationUpdates();
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              // height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 16,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                  )
                ],
              ),
              height: 350,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                  children: [
                    Text(
                      durationRide + " min",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Brand-Bold",
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.rideDetails!.rider_name!,
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: "Brand-Bold",
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 10),
                        //   child: Icon(Icons.call),
                        // ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "images/pickicon.png",
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.rideDetails!.pickup_address!,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "images/desticon.png",
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              widget.rideDetails!.dropoff_address!,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (status == "accepted") {
                            status = "arrived";
                            String rideRequestId =
                                widget.rideDetails!.ride_request_id!;
                            newRequestsRef
                                .child(rideRequestId)
                                .child("status")
                                .set(status);
                            setState(() {
                              btnTitle = "Start Trip";
                              btnColor = Colors.purpleAccent;
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  const ProgressDialog(
                                message: "Please wait",
                              ),
                            );
                            await getPlaceDirection(widget.rideDetails!.pickup!,
                                widget.rideDetails!.dropoff!);
                            Navigator.pop(context);
                          } else if (status == "arrived") {
                            status = "onride";
                            String rideRequestId =
                                widget.rideDetails!.ride_request_id!;
                            newRequestsRef
                                .child(rideRequestId)
                                .child("status")
                                .set(status);
                            setState(() {
                              btnTitle = "End Trip";
                              btnColor = Colors.redAccent;
                            });
                            initTimer();
                          } else if (status == "onride") {
                            endTheTrip();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: btnColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(17),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                btnTitle,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.directions_car,
                                color: Colors.white,
                                size: 26,
                              ),
                            ],
                          ),
                        ),
                      ),
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

  Future<void> getPlaceDirection(
      LatLng pickUpLatLng, LatLng dropOffLatLng) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => const ProgressDialog(
              message: "Please wait",
            ));
    var details = await AssistantMethods.obtainPlaceDirectionDetails(
        pickUpLatLng, dropOffLatLng);

    Navigator.pop(context);
    dev.log("This is Encoded Points :: ");
    dev.log(details!.encodedPoints.toString());

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints!);

    polyLineCoordinates.clear();
    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        polyLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polyLineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        polylineId: const PolylineId("PolylineId"),
        color: Colors.blue,
        jointType: JointType.round,
        points: polyLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      polyLineSet.add(polyline);
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

    newRideGoogleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      position: pickUpLatLng,
      markerId: const MarkerId("pickUpId"),
    );

    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
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

  void acceptRideRequest() {
    String rideRequestId = widget.rideDetails!.ride_request_id!;
    newRequestsRef.child(rideRequestId).child("status").set("accepted");
    newRequestsRef
        .child(rideRequestId)
        .child("driver_name")
        .set(driversInformation!.displayName);
    newRequestsRef
        .child(rideRequestId)
        .child("driver_phone")
        .set(driversInformation!.phoneNumber);
    newRequestsRef
        .child(rideRequestId)
        .child("driver_id")
        .set(driversInformation!.id);
    newRequestsRef.child(rideRequestId).child("passenger_count").set(count);
    newRequestsRef.child(rideRequestId).child("car_details").set(
        '${driversInformation!.car_color}-${driversInformation!.car_model}-${driversInformation!.car_number}');
    newRequestsRef.child(rideRequestId).child("driver_location").set({
      "latitude": currentPosition!.latitude.toString(),
      "longitude": currentPosition!.longitude.toString(),
    });
    driversRef
        .child(currentfirebaseUser!.uid)
        .child("history")
        .child(rideRequestId)
        .set(true);
  }

  void updateRideDetails() async {
    if (isRequestingDirection == false) {
      isRequestingDirection = true;
      if (myPosition == null) {
        return;
      }
      var posLatLng = LatLng(myPosition!.latitude, myPosition!.longitude);
      LatLng destinationLatLng;
      if (status == "accepted") {
        destinationLatLng = widget.rideDetails!.pickup!;
      } else {
        destinationLatLng = widget.rideDetails!.dropoff!;
      }

      var directionDetails = await AssistantMethods.obtainPlaceDirectionDetails(
          posLatLng, destinationLatLng);
      if (directionDetails != null) {
        setState(() {
          durationRide =
              directionDetails.durationValue.toString().split('.').first;
          // String result = originalString.split('.').first;
        });
      }
      isRequestingDirection = false;
    }
  }

  void initTimer() {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      durationCounter++;
    });
  }

  void endTheTrip() async {
    timer!.cancel();

    showDialog(
        context: context,
        builder: (BuildContext context) => const ProgressDialog(
              message: "Please wait",
            ));

    var currentLatLng = LatLng(myPosition!.latitude, myPosition!.longitude);
    var directionalDetails = await AssistantMethods.obtainPlaceDirectionDetails(
        widget.rideDetails!.pickup!, widget.rideDetails!.dropoff!);
    Navigator.pop(context);

    String rideRequestId = widget.rideDetails!.ride_request_id!;
    double fareAmount =
        AssistantMethods.calculateFares(directionalDetails!, rideRequestId);
    newRequestsRef
        .child(rideRequestId)
        .child("fares")
        .set(fareAmount.toString());
    newRequestsRef.child(rideRequestId).child("status").set("ended");

    rideStreamSubscription!.cancel();

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CollectFareDialog(
              paymentMethod: widget.rideDetails!.payment_method,
              fareAmount: fareAmount,
            ));
    saveEarnings(fareAmount);
  }

  void saveEarnings(double fareAmount) {
    driversRef
        .child(currentfirebaseUser!.uid)
        .child("earnings")
        .once()
        .then((DatabaseEvent databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        double oldEarnings =
            double.parse(databaseEvent.snapshot.value.toString());
        double totalEarnings = fareAmount + oldEarnings;
        driversRef
            .child(currentfirebaseUser!.uid)
            .child("earnings")
            .set(totalEarnings.toStringAsFixed(2));
      } else {
        double totalEarnings = fareAmount;
        driversRef
            .child(currentfirebaseUser!.uid)
            .child("earnings")
            .set(totalEarnings.toStringAsFixed(2));
      }
    });
  }
}
