import 'dart:ffi';

import 'package:flutter/material.dart';

import '../configMaps.dart';
import '../main.dart';

class CarInfo extends StatelessWidget {
  CarInfo({super.key});

  static const String idScreen = "carInfo";
  final TextEditingController carNumberTextEditingController =
      TextEditingController();
  final TextEditingController carColorTextEditingController =
      TextEditingController();
  final TextEditingController carModelTextEditingController =
      TextEditingController();
  final TextEditingController carTypeTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Image.asset(
              "images/Shuttle.jpg",
              width: 390,
              height: 250,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 32),
              child: Column(
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    "Enter Shuttle Details",
                    style: TextStyle(fontFamily: "Brand Bold", fontSize: 24),
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  TextField(
                    controller: carModelTextEditingController,
                    decoration: const InputDecoration(
                      labelText: "Shuttle Model",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: carNumberTextEditingController,
                    decoration: const InputDecoration(
                      labelText: "Shuttle Number",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: carColorTextEditingController,
                    decoration: const InputDecoration(
                      labelText: "Shuttle Color",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: carTypeTextEditingController,
                    decoration: const InputDecoration(
                      labelText: "Shuttle Type",
                      hintText: "e.g. auto",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                        onPressed: () {
                          if (carModelTextEditingController.text.isEmpty) {
                            displayToastMessage(
                                "Please write Shuttle Model", context);
                          } else if (carNumberTextEditingController
                              .text.isEmpty) {
                            displayToastMessage(
                                "Please write Shuttle Number", context);
                          } else if (carColorTextEditingController
                              .text.isEmpty) {
                            displayToastMessage(
                                "Please write Shuttle Color", context);
                          } else if (carTypeTextEditingController
                              .text.isEmpty) {
                            displayToastMessage(
                                "Please write Shuttle Type", context);
                          } else {
                            saveDriverCarInfo(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.yellow,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Padding(
                            padding: EdgeInsets.all(17),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Next",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: "Brand Bold",
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                  size: 26,
                                ),
                              ],
                            ))),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  void saveDriverCarInfo(BuildContext context) {
    String userId = currentfirebaseUser!.uid;
    Map carInfoMap = {
      "car_color": carColorTextEditingController.text,
      "car_number": carNumberTextEditingController.text,
      "car_model": carModelTextEditingController.text,
      "type": carTypeTextEditingController.text,
    };
    driversRef.child(userId).child("car_details").set(carInfoMap);
    Navigator.pushNamedAndRemoveUntil(
        // context, "/Home/MapGoogle/", (route) => false);
        context,
        "/login/EmailVerify/",
        (route) => false);
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
