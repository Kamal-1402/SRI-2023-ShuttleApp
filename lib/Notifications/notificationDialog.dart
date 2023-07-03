import 'package:DriverApp/Assistants/assitantMethods.dart';
import 'package:DriverApp/Models/ridedetails.dart';
import 'package:DriverApp/configMaps.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../views/newRideScreen.dart';

class NotificationDialog extends StatelessWidget {
  final RideDetails? rideDetails;
  const NotificationDialog({super.key, this.rideDetails});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.transparent,
      elevation: 1,
      child: Container(
        margin: const EdgeInsets.all(5),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 30,
            ),
            Image.asset(
              "images/taxi.jpg",
              width: 120,
            ),
            const SizedBox(
              height: 18,
            ),
            const Text(
              "New Ride Rquest",
              style: TextStyle(fontFamily: "Brand-Bold", fontSize: 18),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "images/pickicon.png",
                        height: 16,
                        width: 16,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Text(
                          rideDetails!.pickup_address!,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "images/desticon.png",
                        height: 16,
                        width: 16,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Text(
                          rideDetails!.dropoff_address!,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              height: 2,
              thickness: 2,
              color: Colors.black,
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    // style: TextButton.styleFrom(
                    //     // shape: RoundedRectangleBorder(
                    //     //   borderRadius: BorderRadius.circular(18.0),
                    //     //   side: BorderSide(color: Colors.red),
                    //     // ),
                    //     ),
                    onPressed: () {
                      assetsAudioPlayer.stop();
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "Cancel".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  TextButton(
                    // style: ElevatedButton.styleFrom(
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(18.0),
                    //     side: BorderSide(color: Colors.green),
                    //   ),
                    // ),
                    onPressed: () {
                      assetsAudioPlayer.stop();
                      checkAvailablityOfRide(context);
                      // Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "Accept".toUpperCase(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void checkAvailablityOfRide(context) {
    rideRequestRef.once().then((DatabaseEvent databaseEvent) {
      Navigator.pop(context);
      String? theRideId = "";
      if (databaseEvent.snapshot.value != null) {
        theRideId = databaseEvent.snapshot.value.toString();
      } else {
        displayToastMessage("Ride not exists", context);
      }
      if (theRideId == rideDetails!.ride_request_id) {
        rideRequestRef.set("accepted");
        AssistantMethods.disableHomeTabLiveLocationUpdates();
        // Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewRideScreen(rideDetails: rideDetails)));
      } else if (theRideId == "cancelled") {
        // Navigator.pop(context);
        displayToastMessage("Ride has been cancelled", context);
      } else if (theRideId == "timeout") {
        // Navigator.pop(context);
        displayToastMessage("Ride has timed out", context);
      } else {
        // Navigator.pop(context);
        displayToastMessage("Ride not exists", context);
      }
    });
  }
}

void displayToastMessage(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
  // Navigator.push(context,"somtuind");
}
