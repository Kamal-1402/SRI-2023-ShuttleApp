import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// 'displayName': userCredential.user!.displayName!.trim(),
                            // 'email': userCredential.user!.email!.trim(),
                            // 'phoneNumber':
class Users
{
  late String? displayName="displayName";
  late String? email="email";
  late String? phoneNumber="phoneNumber";
  late String? uid;
  // String tempdisplayname = "tempdisplayname";
  // String tempemail = "tempemail";
  // String tempphonenumber = "tempphonenumber";
  // String tempuid = "tempuid";
  Users({
    this.displayName,
    this.email,
    this.phoneNumber,
    this.uid,
  });
 

  // Users.fromSnapshot(DataSnapshot snapshot)
  //     : displayName = snapshot.value?['displayName'], 
  //       email = snapshot.value?['email'] ,
  //       phoneNumber = snapshot.value?['phoneNumber'] ,
  //       uid = snapshot.value?['uid' ] ;
  //   Users.fromSnapshot(DataSnapshot snapshot)
  //   : displayName = (snapshot.value as Map<String, dynamic>?)?['displayName'],
  //     email = (snapshot.value as Map<String, dynamic>?)?['email'],
  //     phoneNumber = (snapshot.value as Map<String, dynamic>?)?['phoneNumber'],
  //     uid = (snapshot.value as Map<String, dynamic>?)?['uid'];

     Users.fromSnapshot(DataSnapshot snapshot)
    : displayName = (snapshot.value as Map)['displayName'],
      email = (snapshot.value as Map)['email'],
      phoneNumber = (snapshot.value as Map)['phoneNumber'],
      uid = (snapshot.value as Map)['uid']; 

}