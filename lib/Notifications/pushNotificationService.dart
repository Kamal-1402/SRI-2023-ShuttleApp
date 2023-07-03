import 'dart:async';
// import 'dart:html';
import 'dart:developer' as dev show log;

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:DriverApp/Models/ridedetails.dart';
import 'package:DriverApp/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io' show Platform;
import '../configMaps.dart';
import 'notificationDialog.dart';

class PushNotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future initialize(context) async {
    // if (Platform.isIOS) {
    //   firebaseMessaging
    //       .requestNotificationPermissions(IosNotificationSettings());
    // }
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   dev.log('A new onMessageOpenedApp event was published!');
    //   retrieveRideRequestInfo(getRideRequestId(message.data), context);
    //   // Navigator.pushNamed(context, '/message',
    //   //     arguments: MessageArguments(message, true));
    // });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle the message
      retrieveRideRequestInfo(getRideRequestId(message.data), context);
    });
    // onLanuch
    // FirebaseMessaging.onBackgroundMessage((message) =>
    //     retrieveRideRequestInfo(getRideRequestId(message.data), context)
    //         as Future<void>);
    // onResum
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // Handle the message
      // getRideRequestId(message.data);
      retrieveRideRequestInfo(getRideRequestId(message.data), context);
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
  String getRideRequestId(Map<String, dynamic> message) {
    String rideRequestId = '';
    if (Platform.isAndroid) {
      rideRequestId = message['ride_request_id'];
      dev.log('ride_request_id: $rideRequestId', name: 'ride_request_id');
    } else {
      rideRequestId = message['ride_request_id'];
      dev.log('ride_request_id: $rideRequestId', name: 'ride_request_id');
    }
    return rideRequestId;
  }

  void retrieveRideRequestInfo(String rideRequestId, BuildContext context) {
    newRequestsRef
        .child(rideRequestId)
        .once()
        .then((DatabaseEvent databaseEvent) {
      if (databaseEvent.snapshot.value != null) {
        assetsAudioPlayer.open(
          Audio("sounds/alert.mp3"),
        );
        assetsAudioPlayer.play();
        double pickupLocationLat = double.parse(
            (databaseEvent.snapshot.value as Map)['pickup']['latitude']
                .toString());
        double pickupLocationLng = double.parse(
            (databaseEvent.snapshot.value as Map)['pickup']['longitude']
                .toString());
        String pickupAddress =
            (databaseEvent.snapshot.value as Map)['pickup_address'].toString();

        double dropOffLocationLat = double.parse(
            (databaseEvent.snapshot.value as Map)['dropoff']['latitude']
                .toString());
        double dropOffLocationLng = double.parse(
            (databaseEvent.snapshot.value as Map)['dropoff']['longitude']
                .toString());
        String dropOffAddress =
            (databaseEvent.snapshot.value as Map)['dropoff_address'].toString();

        String paymentMethod =
            (databaseEvent.snapshot.value as Map)['payment_method'].toString();

        String rider_name = (databaseEvent.snapshot.value as Map)['rider_name'];
        String rider_phone =
            (databaseEvent.snapshot.value as Map)['rider_phone'];

        RideDetails rideDetails = RideDetails();
        rideDetails.ride_request_id = rideRequestId;
        rideDetails.pickup_address = pickupAddress;
        rideDetails.dropoff_address = dropOffAddress;
        rideDetails.pickup = LatLng(pickupLocationLat, pickupLocationLng);
        rideDetails.dropoff = LatLng(dropOffLocationLat, dropOffLocationLng);
        rideDetails.payment_method = paymentMethod;
        rideDetails.rider_name = rider_name;
        rideDetails.rider_phone = rider_phone;

        dev.log('Information :: ', name: 'Information');
        // dev.log('ride_request_id: ${rideDetails.ride_request_id}', name: 'ride_request_id');
        dev.log(
            'pickup_address from pushnotification: ${rideDetails.pickup_address}',
            name: 'pickup_address');
        dev.log(
            'dropoff_address pushnotification: ${rideDetails.dropoff_address}',
            name: 'dropoff_address');

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => NotificationDialog(
            rideDetails: rideDetails,
          ),
        );
      }
    });
  }
}
