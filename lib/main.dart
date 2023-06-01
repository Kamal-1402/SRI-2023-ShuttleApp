import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learn_flutter/firebase_options.dart';
import 'package:learn_flutter/views/EmailVerify.dart';
import 'package:learn_flutter/views/MapPage.dart';
import 'package:learn_flutter/views/RegisterPage.dart';
import 'package:learn_flutter/views/loginPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(
    MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          // useMaterial3: true,
        ),
        home: const Authentication(),
        routes: {
          "/login/": (context) => const loginPage(),
          "/register/": (context) => const RegisterPage(),
          "/login/EmailVerify/": (context) => const EmailVerify(),
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
              print("user not found");
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
              print("you are verified");
              print(CurrUser);

              // go and attach the other pages here
              return const HomePage();
            } else {
              print("you are not email verified");
              print(CurrUser);

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showMap = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        leading: PopupMenuButton<String>(
          icon: Icon(Icons.menu), // Hamburger icon
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'profile',
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'logout',
              child: ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'other',
              child: ListTile(
                leading: Icon(Icons.menu),
                title: Text('Other'),
              ),
            ),
          ],
          onSelected: (String value) {
            // Handle menu item selection here
            if (value == 'profile') {
              // Perform profile-related actions
            } else if (value == 'logout') {
              // Perform logout action
            } else if (value == 'other') {
              // Perform other actions
            }
          },
        ),
      ),
      body: showMap ? MapPage() : Container(), // Conditional rendering
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showMap = !showMap; // Toggle the flag to show/hide the map
          });
        },
        child: Icon(showMap ? Icons.close : Icons.map),
      ),
    );
  }
}

