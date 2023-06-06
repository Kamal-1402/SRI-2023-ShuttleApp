import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learn_flutter/firebase_options.dart';
import 'package:learn_flutter/views/EmailVerify.dart';
import 'package:learn_flutter/views/HomePage.dart';
import 'package:learn_flutter/views/MapPage.dart';
import 'package:learn_flutter/views/ProfilePage.dart';
import 'package:learn_flutter/views/RegisterPage.dart';
import 'package:learn_flutter/views/loginPage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as dev show log;


import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await DotEnv().load();

  runApp(
    MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          // useMaterial3: true,
        ),
        // home: const Authentication(),
        home: const MapPage(),

        routes: {
          "/login/": (context) => const loginPage(),
          "/register/": (context) => const RegisterPage(),
          "/login/EmailVerify/": (context) => const EmailVerify(),
          "/Home/": (context) => const HomePage(),
          "/Home/profile/": (context) => const ProfilePage(),
          "/Home/MapPage/": (context) => const MapPage(),
        }),
  );
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
              return Column(
                children: [
                  const Text("you are not logged in"),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/login/', (route) => false);

                      // const EmailVerify();
                    },
                    child: const Text('click here to login'),
                  ),
                ],
              );

              // return const loginPage();
            }
            if (CurrUser.emailVerified) {
              dev.log("you are verified");
              dev.log(CurrUser.toString());

              // go and attach the other pages here
              return const HomePage();
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


