import 'dart:async';
// import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:DriverApp/Models/drivers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'Models/allUsers.dart';

const String mapkey = "AIzaSyCplMNadl9rrBQuY6QdCViRRVRqB3mxfzI";

User? firebaseUser; //= FirebaseAuth.instance.currentUser!;

Users? userCurrentInfo;

User? currentfirebaseUser;

final assetsAudioPlayer = AssetsAudioPlayer();

StreamSubscription<Position>? homeTabPageStreamSubscription;

StreamSubscription<Position>? rideStreamSubscription;

Position? currentPosition;

Drivers? driversInformation;

String title = "";
double starCounter = 0.0;
String driverStatusText = "Offline Now - Go Online ";
Color driverStatusColor = Colors.black;

String rideType = "";

int count = 0;
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
