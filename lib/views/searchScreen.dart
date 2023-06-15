import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../DataHandler/appData.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {


    String placeAddress =Provider.of<AppData>(context).pickUpLocation.placeName ?? "";
    pickUpTextEditingController.text = placeAddress;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                ),
              ],
            ),

            child: Padding(
              padding: const EdgeInsets.only(left: 24,top: 20,right: 25,bottom: 20,),
              child: Column(
                children: [
                  const SizedBox(height: 5,),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child:const Icon(
                          Icons.arrow_back
                          ),
                      ),
                      const Center(
                        child: Text("Set Drop Off", style: TextStyle(fontSize: 18, fontFamily: "Brand-Bold"),),
                      )
                    ],
                  ),

                  const SizedBox(height: 16,),
                  Row(
                    children: [
                      Image.asset("images/pickicon.png", height: 16, width: 16,),
                      const SizedBox(width: 18,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextField(
                              controller: pickUpTextEditingController,
                              decoration: InputDecoration(
                                hintText: "Search Pick Up Location",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.only(left: 11,top: 8,bottom: 8),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Image.asset("images/desticon.png", height: 16, width: 16,),
                      const SizedBox(width: 18,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextField(
                              controller: dropOffTextEditingController,
                              decoration: InputDecoration(
                                hintText: "Where to?",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.only(left: 11,top: 8,bottom: 8),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
             ),



          )
        ],
      ),
    );
  }
}
