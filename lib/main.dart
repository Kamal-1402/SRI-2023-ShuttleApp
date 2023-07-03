import 'package:DriverApp/configMaps.dart';
import 'package:DriverApp/views/carInfo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:DriverApp/DataHandler/appData.dart';
import 'package:DriverApp/firebase_options.dart';
import 'package:DriverApp/views/EmailVerify.dart';
import 'package:DriverApp/views/HomePage.dart';
import 'package:DriverApp/views/MapGoogle.dart';
import 'package:DriverApp/views/MapPage.dart';
import 'package:DriverApp/views/ProfilePage.dart';
import 'package:DriverApp/views/RegisterPage.dart';
import 'package:DriverApp/views/loginPage.dart';
import 'package:DriverApp/UI/map_base.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as dev show log;

// import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// import 'package:flutter_map/plugin_api.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await DotEnv().load();

  currentfirebaseUser = FirebaseAuth.instance.currentUser;

  runApp(const MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");
DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
DatabaseReference newRequestsRef =
    FirebaseDatabase.instance.ref().child("Ride Requests");
DatabaseReference rideRequestRef = FirebaseDatabase.instance
    .ref()
    .child("drivers")
    .child(currentfirebaseUser!.uid)
    .child("newRide");

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppData>(
      create: (context) => AppData(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Driver App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            // useMaterial3: true,
          ),
          // home: const Authentication(),
          home: FirebaseAuth.instance.currentUser == null
              ? const Authentication()
              : const MapGoogle(),
          // home:const EmailVerify(),
          // home:const HomePage(),
          // home: const MapGoogle(),
          // home: const RegisterPage(),
          // home: MapBase(),

          routes: {
            "/login/": (context) => const loginPage(),
            "/register/": (context) => const RegisterPage(),
            "/login/EmailVerify/": (context) => const EmailVerify(),
            "/Home/": (context) => const HomePage(),
            "/Home/profile/": (context) => const ProfilePage(),
            "/Home/MapPage/": (context) => const MapPage(),
            // "/api/search/": (context) => MapBase(),
            "/Home/MapGoogle/": (context) => const MapGoogle(),
            "/Register/CarInfo/": (context) => CarInfo(),
          }),
    );
  }
}

class Authentication extends StatelessWidget {
  const Authentication({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final CurrUser = FirebaseAuth.instance.currentUser;
            if (CurrUser == null) {
              dev.log("user not found");
              return SafeArea(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("images/bike.png"),
                        SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "WELCOME",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 26),
                        const Text(
                          "Please Login",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login/', (route) => false);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );

              // SafeArea(
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Center(
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           const Text("you are not logged in"),
              //           TextButton(
              //             onPressed: () {
              //               Navigator.of(context).pushNamedAndRemoveUntil(
              //                   '/login/', (route) => false);

              //               // const EmailVerify();
              //             },
              //             child: const Text('click here to login'),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // );

              // return const loginPage();
            }
            if (CurrUser.emailVerified) {
              dev.log("you are verified");
              dev.log(CurrUser.toString());

              // go and attach the other pages here
              // return const HomePage();
              return const MapGoogle();
            } else {
              dev.log("you are not email verified");
              dev.log(CurrUser.toString());

              return Column(
                children: [
                  const Text("you are not email verified"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login/EmailVerify/');
                      // Navigator.of(context).pushNamedAndRemoveUntil(
                      //     '/login/EmailVerify/', (route) => false);

                      // const EmailVerify();
                    },
                    child: const Text('click here to verify your email'),
                  ),
                ],
              );
            }

          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}



// import 'package:flutter_map/src/layer/tile_layer.dart';


