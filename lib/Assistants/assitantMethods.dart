// import 'dart:js';
import 'dart:developer' as dev show log;
// import 'dart:http';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:latlng/latlng.dart';
import 'package:UserApp/Assistants/requestAssitant.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../DataHandler/appData.dart';
import '../Models/address.dart';
import '../Models/allUsers.dart';
import '../configMaps.dart';
import '../Models/directDetails.dart';

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
      placeAddress = response["features"][0]["text"];
      // st2 = response["features"][0]["context"][0]["text"];
      // st3 = response["features"][0]["context"][3]["text"];
      // st1 = response["results"][0]["address_components"][3]["long_name"];
      // st2 = response["results"][0]["address_components"][4]["long_name"];
      // st3 = response["results"][0]["address_components"][5]["long_name"];
      // st4 = response["results"][0]["address_components"][6]["long_name"];
      // placeAddress = "$st1"; 

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
    directionDetails.distanceText = route['distance'];
    directionDetails.durationText = route['duration'];

    directionDetails.durationValue = (route['duration']) / 60;
    directionDetails.distanceValue = (route['distance']) / 1000;
    return directionDetails;
  }

  static double calculateFares(DirectionDetails directionDetails) {
    // in terms of USD
    double timeTraveledFare = (directionDetails.durationText! / 60) * 0.20;
    double distanceTraveledFare =
        (directionDetails.distanceText! / 1000) * 0.20;
    double totalFareAmount = timeTraveledFare + distanceTraveledFare;
    // local currency
    // 1$ = 80 RS
    double totalLocalAmount = totalFareAmount * 80;

    // Extract first two digits after the decimal point
    String localAmountString = totalLocalAmount.toStringAsFixed(2);
    String firstTwoDigits = localAmountString.substring(
      localAmountString.indexOf('.') + 1,
      localAmountString.indexOf('.') + 3,
    );
    // dev.log("firstTwoDigits of the Rs: $firstTwoDigits");
    return double.parse(firstTwoDigits);
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

  static double createRandomNumber(int num) {
    var random = Random();
    int radNumber = random.nextInt(num);
    return radNumber.toDouble();
  }

  static sendNotificationToDriver(
      String token, context, String ride_request_id) async {
    var destination =
        Provider.of<AppData>(context, listen: false).dropOffLocation;
    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverToken!,
    };
    Map notificationMap = {
      'body': 'DropOff Address, ${destination.placeName}',
      'title': 'New Ride Request'
    };
    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'ride_request_id': ride_request_id
    };
    Map sendNotificationMap = {
      'notification': notificationMap,
      'data': dataMap,
      'priority': 'high',
      'to': token,
    };
    var res = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      // Uri.parse(
      // 'https://fcm.googleapis.com/v1/appshuttle-12d39/messages:send'),
      // 'https://fcm.googleapis.com/v1/project-861632027209/messages:send'),
      // https://fcm.googleapis.com/v1/projects/myproject-b5ae1/messages:send
      headers: headerMap,
      body: jsonEncode(sendNotificationMap),
    );
    dev.log(res.body);
  }
}
