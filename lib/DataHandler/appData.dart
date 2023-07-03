import 'package:flutter/foundation.dart';
import 'package:UserApp/Models/address.dart';

class AppData extends ChangeNotifier {
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
}
