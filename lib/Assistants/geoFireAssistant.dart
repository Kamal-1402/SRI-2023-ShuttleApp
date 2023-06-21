import '../Models/nearByAvailableDrivers.dart';

class GeoFireAssistant
{
  static List<NearByAvailableDrivers> nearByAvailableDriversList = [];
  static void removeDriverFromList(String key)
  {
    int index = nearByAvailableDriversList.indexWhere((element) => element.key == key);
    nearByAvailableDriversList.removeAt(index);
  }

  static void updateDriverNearbyLocation(NearByAvailableDrivers driver)
  {
    int index = nearByAvailableDriversList.indexWhere((element) => element.key == driver.key);
    nearByAvailableDriversList[index].longitude = driver.longitude;
    nearByAvailableDriversList[index].latitude = driver.latitude;
  }
}