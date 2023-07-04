// import 'dart:js';
import 'dart:developer' as dev show log;

import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:latlng/latlng.dart';
import 'package:DriverApp/Assistants/requestAssitant.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../DataHandler/appData.dart';
import '../Models/address.dart';
import '../Models/allUsers.dart';
import '../Models/history.dart';
import '../configMaps.dart';
import '../Models/directDetails.dart';
import '../main.dart';

// import '../Models/configMaps.dart' as config show mapKey;
// configMaps config = config();
class AssistantMethods {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = "";
    String st1, st2, st3, st4;
    String url =
        // "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$dotenv.env['mapkey']";
        "https://api.mapbox.com/geocoding/v5/mapbox.places/${position.longitude},${position.latitude}.json?access_token=pk.eyJ1IjoiaXNvYmVsMzVyYW10bzM1IiwiYSI6ImNsaWhiOTN2ZDBpcG0zanA1c3VxZDdkNjMifQ.CV3WZC4Jh9mzyz-XbpRm7A";
    var response = await RequestAssistant.getRequest(url);

    if (response != "failed") {
      placeAddress = response["features"][0]["place_name"];
      // st1 = response["results"][0]["address_components"][3]["long_name"];
      // st2 = response["results"][0]["address_components"][4]["long_name"];
      // st3 = response["results"][0]["address_components"][5]["long_name"];
      // st4 = response["results"][0]["address_components"][6]["long_name"];
      // placeAddress = st1 + ", " + st2 + ", " + st3 + ", " + st4;

      Address userPickUpAddress = Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }
    return placeAddress;
  }

  static Future<DirectionDetails?> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        // "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$dotenv.env['mapKey']";
        // "https://api.mapbox.com/directions/v5/mapbox/driving/${initialPosition.longitude},${finalPosition.longitude};${initialPosition.latitude},${finalPosition.latitude}?steps=true&voice_instructions=true&banner_instructions=true&voice_units=imperial&access_token=pk.eyJ1IjoiaXNvYmVsMzVyYW10bzM1IiwiYSI6ImNsaWhiOTN2ZDBpcG0zanA1c3VxZDdkNjMifQ.CV3WZC4Jh9mzyz-XbpRm7A";
        "https://api.mapbox.com/directions/v5/mapbox/driving/${initialPosition.longitude},${initialPosition.latitude};${finalPosition.longitude},${finalPosition.latitude}?alternatives=false&annotations=distance&geometries=polyline&language=en&overview=full&steps=true&voice_instructions=true&banner_instructions=true&voice_units=imperial&access_token=pk.eyJ1IjoiaXNvYmVsMzVyYW10bzM1IiwiYSI6ImNsaWhiOTN2ZDBpcG0zanA1c3VxZDdkNjMifQ.CV3WZC4Jh9mzyz-XbpRm7A";
    var res = await RequestAssistant.getRequest(directionUrl);
    if (res == "failed") {
      return null;
    }
    // Map<String, dynamic> data = json.decode(res);
    if (res['routes'] == null || res['routes'].isEmpty) {
      return null;
    }
    Map<String, dynamic> route = res['routes'][0];
    DirectionDetails directionDetails = DirectionDetails();
    // directionDetails.encodedPoints =
    //     res["routes"][0]["overview_polyline"]["points"];
    // directionDetails.distanceText =
    //     res["routes"][0]["legs"][0]["distance"]["text"];
    // directionDetails.distanceValue =
    //     res["routes"][0]["legs"][0]["distance"]["value"];
    // directionDetails.durationText =
    //     res["routes"][0]["legs"][0]["duration"]["text"];
    // directionDetails.durationValue =
    //     res["routes"][0]["legs"][0]["duration"]["value"];

    directionDetails.encodedPoints = route['geometry'];
    // directionDetails.distanceText = route['distance'];
    // directionDetails.durationText = route['duration'];
    directionDetails.distanceText = double.parse(route['distance'].toString());
    directionDetails.durationText = double.parse(route['duration'].toString());
    directionDetails.durationValue = (route['duration']) / 60;
    directionDetails.distanceValue = (route['distance']) / 1000;
    return directionDetails;
  }

  static double calculateFares(
      DirectionDetails directionDetails, String rideRequestId) {
    newRequestsRef
        .child(rideRequestId)
        .child("passenger_count")
        .once()
        .then((DatabaseEvent databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        count = int.parse(databaseEvent.snapshot.value.toString());
        dev.log(count.toString() + "this is the count form assisstant method");
      }
    });
    
    double timeTraveledFare = (directionDetails.durationText! / 60) * 0.20;
    double distanceTraveledFare =
        (directionDetails.distanceText! / 1000) * 0.20;
    double passengerCnt = count + 0.0;
    // dev.log(passengerFare.toString());
    double totalFareAmount = (timeTraveledFare + distanceTraveledFare);
    totalFareAmount =
        count == 0 ? totalFareAmount : totalFareAmount / passengerCnt;
    // local currency
    // 1$ = 80 RS
    double totalLocalAmount = totalFareAmount*50;

    // if (rideType == "bus" || rideType == "van" || rideType == "auto") {
    //   totalLocalAmount = totalLocalAmount * 0.5;
    // }
    // if (rideType == "van") {
    //   totalLocalAmount = totalLocalAmount * 0.7;
    // }
    // if (rideType == "auto") {
    //   totalLocalAmount = totalLocalAmount;
    // }
    // Extract first two digits after the decimal point
    // String localAmountString = totalLocalAmount.toStringAsFixed(2);
    // String firstTwoDigits = localAmountString.substring(
    //   localAmountString.indexOf('.') + 1,
    //   localAmountString.indexOf('.') + 3,
    // );
    // dev.log("firstTwoDigits of the Rs: $firstTwoDigits");
    return (totalLocalAmount);
  }

  // static void getCurrentOnlineUserInfo() async {
  //   firebaseUser = await FirebaseAuth.instance.currentUser!;
  //   String userId = firebaseUser!.uid;
  //   dev.log("userId is $userId");
  //   DatabaseReference reference =
  //       FirebaseDatabase.instance.ref().child('users').child(userId);
  //   reference.once().then((DataSnapshot snapshot) {
  //         if (snapshot.value != null) {
  //           userCurrentInfo = Users.fromSnapshot(snapshot);
  //           dev.log("snapshot is here form AssistantMethods");
  //         } else {
  //           dev.log("snapshot is null form AssistantMethods");
  //         }
  //       } as FutureOr Function(DatabaseEvent value));
  //   // get a current user info from firebase
  // }
