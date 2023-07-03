import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:DriverApp/AllWidgets/HorizontalLine.dart';
import 'package:provider/provider.dart';

import 'dart:developer' as dev show log;

import '../AllWidgets/progressDialog.dart';
import '../Assistants/requestAssitant.dart';
import '../DataHandler/appData.dart';
import '../Models/address.dart';
import '../Models/placePredictions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();
  List<PlacePredictions> placePredictionList = [];

  @override
  Widget build(BuildContext context) {
    String placeAddress =
        Provider.of<AppData>(context).pickUpLocation.placeName ?? "";
    pickUpTextEditingController.text = placeAddress;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 180,
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
              padding: const EdgeInsets.only(
                left: 24,
                top: 20,
                right: 25,
                bottom: 20,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                      const Center(
                        child: Text(
                          "Set Drop Off",
                          style:
                              TextStyle(fontSize: 18, fontFamily: "Brand-Bold"),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "images/pickicon.png",
                        height: 16,
                        width: 16,
                      ),
                      const SizedBox(
                        width: 18,
                      ),
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
                                contentPadding: const EdgeInsets.only(
                                    left: 11, top: 8, bottom: 8),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "images/desticon.png",
                        height: 16,
                        width: 16,
                      ),
                      const SizedBox(
                        width: 18,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: TextField(
                              onChanged: (value) => {findPlace(value)},
                              controller: dropOffTextEditingController,
                              decoration: InputDecoration(
                                hintText: "Where to?",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.only(
                                    left: 11, top: 8, bottom: 8),
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
          ),

          const SizedBox(
            height: 10,
          ),
          // tile for predictions
          (placePredictionList.isNotEmpty)
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: SingleChildScrollView(
                    reverse: true,
                    child: ListView.separated(
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (context, index) {
                          return PredictionTile(
                            placePredictions: placePredictionList[index],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const HorizontalLine(),
                        itemCount: placePredictionList.length,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics()),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      // ignore: unused_local_variable
      String autoCompleteUrl =
          // "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$dotenv.env['mapkey']";
          "https://api.mapbox.com/search/searchbox/v1/suggest?q=${placeName}&access_token=pk.eyJ1IjoiaXNvYmVsMzVyYW10bzM1IiwiYSI6ImNsaWhiOTN2ZDBpcG0zanA1c3VxZDdkNjMifQ.CV3WZC4Jh9mzyz-XbpRm7A&session_token=[GENERATED-UUID]&language=en&country=in&types=country%2Cregion%2Cdistrict%2Cpostcode%2Clocality%2Cplace%2Cneighborhood%2Caddress%2Cpoi%2Cstreet%2Ccategory&proximity=72%2C23";
      var res = await RequestAssistant.getRequest(autoCompleteUrl);
      if (res == "failed") {
        return;
      }
      // if (res["status"] == "OK") {
      // var predictions = res["predictions"];
      var predictions = res["suggestions"];

      dev.log(predictions.toString());
      var placesList = (predictions as List<dynamic>)
          .map((e) => PlacePredictions.fromJson(e))
          .toList();
      setState(() {
        placePredictionList = placesList;
      });
      // print the placePredictionList to console

      // }
    }
  }
}

class PredictionTile extends StatelessWidget {
  final PlacePredictions placePredictions;

  const PredictionTile({Key? key, required this.placePredictions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(0)),
      ),
      onPressed: () {
        getPlaceAddressDetails(
          placePredictions.placeId ?? "getPlaceAddressDetails not found",
          context,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.add_location),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    placePredictions.place_formatted ??
                        "place_formatted not found",
                    overflow: TextOverflow.visible,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),

                  // Text(
                  //   placePredictions.neighborhood ?? "place_formatted is not found",
                  //   overflow: TextOverflow.ellipsis,
                  //   style: const TextStyle(fontSize: 12, color: Colors.grey),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetails(String placeId, context) async {
    showDialog(
        context: context,
        builder: (builder) => const ProgressDialog(
              message: "Setting Drop Off, Please wait...",
            ));
    String placeDetai1sUr1 =
        // "https://maps.googleapis.com/maps/api/place/details/json?place id=$placeId&key=$dotenv.env['mapkey']";
        "https://api.mapbox.com/search/searchbox/v1/retrieve/${placeId}?session_token=[GENERATED-UUID]&access_token=pk.eyJ1IjoiaXNvYmVsMzVyYW10bzM1IiwiYSI6ImNsaWhiOTN2ZDBpcG0zanA1c3VxZDdkNjMifQ.CV3WZC4Jh9mzyz-XbpRm7A";

    var res = await RequestAssistant.getRequest(placeDetai1sUr1);

    Navigator.pop(context);

    if (res == "failed") return;

    // if (res["status"] == "OK") {
    // Address address = Address();
    // address.placeName = res["result"]["name"];
    // address.placeId = placeId;
    // address.latitude = res["result"]["geometry"]["location"]["lat"];
    // address.longitude = res["result"]["geometry"]["location"]["lng"];

    // for mapbox
    Address address = Address();
    address.placeName =
        res["features"][0]["properties"]["name"] ?? "placeName not found";
    address.placeId = placeId;
    address.latitude = res["features"][0]["properties"]["coordinates"]
            ["latitude"] ??
        "latitude not found";
    address.longitude = res["features"][0]["properties"]["coordinates"]
            ["longitude"] ??
        "longitude not found";

    Provider.of<AppData>(context, listen: false)
        .updateUserDropOffLocationPlaceName(address);
    dev.log("This is drop off location searchScreen:: ");
    dev.log(address.placeName.toString());

    Navigator.pop(context, "obtainDirection");
  }
}
