import 'package:flutter/material.dart';
import 'package:DriverApp/views/MapPage.dart';
import 'dart:developer' as dev show log;
import 'package:firebase_auth/firebase_auth.dart';

// import 'package:learn_flutter/views/ProfilePage.dart';
// import 'package:learn_flutter/views/ProfilePage.dart';
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
          icon: const Icon(Icons.menu), // Hamburger icon
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
          onSelected: (String value) async {
            // Handle menu item selection here
            if (value == 'profile') {
              // Perform profile-related actions
              Navigator.pushNamed(context, '/Home/profile/');
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const ProfilePage()),
              // );
            } else if (value == 'logout') {
              // Perform logout action
              final shouldLogout = await showLogoutDialog(context);
              // dev.log(shouldLogout.toString());
              if (shouldLogout) {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login/', (route) => false);
              }
            } else if (value == 'other') {
              // Perform other actions
            }
          },
        ),
      ),
      body: showMap ? const MapPage() : Container(), // Conditional rendering
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showMap = !showMap; // Toggle the flag to show/hide the map
          });
          // Navigator.pushNamed(context, '/Home/MapPage/');
        },
        child: Icon(showMap ? Icons.close : Icons.map),
      ),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Dismiss dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Close dialog
            },
            child: const Text('Logout'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