//   static void getCurrentOnlineUserInfo() async {
//   dev.log("getCurrentOnlineUserInfo is called");
//   firebaseUser = await FirebaseAuth.instance.currentUser!;
//   String userId = firebaseUser!.uid;
//   dev.log("userId is $userId");
//   DatabaseReference reference =
//       FirebaseDatabase.instance.ref().child('users').child(userId);
//   dev.log("reference is $reference");
//   reference.once().then((event) {
//     final dataSnapshot = event.snapshot;
//     final dataSnapshotMap = dataSnapshot.value as Map<String, dynamic>?;
//     if (dataSnapshotMap != null) {
//       userCurrentInfo = Users.fromSnapshot(dataSnapshotMap as DataSnapshot);
//       dev.log("snapshot and userCurrentInfo is here form AssistantMethods");
//     } else {
//       dev.log("snapshot is null form AssistantMethods");
//     }
//   });
// }
  static void getCurrentOnlineUserInfo() async {
    firebaseUser = await FirebaseAuth.instance.currentUser!;
    String userId = firebaseUser!.uid;
    dev.log("userId is $userId");
    DatabaseReference reference =
        FirebaseDatabase.instance.ref().child('users').child(userId);
    reference.once().then((DatabaseEvent databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        userCurrentInfo = Users.fromSnapshot(databaseEvent.snapshot);
        dev.log("snapshot is here form AssistantMethods");
      } else {
        dev.log("snapshot is null form AssistantMethods");
      }
    }); //as FutureOr Function(DatabaseEvent value));
    // get a current user info from firebase
  }

  static void disableHomeTabLiveLocationUpdates() {
    homeTabPageStreamSubscription!.pause();
    Geofire.removeLocation(currentfirebaseUser!.uid);
  }

  static void enableHomeTabLiveLocationUpdates() {
    homeTabPageStreamSubscription!.resume();
    Geofire.setLocation(currentfirebaseUser!.uid, currentPosition!.latitude,
        currentPosition!.longitude);
  }

  static void retrieveHistoryInfo(context) {
    //retrieve and display earnings
    driversRef
        .child(currentfirebaseUser!.uid)
        .child("earnings")
        .once()
        .then((DatabaseEvent databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        String earnings = databaseEvent.snapshot.value.toString();
        Provider.of<AppData>(context, listen: false).updateEarnings(earnings);
      }
    });

    //retrieve and display trip history
    driversRef
        .child(currentfirebaseUser!.uid)
        .child("history")
        .once()
        .then((DatabaseEvent databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        //update total number of trip counts to provide
        // a value for the trip count
        Map<dynamic, dynamic> keys = databaseEvent.snapshot.value as Map;
        int tripCount = keys.length;
        Provider.of<AppData>(context, listen: false)
            .updateTripsCounter(tripCount);
        //update trip keys to provide a value for the trip keys
        List<String> tripHistoryKeys = [];
        keys.forEach((key, value) {
          tripHistoryKeys.add(key);
        });
        Provider.of<AppData>(context, listen: false)
            .updateTripKeys(tripHistoryKeys);
        obtainTripRequestHistoryData(context);
      }
    });
  }

  static void obtainTripRequestHistoryData(context) {
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;
    for (String key in keys) {
      newRequestsRef.child(key).once().then((DatabaseEvent databaseEvent) {
        if (databaseEvent.snapshot.value != null) {
          var history = History.fromSnapshot(databaseEvent.snapshot);
          Provider.of<AppData>(context, listen: false)
              .updateTripHistoryData(history);
        }
      });
    }
  }

  static String formatTripDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";
    return formattedDate;
  }

  static void passengerCount(int count) {
    DatabaseReference passengerCountRef =
        FirebaseDatabase.instance.ref().child("passengerCount");
    passengerCountRef.set(count);
  }

  // static void passengerCount(context) {
  //   DatabaseReference passengerCountRef =
  //       FirebaseDatabase.instance.ref().child("passengerCount");
  //   passengerCountRef.once().then((DataSnapshot dataSnapshot) {
  //     if (dataSnapshot.value != null) {
  //       int passengerCount = dataSnapshot.value;
  //       Provider.of<AppData>(context, listen: false)
  //           .updatePassengerCount(passengerCount);
  //     }
  //   });
  // }
}
