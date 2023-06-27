import 'package:flutter/foundation.dart';
import 'package:driver_app/Models/address.dart';

class AppData extends ChangeNotifier {
  String earnings = "0";
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

}
