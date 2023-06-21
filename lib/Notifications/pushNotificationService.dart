import 'dart:async';
// import 'dart:html';
import 'dart:developer' as dev show log;

import 'package:driver_app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../configMaps.dart';

class PushNotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future initialise() async {
    // if (Platform.isIOS) {
    //   firebaseMessaging
    //       .requestNotificationPermissions(IosNotificationSettings());
    // }
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle the message
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle the message
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle the message
    });

    // firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print('onMessage: $message');
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print('onLaunch: $message');
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print('onResume: $message');
    //   },
    // );
  }

  Future<String> getToken() async {
    String? token = await firebaseMessaging.getToken();
    dev.log("this is the token: $token", name: 'token');
    driversRef.child(currentfirebaseUser!.uid).child('token').set(token);
    firebaseMessaging.subscribeToTopic('alldrivers');
    firebaseMessaging.subscribeToTopic('allusers');
    return token ?? 'token is not available form pushNotificationService.dart';
  }

  // void _showItemDialog(Map<String, dynamic> message) {
  //   final notification = message['notification'];
  //   final data = message['data'];
  //   final String title = notification['title'];
  //   final String body = notification['body'];
  //   final String mMessage = data['message'];
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       content: ListTile(
  //         title: Text(title),
  //         subtitle: Text(mMessage),
  //       ),
  //       actions: <Widget>[
  //         FlatButton(
  //           child: Text('Ok'),
  //           onPressed: () => Navigator.of(context).pop(),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void _navigateToItemDetail(Map<String, dynamic> message) {
  //   final notification = message['notification'];
  //   final data = message['data'];
  //   final String title = notification['title'];
  //   final String mMessage = data['message'];
  //   Navigator.pushNamed(context, '/item',
  //       arguments: ItemArguments(item: Item(title, mMessage)));
  // }
}
