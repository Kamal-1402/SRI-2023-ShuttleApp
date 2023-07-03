import 'package:UserApp/AllWidgets/HorizontalLine.dart';
import 'package:UserApp/Assistants/assitantMethods.dart';
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
        margin: const EdgeInsets.all(4.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 22.0),
            const Text(
              'Trip Fare',
              style: TextStyle(fontSize: 20.0, fontFamily: 'Brand-Bold'),
            ),
            const SizedBox(height: 22.0),
            const Divider(height: 2,thickness: 2,),
            const SizedBox(height: 16.0),
            Text(
              '$fareAmount ₹',
              style: const TextStyle(fontSize: 55.0, fontFamily: 'Brand-Bold'),
            ),
            const SizedBox(height: 16.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'This is the total amount, it has been charged to the rider',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context,"close");
                

                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(0.0),
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
                        'Pay Cash',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Icon(
                        Icons.payment,
                        color: Colors.white,
                        size: 26.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}
