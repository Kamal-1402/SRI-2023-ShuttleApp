import 'package:flutter/foundation.dart';
import 'package:DriverApp/Models/address.dart';

import '../Models/history.dart';

class AppData extends ChangeNotifier {
  String earnings = "0";
  int countTrips = 0;
  List<String> tripHistoryKeys = [];
  List<History> tripHistoryDataList = [];
  Address pickUpLocation = Address();
  Address dropOffLocation = Address();
  // String? _userCurrentLocationPlaceName;
  // String? get userCurrentLocationPlaceName => _userCurrentLocationPlaceName;
  void updateUserDropOffLocationPlaceName(Address newDroplocation) {
    dropOffLocation = newDroplocation;
    notifyListeners();
  }

  // void updateUserCurrentLocationPlaceName(String newLocationPlaceName) {
  //   _userCurrentLocationPlaceName = newLocationPlaceName;
  //   notifyListeners();
  // }

  void updatePickUpLocationAddress(Address newPickUpAddress) {
    pickUpLocation = newPickUpAddress;
    notifyListeners();
  }

  void updateEarnings(String updatedEarnings) {
    earnings = updatedEarnings;
    notifyListeners();
  }

  void updateTripsCounter(int tripCounter) {
    countTrips = tripCounter;
    notifyListeners();
  }

  void updateTripKeys(List<String> newKeys) {
    tripHistoryKeys = newKeys;
    notifyListeners();
  }

  void updateTripHistoryData(History eachHistory) {
    tripHistoryDataList.add(eachHistory);
    notifyListeners();
  }
}
