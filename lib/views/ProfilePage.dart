import 'package:UserApp/configMaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'dart:developer' as dev show log;
import '../configMaps.dart';
import '../main.dart';

class ProfileTabPage extends StatelessWidget {
  const ProfileTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile Page'),
        ),
        backgroundColor: Color.fromARGB(221, 76, 68, 68),
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userCurrentInfo!.displayName!,
              style: const TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Signatra"),
            ),
            // Text(
            //   title + "User",
            //   style: const TextStyle(
            //     fontSize: 20,
            //     color: Colors.blueGrey,
            //     letterSpacing: 2.5,
            //     fontWeight: FontWeight.bold,
            //     fontFamily: "Signatra",
            //   ),
            // ),
            SizedBox(
              height: 20,
              width: 200,
              child: Divider(
                color: Colors.teal.shade100,
              ),
            ),
            SizedBox(height: 40),

            InfoCard(
              text: userCurrentInfo!.phoneNumber!,
              icon: Icons.phone,
              onPressed: () async {
                dev.log("This is phone");
              },
            ),

            InfoCard(
              text: userCurrentInfo!.email!,
              icon: Icons.email,
              onPressed: () async {
                dev.log("This is email");
              },
            ),

            // InfoCard(
            //   text: driversInformation!.car_color! + " "
            //   + driversInformation!.car_model! + " "
            //   + driversInformation!.car_number!,
            //   icon: Icons.car_repair,
            //   onPressed: () async {
            //     dev.log("This is car INfo");
            //   },
            // ),

            GestureDetector(
              onTap: () {
                // dev.log("This is logout");
                // Geofire.removeLocation(currentfirebaseUser!.uid);
                // usersRef.onDisconnect();
                // usersRef.remove();
                // usersRef = Null as DatabaseReference;

                FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, "/login/", (route) => false);
              },
              child: const Card(
                color: Colors.red,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 110),
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Sign Out",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Brand Bold",
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final void Function()? onPressed;
  const InfoCard({super.key, this.text, this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.black,
          ),
          title: Text(
            text!,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: "Brand Bold",
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
