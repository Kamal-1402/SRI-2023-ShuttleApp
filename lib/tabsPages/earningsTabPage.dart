import 'package:flutter/material.dart';
// import 'package:DriverApp/configMaps.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as dev show log;
import '../DataHandler/appData.dart';
import '../views/HistoryScreen.dart';

class EarningTabPage extends StatelessWidget {
  const EarningTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(children: [
        Container(
          color: Colors.black54,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 70),
            child: Column(
              children: [
                const Text(
                  "Total Earnings",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "${Provider.of<AppData>(context, listen: false).earnings} ₹",
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 50,
                    fontFamily: "Brand Bold",
                  ),
                ),
              ],
            ),
          ),
        ),
        TextButton(
            onPressed: () {
              // dev.log("go to the history page");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HistoryScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: Row(
                children: [
                  Image.asset(
                    "images/bike.png",
                    width: 50,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Text(
                    "Trip History",
                    style: TextStyle(fontSize: 16),
                  ),
                  Expanded(
                    child: Text(
                      "Last Rides",
                      // Provider.of<AppData>(context, listen: false)
                      //       .countTrips
                      //     .toString(),
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.black54,
                  ),
                ],
              ),
            )),
        const Divider(
          height: 2,
          color: Colors.black54,
          thickness: 2,
        )
      ]),
    );
  }
}
