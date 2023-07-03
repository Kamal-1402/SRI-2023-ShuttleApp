import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:UserApp/DataHandler/appData.dart';
import 'package:UserApp/firebase_options.dart';
import 'package:UserApp/views/EmailVerify.dart';
import 'package:UserApp/views/HomePage.dart';
import 'package:UserApp/views/MapGoogle.dart';
import 'package:UserApp/views/MapPage.dart';
import 'package:UserApp/views/ProfilePage.dart';
import 'package:UserApp/views/RegisterPage.dart';
import 'package:UserApp/views/loginPage.dart';
import 'package:UserApp/UI/map_base.dart';
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

  runApp(const MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");
DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppData>(
      create: (context) => AppData(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            // useMaterial3: true,
          ),
          // home: const Authentication(),
          home: FirebaseAuth.instance.currentUser == null
              ? const loginPage()
              : const MapGoogle(),
          // home:const EmailVerify(),
          // home:const HomePage(),
          // home: const MapGoogle(),
          // home: const RegisterPage(),
          // home:loginPage(),
          // home: MapBase(),

          routes: {
            "/login/": (context) => const loginPage(),
            "/register/": (context) => const RegisterPage(),
            "/login/EmailVerify/": (context) => const EmailVerify(),
            "/Home/": (context) => const HomePage(),
            "/Home/profile/": (context) => const ProfileTabPage(),
            "/Home/MapPage/": (context) => const MapPage(),
            // "/api/search/": (context) => MapBase(),
            "/Home/MapGoogle/": (context) => const MapGoogle(),
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
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text("you are not logged in"),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login/', (route) => false);

                          // const EmailVerify();
                        },
                        child: const Text('click here to login'),
                      ),
                    ],
                  ),
                ),
              );

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


