import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

import 'Models/allUsers.dart';

const String mapkey = "AIzaSyCplMNadl9rrBQuY6QdCViRRVRqB3mxfzI";

User? firebaseUser; //= FirebaseAuth.instance.currentUser!;

Users? userCurrentInfo;

User? currentfirebaseUser;

StreamSubscription<Position>? homeTabPageStreamSubscription;

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
