import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NoDriverAvailableDialog extends StatelessWidget {
  const NoDriverAvailableDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding:const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 6.0),
              const Text(
                "No Driver found nearby",
                style: TextStyle(fontSize: 22.0, fontFamily: "Brand-Bold"),
              ),
              const SizedBox(height: 22.0),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "No available driver close by, we suggest you try again shortly",
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 22.0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(17.0),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "CLOSE",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.car_repair,
                            color: Colors.white, size: 26.0),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
