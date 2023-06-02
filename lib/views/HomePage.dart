import 'package:flutter/material.dart';
import 'package:learn_flutter/views/MapPage.dart';
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
          icon:const Icon(Icons.menu), // Hamburger icon
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
              Navigator.pushNamed(context, '/Home/profile/');
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const ProfilePage()),
              // );
            } else if (value == 'logout') {
              // Perform logout action
            } else if (value == 'other') {
              // Perform other actions
            }
          },
        ),
      ),
      body: showMap ?const MapPage() : Container(), // Conditional rendering
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
