import 'package:driver_app/Models/ridedetails.dart';
import 'package:flutter/material.dart';

class NotificationDialog extends StatelessWidget {
  final RideDetails? rideDetails;
  const NotificationDialog({super.key,this.rideDetails});
  
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
            SizedBox(
              height: 30,
            ),
            Image.asset(
              "images/taxi.png",
              width: 120,
            ),
            SizedBox(
              height: 18,
            ),
            Text(
              "New Ride Rquest",
              style: TextStyle(fontFamily: "Brand-Bold", fontSize: 18),
            ),
            SizedBox(
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
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            rideDetails!.pickup_address!,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
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
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            rideDetails!.dropoff_address!,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              height: 2,
              thickness: 2,
              color: Colors.black,
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton (
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        "Cancel".toUpperCase(),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        "Accept".toUpperCase(),
                        style: TextStyle(
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
              height: 10,),
          ],
        ),
      ),
    );
  }
}
