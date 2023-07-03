import 'package:awesome_rating/awesome_rating.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:UserApp/AllWidgets/HorizontalLine.dart';
import 'package:UserApp/Assistants/assitantMethods.dart';
import 'package:flutter/material.dart';
import 'package:UserApp/configMaps.dart';

class RatingScreen extends StatefulWidget {
  final String? driverId;
  RatingScreen({this.driverId});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          child: Container(
            margin: const EdgeInsets.all(4.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 22.0),
                const Text(
                  'Rate This Driver',
                  style: TextStyle(fontSize: 20.0, fontFamily: 'Brand-Bold',color: Colors.black),
                ),
                const SizedBox(height: 22.0),
                const Divider(height: 2,thickness: 2,),
                const SizedBox(height: 16.0),
                
                
                AwesomeStarRating(
                    starCount: 5,
                    allowHalfRating: false,
                    rating: starCounter,
                    size: 30.0,
                    onRatingChanged: (double value){
                      setState((){
                        starCounter = value;
                          if(starCounter == 1){
                            title = "Very Bad";
                          }
                          if(starCounter == 2){
                            title = "Bad";
                          }
                          if(starCounter == 3){
                            title = "Good";
                          }
                          if(starCounter == 4){
                            title = "Very Good";
                          }
                          if(starCounter == 5){
                            title = "Excellent";
                          }
                      });
                    },
                    color: Colors.green,
                    borderColor: Colors.orange,
                  ),
                const SizedBox(height: 14.0),
                
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Brand-Bold',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextButton(
                    onPressed: () {
                      DatabaseReference driverRatingRef = FirebaseDatabase.instance
                          .ref()
                          .child('drivers')
                          .child(widget.driverId!)
                          .child('ratings');
                      driverRatingRef.once().then((DatabaseEvent databaseEvent) {
                        if (databaseEvent.snapshot.value != null) {
                          double oldRatings = double.parse(databaseEvent.snapshot.value.toString());
                          double addRatings = oldRatings + starCounter;
                          double averageRatings = addRatings / 2;
                          driverRatingRef.set(averageRatings.toString());
                        } else {
                          driverRatingRef.set(starCounter.toString());
                        }
                      });
                      Navigator.pop(context);
      
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(0.0),
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(17.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Submit',
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 26.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
