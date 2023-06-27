import 'package:flutter/material.dart';
// import 'package:driver_app/configMaps.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as dev show log;
import '../DataHandler/appData.dart';

class EarningTabPage extends StatelessWidget {
  const EarningTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
                "\$${Provider.of<AppData>(context, listen: false).earnings}",
                style: TextStyle(
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
            dev.log("go to the history page");
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Image.asset(
                  "images/uberx.png",
                  width: 70,
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  "Cash out",
                  style: TextStyle(fontSize: 16),
                ),
                Expanded(
                  child: Container(
                      child: Text(
                    "5",
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 16),
                  )),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black54,
                ),
              ],
            ),
          )
          ),
          Divider(height: 2, color: Colors.black54, thickness: 2,)

    ]);
  }
}
