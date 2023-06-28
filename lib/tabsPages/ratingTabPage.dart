import 'package:awesome_rating/awesome_rating.dart';
import 'package:flutter/material.dart';

import '../configMaps.dart';

class RatingTabPage extends StatefulWidget {
  const RatingTabPage({super.key});

  @override
  State<RatingTabPage> createState() => _RatingTabPageState();
}

class _RatingTabPageState extends State<RatingTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        child: Container(
          margin: EdgeInsets.all(4.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 22.0),
              const Text(
                'Your Rating',
                style: TextStyle(fontSize: 20.0, fontFamily: 'Brand-Bold',color: Colors.black),
              ),
              SizedBox(height: 22.0),
              const Divider(height: 2,thickness: 2,),
              SizedBox(height: 16.0),
              
              
              AwesomeStarRating(
                  starCount: 5,
                  allowHalfRating: true,
                  rating: starCounter,
                  size: 30.0,
                  isReadOnly: true,
                  color: Colors.green,
                  borderColor: Colors.orange,
                ),
              SizedBox(height: 14.0),
              
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Brand-Bold',
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16.0),
              
            ],
          ),
        ),
      ),
    );
  }
}
