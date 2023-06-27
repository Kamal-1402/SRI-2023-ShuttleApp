import 'package:firebase_auth/firebase_auth.dart';

import 'Models/allUsers.dart';

const String mapkey = "AIzaSyCplMNadl9rrBQuY6QdCViRRVRqB3mxfzI";

User? firebaseUser; //= FirebaseAuth.instance.currentUser!;

Users? userCurrentInfo;

int driverRequestTimeOut = 40;
String statusRide = "";
String rideStatus = "Driver is Coming";
String carDetailsDriver = "";
String driverName = "";
String driverphone = "";

double starCounter = 0.0;
String title = "";
String carRideType = "";

String? serverToken =
    "key=AAAAyJ1FWkk:APA91bG9NBjMIzcr8ZJBhEplspbmLFY7DfH5ovKx9ZBwtmS9upq05dwunZezP2qQbT8LKgqANpSYnKKuY8mBU_h03E10dVHZLhXgJXrpnmAzqIQ9RcFs-SzhTt3bYJ-W2ioYqyjQ4zR9";
// config userConfig = config();
// void configureMap() {
//   userConfig.mapapikey = mapkey;
//   userConfig.firebaseUser = FirebaseAuth.instance.currentUser!;
// }

// class config {
//   static final config _instance = config._internal();

//   factory config() {
//     return _instance;
//   }

//   config._internal();
//   String? mapapikey;

//   User? firebaseUser;

//   Users? userCurrentInfo;
// }
