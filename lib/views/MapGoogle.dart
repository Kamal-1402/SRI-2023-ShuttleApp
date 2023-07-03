import 'package:DriverApp/tabsPages/earningsTabPage.dart';
import 'package:DriverApp/tabsPages/homeTabPage.dart';
import 'package:DriverApp/tabsPages/ratingTabPage.dart';
import 'package:flutter/material.dart';

import '../AllWidgets/counter.dart';
import '../tabsPages/profileTabPage.dart';

class MapGoogle extends StatefulWidget {
  const MapGoogle({super.key});
  static const String idScreen = "MapGoogle";
  @override
  State<MapGoogle> createState() => _MapGoogleState();
}

class _MapGoogleState extends State<MapGoogle>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int selectedIndex = 0;

  void onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController.index = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [
            HomeTabPage(),
            CountWidget(),
            const EarningTabPage(),
            const RatingTabPage(),
            const ProfileTabPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: "Passengers",
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card),
              label: "Earnings",
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: "Rating",
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
              backgroundColor: Colors.black,
            ),
          ],
          unselectedIconTheme: const IconThemeData(color: Colors.black38),
          selectedIconTheme: const IconThemeData(color: Colors.yellow),
          selectedLabelStyle: const TextStyle(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          currentIndex: selectedIndex,
          onTap: onItemClicked,
        ),
      ),
    );
  }
}
