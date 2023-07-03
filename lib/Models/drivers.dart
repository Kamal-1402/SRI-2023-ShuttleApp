import 'package:firebase_database/firebase_database.dart';

class Drivers {
  String? displayName;
  String? email;
  String? phoneNumber;
  String? id;
  String? car_color;

  String? car_model;

  String? car_number;

  Drivers({
    this.displayName,
    this.email,
    this.phoneNumber,
    this.id,
    this.car_color,
    this.car_model,
    this.car_number,
  });

  // Drivers.fromSnapshot(dynamic snapshot) {
  //   id = snapshot.key;
  //   displayName = snapshot.value['displayName'];
  //   email = snapshot.value['email'];
  //   phoneNumber = snapshot.value['phoneNumber'];
  //   car_color = snapshot.value['car_details']['car_color'];
  //   car_model = snapshot.value['car_details']['car_model'];
  //   car_number = snapshot.value['car_details']['car_number'];
  // }
  Drivers.fromSnapshot(DataSnapshot snapshot)
      : id = (snapshot.key),
        displayName = (snapshot.value as Map)['displayName'],
        email = (snapshot.value as Map)['email'],
        phoneNumber = (snapshot.value as Map)['phoneNumber'],
        car_color = (snapshot.value as Map)['car_details']['car_color'],
        car_model = (snapshot.value as Map)['car_details']['car_model'],
        car_number = (snapshot.value as Map)['car_details']['car_number'];

  // Users.fromSnapshot(DataSnapshot snapshot)
  //   : displayName = (snapshot.value as Map)['displayName'],
  //     email = (snapshot.value as Map)['email'],
  //     phoneNumber = (snapshot.value as Map)['phoneNumber'],
  //     uid = (snapshot.value as Map)['uid'];
}
