import 'package:driver_app/AllWidgets/HorizontalLine.dart';
import 'package:driver_app/Assistants/assitantMethods.dart';
import 'package:flutter/material.dart';

class CollectFareDialog extends StatelessWidget {
  final String? paymentMethod;
  final double? fareAmount;
  const CollectFareDialog({super.key, this.paymentMethod, this.fareAmount});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      child: Container(
        margin: EdgeInsets.all(4.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 22.0),
            Text(
              'Trip Fare',
              style: TextStyle(fontSize: 20.0, fontFamily: 'Brand-Bold'),
            ),
            SizedBox(height: 22.0),
            HorizontalLine(),
            SizedBox(height: 16.0),
            Text(
              '\$$fareAmount',
              style: TextStyle(fontSize: 55.0, fontFamily: 'Brand-Bold'),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'This is the total amount, it has been charged to the rider',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);

                  AssistantMethods.enableHomeTabLiveLocationUpdates();
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0.0),
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(17.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Collect Cash',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Icon(
                        Icons.attach_money,
                        color: Colors.white,
                        size: 26.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}
