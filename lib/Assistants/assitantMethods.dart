// import 'dart:js';

import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:latlng/latlng.dart';
import 'package:learn_flutter/Assistants/requestAssitant.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../DataHandler/appData.dart';
import '../Models/address.dart';
import '../Models/directDetails.dart';
// import '../Models/configMaps.dart' as config show mapKey;

class AssistantMethods {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = "";
    String st1, st2, st3, st4;
    String url =
        // "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$dotenv.env['mapkey']";
        "https://api.mapbox.com/geocoding/v5/mapbox.places/${position.longitude},${position.latitude}.json?access_token=pk.eyJ1IjoiaXNvYmVsMzVyYW10bzM1IiwiYSI6ImNsaWhiOTN2ZDBpcG0zanA1c3VxZDdkNjMifQ.CV3WZC4Jh9mzyz-XbpRm7A";
    var response = await RequestAssistant.getRequest(url);

    if (response != "failed") {
      placeAddress = response["features"][0]["place_name"];
      // st1 = response["results"][0]["address_components"][3]["long_name"];
      // st2 = response["results"][0]["address_components"][4]["long_name"];
      // st3 = response["results"][0]["address_components"][5]["long_name"];
      // st4 = response["results"][0]["address_components"][6]["long_name"];
      // placeAddress = st1 + ", " + st2 + ", " + st3 + ", " + st4;

      Address userPickUpAddress = Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }
    return placeAddress;
  }

  static Future<DirectionDetails?> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        // "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$dotenv.env['mapKey']";
        // "https://api.mapbox.com/directions/v5/mapbox/driving/${initialPosition.longitude},${finalPosition.longitude};${initialPosition.latitude},${finalPosition.latitude}?steps=true&voice_instructions=true&banner_instructions=true&voice_units=imperial&access_token=pk.eyJ1IjoiaXNvYmVsMzVyYW10bzM1IiwiYSI6ImNsaWhiOTN2ZDBpcG0zanA1c3VxZDdkNjMifQ.CV3WZC4Jh9mzyz-XbpRm7A";
        "https://api.mapbox.com/directions/v5/mapbox/driving/${initialPosition.longitude},${initialPosition.latitude};${finalPosition.longitude},${finalPosition.latitude}?alternatives=false&annotations=distance&geometries=polyline&language=en&overview=full&steps=true&voice_instructions=true&banner_instructions=true&voice_units=imperial&access_token=pk.eyJ1IjoiaXNvYmVsMzVyYW10bzM1IiwiYSI6ImNsaWhiOTN2ZDBpcG0zanA1c3VxZDdkNjMifQ.CV3WZC4Jh9mzyz-XbpRm7A";
    var res = await RequestAssistant.getRequest(directionUrl);
    if (res == "failed") {
      return null;
    }
    // Map<String, dynamic> data = json.decode(res);
    if (res['routes'] == null || res['routes'].isEmpty) {
      return null;
    }
    Map<String, dynamic> route = res['routes'][0];
    DirectionDetails directionDetails = DirectionDetails();
    // directionDetails.encodedPoints =
    //     res["routes"][0]["overview_polyline"]["points"];
    // directionDetails.distanceText =
    //     res["routes"][0]["legs"][0]["distance"]["text"];
    // directionDetails.distanceValue =
    //     res["routes"][0]["legs"][0]["distance"]["value"];
    // directionDetails.durationText =
    //     res["routes"][0]["legs"][0]["duration"]["text"];
    // directionDetails.durationValue =
    //     res["routes"][0]["legs"][0]["duration"]["value"];

    directionDetails.encodedPoints = route['geometry'];
    directionDetails.distanceText = route['distance'];
    directionDetails.durationText = route['duration'];
    directionDetails.durationValue = (route['duration']) / 60;
    directionDetails.distanceValue = (route['distance']) / 1000;
    return directionDetails;
  }
    static double calculateFares(DirectionDetails directionDetails) {
    // in terms of USD
    double timeTraveledFare = (directionDetails.durationValue !/ 60) * 0.20;
    double distanceTraveledFare =
        (directionDetails.distanceValue !/ 1000) * 0.20;
    double totalFareAmount = timeTraveledFare + distanceTraveledFare;
    // local currency
    // 1$ = 80 RS
    // double totalLocalAmount = totalFareAmount * 80;
    return totalFareAmount.truncateToDouble();
  }

}



// {
//     "routes": [
//       {
//         "weight_name": "auto",
//         "weight": 549.625,
//         "duration": 373.096,
//         "distance": 2594.257,
//         "legs": [
//           {
//             "via_waypoints": [],
//             "annotation": {
//               "distance": [
//                 19.5,
//                 83,
//                 18.6,
//                 18.9,
//                 16,
//                 9.5,
//                 8.4,
//                 25.1,
//                 89.1,
//                 16.9,
//                 13.9,
//                 11.1,
//                 64.5,
//                 14.1,
//                 41.1,
//                 33.5,
//                 12.5,
//                 16.1,
//                 13.7,
//                 19.3,
//                 20.7,
//                 43.6,
//                 35.2,
//                 25.3,
//                 6,
//                 8.8,
//                 17.7,
//                 25,
//                 0.2,
//                 19,
//                 1.3,
//                 17.9,
//                 61.9,
//                 6,
//                 16.3,
//                 16.5,
//                 64,
//                 30.1,
//                 20.6,
//                 20.4,
//                 16.3,
//                 35,
//                 6.6,
//                 8,
//                 22.4,
//                 18.9,
//                 0.2,
//                 13.6,
//                 11.3,
//                 8.1,
//                 8.3,
//                 11.4,
//                 10.9,
//                 4.8,
//                 4.9,
//                 14.2,
//                 5.7,
//                 5.4,
//                 5.1,
//                 5.8,
//                 5.1,
//                 4.6,
//                 2.9,
//                 13.7,
//                 38.8,
//                 26.3,
//                 18.9,
//                 12.6,
//                 102.3,
//                 0.7,
//                 33,
//                 49.9,
//                 5.6,
//                 9,
//                 10,
//                 92,
//                 17,
//                 14.2,
//                 7.9,
//                 5.2,
//                 9,
//                 9.1,
//                 100.6,
//                 18.5,
//                 100.1,
//                 3.1,
//                 13.7,
//                 22.9,
//                 35.1,
//                 57.7,
//                 19.1,
//                 7.3,
//                 152.3,
//                 8.1,
//                 8.3,
//                 11.4,
//                 34.4,
//                 51.8,
//                 1.4,
//                 54.8,
//                 7.8,
//                 45.8,
//                 134.1
//               ]
//             },
//             "admins": [{"iso_3166_1_alpha3": "USA", "iso_3166_1": "US"}],
//             "weight": 549.625,
//             "duration": 373.096,
//             "steps": [
//               {
//                 "bannerInstructions": [
//                   {
//                     "primary": {
//                       "components": [{"type": "text", "text": "Paul Amico Way"}],
//                       "type": "turn",
//                       "modifier": "left",
//                       "text": "Paul Amico Way"
//                     },
//                     "distanceAlongGeometry": 669.6
//                   }
//                 ],
//                 "voiceInstructions": [
//                   {
//                     "ssmlAnnouncement": "<speak><amazon:effect name=\"drc\"><prosody rate=\"1.08\">Drive south on <say-as interpret-as=\"address\">Castle Road</say-as> for a half mile.</prosody></amazon:effect></speak>",
//                     "announcement": "Drive south on Castle Road for a half mile.",
//                     "distanceAlongGeometry": 669.6
//                   },
//                   {
//                     "ssmlAnnouncement": "<speak><amazon:effect name=\"drc\"><prosody rate=\"1.08\">In a quarter mile, Turn left onto <say-as interpret-as=\"address\">Paul Amico Way</say-as>.</prosody></amazon:effect></speak>",
//                     "announcement": "In a quarter mile, Turn left onto Paul Amico Way.",
//                     "distanceAlongGeometry": 402.336
//                   },
//                   {
//                     "ssmlAnnouncement": "<speak><amazon:effect name=\"drc\"><prosody rate=\"1.08\">Turn left onto <say-as interpret-as=\"address\">Paul Amico Way</say-as>.</prosody></amazon:effect></speak>",
//                     "announcement": "Turn left onto Paul Amico Way.",
//                     "distanceAlongGeometry": 88.889
//                   }
//                 ],
//                 "intersections": [
//                   {
//                     "entry": [true],
//                     "bearings": [162],
//                     "duration": 8.022,
//                     "mapbox_streets_v8": {"class": "tertiary"},
//                     "is_urban": false,
//                     "admin_index": 0,
//                     "out": 0,
//                     "weight": 8.022,
//                     "geometry_index": 0,
//                     "location": [-74.080395, 40.768843]
//                   },
//                   {
//                     "entry": [true, true, false],
//                     "in": 2,
//                     "bearings": [70, 154, 334],
//                     "duration": 1.574,
//                     "turn_weight": 0.75,
//                     "turn_duration": 0.019,
//                     "mapbox_streets_v8": {"class": "tertiary"},
//                     "is_urban": false,
//                     "admin_index": 0,
//                     "out": 1,
//                     "weight": 2.305,
//                     "geometry_index": 2,
//                     "location": [-74.079891, 40.768007]
//                   },
//                   {
//                     "entry": [true, true, false],
//                     "in": 2,
//                     "bearings": [68, 153, 334],
//                     "duration": 13.537,
//                     "turn_weight": 0.75,
//                     "turn_duration": 0.019,
//                     "mapbox_streets_v8": {"class": "tertiary"},
//                     "is_urban": false,
//                     "admin_index": 0,
//                     "out": 1,
//                     "weight": 14.268,
//                     "geometry_index": 3,
//                     "location": [-74.079793, 40.767857]
//                   },
//                   {
//                     "entry": [true, true, false],
//                     "in": 2,
//                     "bearings": [37, 143, 312],
//                     "duration": 1.971,
//                     "turn_weight": 1.125,
//                     "turn_duration": 0.014,
//                     "mapbox_streets_v8": {"class": "tertiary"},
//                     "is_urban": false,
//                     "admin_index": 0,
//                     "out": 1,
//                     "weight": 3.13,
//                     "geometry_index": 10,
//                     "location": [-74.07828, 40.766691]
//                   },
//                   {
//                     "entry": [true, true, false],
//                     "in": 2,
//                     "bearings": [68, 147, 323],
//                     "duration": 5.451,
//                     "turn_weight": 0.75,
//                     "turn_duration": 0.009,
//                     "mapbox_streets_v8": {"class": "tertiary"},
//                     "is_urban": false,
//                     "admin_index": 0,
//                     "out": 1,
//                     "weight": 6.328,
//                     "geometry_index": 12,
//                     "location": [-74.078101, 40.766512]
//                   },
//                   {
//                     "entry": [true, true, false],
//                     "in": 2,
//                     "bearings": [56, 147, 327],
//                     "duration": 1.345,
//                     "turn_weight": 0.75,
//                     "turn_duration": 0.019,
//                     "mapbox_streets_v8": {"class": "tertiary"},
//                     "is_urban": false,
//                     "admin_index": 0,
//                     "out": 1,
//                     "weight": 2.109,
//                     "geometry_index": 13,
//                     "location": [-74.07768, 40.766028]
//                   },
//                   {
//                     "entry": [true, true, false],
//                     "in": 2,
//                     "bearings": [53, 150, 327],
//                     "duration": 4.226,
//                     "turn_weight": 0.75,
//                     "turn_duration": 0.009,
//                     "mapbox_streets_v8": {"class": "tertiary"},
//                     "is_urban": false,
//                     "admin_index": 0,
//                     "out": 1,
//                     "weight": 5.073,
//                     "geometry_index": 14,
//                     "location": [-74.077589, 40.765922]
//                   },
//                   {
//                     "entry": [true, true, false],
//                     "in": 2,
//                     "bearings": [61, 149, 330],
//                     "duration": 16.361,
//                     "turn_weight": 0.75,
//                     "turn_duration": 0.007,
//                     "mapbox_streets_v8": {"class": "tertiary"},
//                     "is_urban": false,
//                     "admin_index": 0,
//                     "out": 1,
//                     "weight": 17.513,
//                     "geometry_index": 15,
//                     "location": [-74.077346, 40.765602]
//                   },
//                   {
//                     "bearings": [128, 196, 308],
//                     "entry": [true, true, false],
//                     "in": 2,
//                     "turn_weight": 0.75,
//                     "turn_duration": 0.007,
//                     "mapbox_streets_v8": {"class": "tertiary"},
//                     "is_urban": false,
//                     "admin_index": 0,
//                     "out": 0,
//                     "geometry_index": 22,
//                     "location": [-74.076068, 40.764567]
//                   }
//                 ],
//                 "maneuver": {
//                   "type": "depart",
//                   "instruction": "Drive south on Castle Road.",
//                   "bearing_after": 162,
//                   "bearing_before": 0,
//                   "location": [-74.080395, 40.768843]
//                 },
//                 "name": "Castle Road",
//                 "duration": 70.795,
//                 "distance": 669.6,
//                 "driving_side": "right",
//                 "weight": 78.256,
//                 "mode": "driving",
//                 "geometry": "gtywFnyccM^MdCwA\\S\\SVSLMJM^i@dBaDR]RSNO~AsATQ~@o@r@i@POTWPUVa@Vc@n@qAf@aAZo@"
//               },
//               {
//                 "bannerInstructions": [
//                   {
//                     "sub": {
//                       "components": [
//                         {"type": "text", "text": "Keep left at the fork"}
//                       ],
//                       "type": "turn",
//                       "modifier": "left",
//                       "text": "Keep left at the fork"
//                     },
//                     "primary": {
//                       "components": [{"type": "text", "text": "Continue"}],
//                       "type": "turn",
//                       "modifier": "straight",
//                       "text": "Continue"
//                     },
//                     "distanceAlongGeometry": 260.6
//                   }
//                 ],
//                 "voiceInstructions": [
//                   {
//                     "ssmlAnnouncement": "<speak><amazon:effect name=\"drc\"><prosody rate=\"1.08\">In 900 feet, Continue.</prosody></amazon:effect></speak>",
//                     "announcement": "In 900 feet, Continue.",
//                     "distanceAlongGeometry": 247.266
//                   },
//                   {
//                     "ssmlAnnouncement": "<speak><amazon:effect name=\"drc\"><prosody rate=\"1.08\">Continue. Then Keep left at the fork.</prosody></amazon:effect></speak>",
//                     "announcement": "Continue. Then Keep left at the fork.",
//                     "distanceAlongGeometry": 67.778
//                   }
//                 ],
//                 "intersections": [
//                   {
//                     "mapbox_streets_v8": {"class": "tertiary"},
//                     "location": [-74.075504, 40.764231],
//                     "geometry_index": 24,
//                     "admin_index": 0,
//                     "weight": 19.728,
//                     "is_urban": false,
//                     "yield_sign": true,
//                     "out": 0,
//                     "in": 2,
//                     "turn_duration": 0.949,
//                     "turn_weight": 10,
//                     "duration": 10.44,
//                     "bearings": [75, 252, 308],
//                     "entry": [true, true, false]
//                   },
//                   {
//                     "entry": [true, true, false, false],
//                     "in": 3,
//                     "bearings": [77, 160, 222, 256],
//                     "duration": 2.145,
//                     "turn_weight": 0.75,
//                     "turn_duration": 0.007,
//                     "mapbox_streets_v8": {"class": "tertiary"},
//                     "is_urban": false,
//                     "admin_index": 0,
//                     "out": 0,
//                     "weight": 2.994,
//                     "geometry_index": 29,
//                     "location": [-74.074841, 40.764358]
//                   },
//                   {
//                     "entry": [true, false],
//                     "in": 1,
//                     "bearings": [74, 257],
//                     "duration": 0.113,
//                     "turn_weight": 0.75,
//                     "mapbox_streets_v8": {"class": "tertiary"},
//                     "is_urban": false,
//                     "admin_index": 0,
//                     "out": 0,
//                     "weight": 0.868,
//                     "geometry_index": 30,
//                     "location": [-74.074621, 40.764398]
//                   },
//                   {
//                     "entry": [true, false],
//                     "in": 1,
//                     "bearings": [74, 254],
//                     "duration": 2.025,
//                     "turn_weight": 0.75,
//                     "mapbox_streets_v8": {"class": "tertiary"},
//                     "is_urban": false,
//                     "admin_index": 0,
//                     "out": 0,
//                     "weight": 2.876,
//                     "geometry_index": 31,
//                     "location": [-74.074607, 40.764401]
//                   },
//                   {
//                     "lanes": [
//                       {"indications": ["left"], "valid": false, "active": false},
//                       {
//                         "indications": ["straight"],
//                         "valid_indication": "straight",
//                         "valid": true,
//                         "active": true
//                       },
//                       {
//                         "indications": ["straight", "right"],
//                         "valid_indication": "straight",
//                         "valid": true,
//                         "active": false
//                       }
//                     ],
//                     "location": [-74.074403, 40.764445],
//                     "geometry_index": 32,
//                     "admin_index": 0,
//                     "weight": 16.374,
//                     "is_urban": false,
//                     "mapbox_streets_v8": {"class": "tertiary"},
//                     "turn_duration": 0.008,
//                     "turn_weight": 0.75,
//                     "duration": 14.888,
//                     "bearings": [74, 254, 328],
//                     "out": 0,
//                     "in": 1,
//                     "entry": [true, false, true]
//                   },
//                   {
//                     "lanes": [
//                       {"indications": ["left"], "valid": false, "active": false},
//                       {
//                         "indications": ["straight"],
//                         "valid_indication": "straight",
//                         "valid": true,
//                         "active": true
//                       },
//                       {
//                         "indications": ["straight", "right"],
//                         "valid_indication": "straight",
//                         "valid": true,
//                         "active": false
//                       }
//                     ],
//                     "location": [-74.073698, 40.764603],
//                     "geometry_index": 33,
//                     "admin_index": 0,
//                     "weight": 2.262,
//                     "is_urban": false,
//                     "mapbox_streets_v8": {"class": "tertiary"},
//                     "turn_duration": 0.022,
//                     "turn_weight": 0.75,
//                     "duration": 1.462,
//                     "bearings": [71, 254, 346],
//                     "out": 0,
//                     "in": 1,
//                     "entry": [true, false, true]
//                   },
//                   {
//                     "lanes": [
//                       {"indications": ["left"], "valid": false, "active": false},
//                       {
//                         "indications": ["straight"],
//                         "valid_indication": "straight",
//                         "valid": true,
//                         "active": true
//                       },
//                       {
//                         "indications": ["straight", "right"],
//                         "valid_indication": "straight",
//                         "valid": true,
//                         "active": false
//                       }
//                     ],
//                     "location": [-74.073631, 40.76462],
//                     "geometry_index": 34,
//                     "admin_index": 0,
//                     "weight": 5.532,
//                     "is_urban": false,
//                     "mapbox_streets_v8": {"class": "tertiary"},
//                     "turn_duration": 0.007,
//                     "turn_weight": 1.5,
//                     "duration": 3.847,
//                     "bearings": [72, 168, 251, 348],
//                     "out": 0,
//                     "in": 2,
//                     "entry": [true, false, false, false]
//                   },
//                   {
//                     "lanes": [
//                       {"indications": ["left"], "valid": false, "active": false},
//                       {
//                         "indications": ["straight"],
//                         "valid_indication": "straight",
//                         "valid": true,
//                         "active": true
//                       },
//                       {
//                         "indications": ["straight", "right"],
//                         "valid": false,
//                         "active": false
//                       }
//                     ],
//                     "mapbox_streets_v8": {"class": "secondary"},
//                     "location": [-74.073447, 40.764665],
//                     "geometry_index": 35,
//                     "admin_index": 0,
//                     "weight": 10.086,
//                     "is_urban": false,
//                     "traffic_signal": true,
//                     "turn_duration": 2.007,
//                     "turn_weight": 8,
//                     "duration": 3.994,
//                     "bearings": [73, 166, 252, 346],
//                     "out": 0,
//                     "in": 2,
//                     "entry": [true, true, false, true]
//                   },
//                   {
//                     "bearings": [73, 163, 253, 344],
//                     "entry": [true, false, false, false],
//                     "in": 2,
//                     "turn_weight": 1,
//                     "turn_duration": 0.007,
//                     "mapbox_streets_v8": {"class": "secondary"},
//                     "is_urban": false,
//                     "admin_index": 0,
//                     "out": 0,
//                     "geometry_index": 36,
//                     "location": [-74.07326, 40.764708]
//                   }
//                 ],
//                 "maneuver": {
//                   "type": "end of road",
//                   "instruction": "Turn left onto Paul Amico Way.",
//                   "modifier": "left",
//                   "bearing_after": 75,
//                   "bearing_before": 128,
//                   "location": [-74.075504, 40.764231]
//                 },
//                 "name": "Paul Amico Way",
//                 "duration": 46.866,
//                 "distance": 260.6,
//                 "driving_side": "right",
//                 "weight": 70.063,
//                 "mode": "driving",
//                 "geometry": "mwxwFzzbcMAKCUGg@Ky@??Gk@?AGi@_@kCCMIc@Ge@_@qC"
//               },
//               {
//                 "bannerInstructions": [
//                   {
//                     "sub": {
//                       "components": [{"type": "text", "text": "New County Road"}],
//                       "type": "turn",
//                       "modifier": "slight right",
//                       "text": "New County Road"
//                     },
//                     "primary": {
//                       "components": [
//                         {"type": "text", "text": "Keep left at the fork"}
//                       ],
//                       "type": "turn",
//                       "modifier": "left",
//                       "text": "Keep left at the fork"
//                     },
//                     "distanceAlongGeometry": 50.678
//                   }
//                 ],
//                 "voiceInstructions": [
//                   {
//                     "ssmlAnnouncement": "<speak><amazon:effect name=\"drc\"><prosody rate=\"1.08\">Keep left at the fork. Then Bear right onto <say-as interpret-as=\"address\">New County Road</say-as>.</prosody></amazon:effect></speak>",
//                     "announcement": "Keep left at the fork. Then Bear right onto New County Road.",
//                     "distanceAlongGeometry": 25.678
//                   }
//                 ],
//                 "intersections": [
//                   {
//                     "bearings": [63, 83, 253],
//                     "entry": [false, true, false],
//                     "in": 2,
//                     "turn_weight": 1,
//                     "turn_duration": 0.014,
//                     "mapbox_streets_v8": {"class": "secondary_link"},
//                     "is_urban": false,
//                     "admin_index": 0,
//                     "out": 1,
//                     "geometry_index": 37,
//                     "location": [-74.072533, 40.764874]
//                   }
//                 ],
//                 "maneuver": {
//                   "type": "new name",
//                   "instruction": "Continue.",
//                   "modifier": "straight",
//                   "bearing_after": 83,
//                   "bearing_before": 73,
//                   "location": [-74.072533, 40.764874]
//                 },
//                 "name": "",
//                 "duration": 4.976,
//                 "distance": 50.678,
//                 "driving_side": "right",
//                 "weight": 4.126,
//                 "mode": "driving",
//                 "geometry": "m{xwFhhbcMGeAIm@"
//               },
//               {
//                 "bannerInstructions": [
//                   {
//                     "primary": {
//                       "components": [{"type": "text", "text": "New County Road"}],
//                       "type": "turn",
//                       "modifier": "slight right",
//                       "text": "New County Road"
//                     },
//                     "distanceAlongGeometry": 86.362
//                   }
//                 ],
//                 "voiceInstructions": [
//                   {
//                     "ssmlAnnouncement": "<speak><amazon:effect name=\"drc\"><prosody rate=\"1.08\">Bear right onto <say-as interpret-as=\"address\">New County Road</say-as>.</prosody></amazon:effect></speak>",
//                     "announcement": "Bear right onto New County Road.",
//                     "distanceAlongGeometry": 66.362
//                   }
//                 ],
//                 "intersections": [
//                   {
//                     "bearings": [68, 75, 254],
//                     "entry": [true, true, false],
//                     "in": 2,
//                     "turn_duration": 0.026,
//                     "mapbox_streets_v8": {"class": "secondary"},
//                     "is_urban": false,
//                     "admin_index": 0,
//                     "out": 0,
//                     "geometry_index": 39,
//                     "location": [-74.071945, 40.764961]
//                   }
//                 ],
//                 "maneuver": {
//                   "type": "fork",
//                   "instruction": "Keep left at the fork.",
//                   "modifier": "slight left",
//                   "bearing_after": 68,
//                   "bearing_before": 74,
//                   "location": [-74.071945, 40.764961]
//                 },
//                 "name": "",
//                 "duration": 7.766,
//                 "distance": 86.362,
//                 "driving_side": "right",
//                 "weight": 8.127,
//                 "mode": "driving",
//                 "geometry": "_|xwFtdbcMMm@Ic@SoAAMKK"
//               },
//               {
//                 "bannerInstructions": [
//                   {
//                     "primary": {
//                       "components": [{"type": "text", "text": "Turn left"}],
//                       "type": "turn",
//                       "modifier": "left",
//                       "text": "Turn left"
//                     },
//                     "distanceAlongGeometry": 459.792
//                   }
//                 ],
//                 "voiceInstructions": [
//                   {
//                     "ssmlAnnouncement": "<speak><amazon:effect name=\"drc\"><prosody rate=\"1.08\">In a quarter mile, Turn left.</prosody></amazon:effect></speak>",
//                     "announcement": "In a quarter mile, Turn left.",
//                     "distanceAlongGeometry": 443.459
//                   },
//                   {
//                     "ssmlAnnouncement": "<speak><amazon:effect name=\"drc\"><prosody rate=\"1.08\">Turn left.</prosody></amazon:effect></speak>",
//                     "announcement": "Turn left.",
//                     "distanceAlongGeometry": 65.333
//                   }
//                 ],
//                 "intersections": [
//                   {
//                     "entry": [true, false, true],
//                     "in": 1,
//                     "bearings": [73, 239, 259],
//                     "duration": 1.739,
//                     "turn_weight": 5.75,
//                     "turn_duration": 0.018,
//                     "mapbox_streets_v8": {"class": "secondary"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 0,
//                     "weight": 7.601,
//                     "geometry_index": 44,
//                     "location": [-74.071012, 40.765251]
//                   },
//                   {
//                     "entry": [true, false],
//                     "in": 1,
//                     "bearings": [73, 253],
//                     "duration": 1.487,
//                     "turn_weight": 0.5,
//                     "mapbox_streets_v8": {"class": "secondary"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 0,
//                     "weight": 2.098,
//                     "geometry_index": 45,
//                     "location": [-74.070758, 40.76531]
//                   },
//                   {
//                     "entry": [true, false],
//                     "in": 1,
//                     "bearings": [71, 253],
//                     "duration": 5.009,
//                     "turn_weight": 0.5,
//                     "mapbox_streets_v8": {"class": "secondary"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 0,
//                     "weight": 5.884,
//                     "geometry_index": 47,
//                     "location": [-74.070542, 40.765359]
//                   },
//                   {
//                     "entry": [false, true, false],
//                     "in": 2,
//                     "bearings": [23, 45, 235],
//                     "duration": 8.918,
//                     "turn_weight": 1,
//                     "turn_duration": 0.038,
//                     "mapbox_streets_v8": {"class": "secondary"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 1,
//                     "weight": 10.546,
//                     "geometry_index": 53,
//                     "location": [-74.069875, 40.765617]
//                   },
//                   {
//                     "entry": [true, false, true],
//                     "in": 1,
//                     "bearings": [27, 207, 214],
//                     "duration": 2.134,
//                     "turn_weight": 5.5,
//                     "turn_duration": 0.007,
//                     "mapbox_streets_v8": {"class": "secondary"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 0,
//                     "weight": 7.787,
//                     "geometry_index": 65,
//                     "location": [-74.069163, 40.766446]
//                   },
//                   {
//                     "entry": [true, true, false, true],
//                     "in": 2,
//                     "bearings": [27, 117, 207, 298],
//                     "duration": 1.675,
//                     "turn_weight": 1,
//                     "turn_duration": 0.007,
//                     "mapbox_streets_v8": {"class": "secondary"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 0,
//                     "weight": 2.793,
//                     "geometry_index": 66,
//                     "location": [-74.069019, 40.766656]
//                   },
//                   {
//                     "entry": [true, false, false, false, false],
//                     "in": 3,
//                     "bearings": [27, 115, 199, 207, 296],
//                     "duration": 1.177,
//                     "turn_weight": 2,
//                     "turn_duration": 0.007,
//                     "mapbox_streets_v8": {"class": "secondary"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 0,
//                     "weight": 3.258,
//                     "geometry_index": 67,
//                     "location": [-74.068917, 40.766807]
//                   },
//                   {
//                     "entry": [true, false, true],
//                     "in": 1,
//                     "bearings": [27, 207, 308],
//                     "duration": 9.515,
//                     "turn_weight": 0.5,
//                     "turn_duration": 0.007,
//                     "mapbox_streets_v8": {"class": "secondary"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 0,
//                     "weight": 10.721,
//                     "geometry_index": 68,
//                     "location": [-74.068849, 40.766908]
//                   },
//                   {
//                     "entry": [true, false, true],
//                     "in": 1,
//                     "bearings": [28, 207, 297],
//                     "duration": 3.134,
//                     "turn_weight": 0.5,
//                     "turn_duration": 0.007,
//                     "mapbox_streets_v8": {"class": "secondary"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 0,
//                     "weight": 3.861,
//                     "geometry_index": 70,
//                     "location": [-74.068292, 40.767732]
//                   },
//                   {
//                     "bearings": [28, 208, 301],
//                     "entry": [true, false, true],
//                     "in": 1,
//                     "turn_weight": 0.5,
//                     "turn_duration": 0.007,
//                     "mapbox_streets_v8": {"class": "secondary"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 0,
//                     "geometry_index": 71,
//                     "location": [-74.068107, 40.767993]
//                   }
//                 ],
//                 "maneuver": {
//                   "type": "turn",
//                   "instruction": "Bear right onto New County Road.",
//                   "modifier": "slight right",
//                   "bearing_after": 73,
//                   "bearing_before": 59,
//                   "location": [-74.071012, 40.765251]
//                 },
//                 "name": "New County Road",
//                 "duration": 39.41,
//                 "distance": 459.792,
//                 "driving_side": "right",
//                 "weight": 60.011,
//                 "mode": "driving",
//                 "geometry": "y}xwFx~acMKq@Ik@??G]EYGOEQKUKSCIEGSUGGGGGGGGGEEEEAUO}@i@i@[]SSMcDmB?As@c@oAw@"
//               },
//               {
//                 "bannerInstructions": [
//                   {
//                     "primary": {
//                       "components": [{"type": "text", "text": "Turn right"}],
//                       "type": "turn",
//                       "modifier": "right",
//                       "text": "Turn right"
//                     },
//                     "distanceAlongGeometry": 178.967
//                   }
//                 ],
//                 "voiceInstructions": [
//                   {
//                     "ssmlAnnouncement": "<speak><amazon:effect name=\"drc\"><prosody rate=\"1.08\">In 600 feet, Turn right.</prosody></amazon:effect></speak>",
//                     "announcement": "In 600 feet, Turn right.",
//                     "distanceAlongGeometry": 172.3
//                   },
//                   {
//                     "ssmlAnnouncement": "<speak><amazon:effect name=\"drc\"><prosody rate=\"1.08\">Turn right.</prosody></amazon:effect></speak>",
//                     "announcement": "Turn right.",
//                     "distanceAlongGeometry": 26.667
//                   }
//                 ],
//                 "intersections": [
//                   {
//                     "entry": [true, false, true],
//                     "in": 1,
//                     "bearings": [28, 208, 302],
//                     "duration": 6.304,
//                     "turn_weight": 87.5,
//                     "turn_duration": 4.761,
//                     "mapbox_streets_v8": {"class": "service"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 2,
//                     "weight": 89.197,
//                     "geometry_index": 72,
//                     "location": [-74.067827, 40.768388]
//                   },
//                   {
//                     "entry": [false, false, false, true],
//                     "in": 1,
//                     "bearings": [28, 122, 208, 302],
//                     "duration": 2.322,
//                     "turn_weight": 2,
//                     "turn_duration": 0.007,
//                     "mapbox_streets_v8": {"class": "service"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 3,
//                     "weight": 4.546,
//                     "geometry_index": 73,
//                     "location": [-74.067883, 40.768415]
//                   },
//                   {
//                     "entry": [false, true, true],
//                     "in": 0,
//                     "bearings": [122, 213, 305],
//                     "duration": 30.609,
//                     "turn_weight": 1,
//                     "turn_duration": 0.009,
//                     "mapbox_streets_v8": {"class": "service"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 2,
//                     "weight": 33.895,
//                     "geometry_index": 74,
//                     "location": [-74.067973, 40.768458]
//                   },
//                   {
//                     "entry": [true, false, true],
//                     "in": 1,
//                     "bearings": [30, 121, 303],
//                     "duration": 2.973,
//                     "turn_weight": 1,
//                     "turn_duration": 0.008,
//                     "mapbox_streets_v8": {"class": "service"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 2,
//                     "weight": 4.187,
//                     "geometry_index": 77,
//                     "location": [-74.06908, 40.769118]
//                   },
//                   {
//                     "entry": [false, true, true],
//                     "in": 0,
//                     "bearings": [123, 206, 300],
//                     "duration": 1.715,
//                     "turn_weight": 1,
//                     "turn_duration": 0.021,
//                     "mapbox_streets_v8": {"class": "service"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 2,
//                     "weight": 2.821,
//                     "geometry_index": 78,
//                     "location": [-74.069222, 40.769187]
//                   },
//                   {
//                     "entry": [true, false, true],
//                     "in": 1,
//                     "bearings": [28, 120, 301],
//                     "duration": 1.392,
//                     "turn_weight": 1,
//                     "turn_duration": 0.007,
//                     "mapbox_streets_v8": {"class": "service"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 2,
//                     "weight": 2.488,
//                     "geometry_index": 79,
//                     "location": [-74.069303, 40.769223]
//                   },
//                   {
//                     "bearings": [121, 204, 298],
//                     "entry": [false, true, true],
//                     "in": 0,
//                     "turn_weight": 1,
//                     "turn_duration": 0.022,
//                     "mapbox_streets_v8": {"class": "service"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 2,
//                     "geometry_index": 80,
//                     "location": [-74.069355, 40.769247]
//                   }
//                 ],
//                 "maneuver": {
//                   "type": "turn",
//                   "instruction": "Turn left.",
//                   "modifier": "left",
//                   "bearing_after": 302,
//                   "bearing_before": 28,
//                   "location": [-74.067827, 40.768388]
//                 },
//                 "name": "",
//                 "duration": 50.321,
//                 "distance": 178.967,
//                 "driving_side": "right",
//                 "weight": 143.493,
//                 "mode": "driving",
//                 "geometry": "mqywF|jacMCHIPIRiBfDO`@MZENEJEPGP"
//               },
//               {
//                 "bannerInstructions": [
//                   {
//                     "primary": {
//                       "components": [{"type": "text", "text": "Metro Way"}],
//                       "type": "turn",
//                       "modifier": "left",
//                       "text": "Metro Way"
//                     },
//                     "distanceAlongGeometry": 119.108
//                   }
//                 ],
//                 "voiceInstructions": [
//                   {
//                     "ssmlAnnouncement": "<speak><amazon:effect name=\"drc\"><prosody rate=\"1.08\">In 400 feet, Turn left onto <say-as interpret-as=\"address\">Metro Way</say-as>.</prosody></amazon:effect></speak>",
//                     "announcement": "In 400 feet, Turn left onto Metro Way.",
//                     "distanceAlongGeometry": 112.441
//                   },
//                   {
//                     "ssmlAnnouncement": "<speak><amazon:effect name=\"drc\"><prosody rate=\"1.08\">Turn left onto <say-as interpret-as=\"address\">Metro Way</say-as>.</prosody></amazon:effect></speak>",
//                     "announcement": "Turn left onto Metro Way.",
//                     "distanceAlongGeometry": 33.333
//                   }
//                 ],
//                 "intersections": [
//                   {
//                     "entry": [true, false, true],
//                     "in": 1,
//                     "bearings": [24, 118, 204],
//                     "duration": 27.695,
//                     "turn_weight": 2,
//                     "turn_duration": 1.723,
//                     "mapbox_streets_v8": {"class": "service"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 0,
//                     "weight": 29.919,
//                     "geometry_index": 82,
//                     "location": [-74.069545, 40.769323]
//                   },
//                   {
//                     "bearings": [32, 204, 291],
//                     "entry": [true, false, true],
//                     "in": 1,
//                     "turn_weight": 1,
//                     "turn_duration": 0.012,
//                     "mapbox_streets_v8": {"class": "service"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 0,
//                     "geometry_index": 83,
//                     "location": [-74.069059, 40.770148]
//                   }
//                 ],
//                 "maneuver": {
//                   "type": "turn",
//                   "instruction": "Turn right.",
//                   "modifier": "right",
//                   "bearing_after": 24,
//                   "bearing_before": 298,
//                   "location": [-74.069545, 40.769323]
//                 },
//                 "name": "",
//                 "duration": 32.266,
//                 "distance": 119.108,
//                 "driving_side": "right",
//                 "weight": 35.821,
//                 "mode": "driving",
//                 "geometry": "gwywFruacMeD_B[W"
//               },
//               {
//                 "bannerInstructions": [
//                   {
//                     "primary": {
//                       "components": [{"type": "text", "text": "Aquarium Drive"}],
//                       "type": "turn",
//                       "modifier": "left",
//                       "text": "Aquarium Drive"
//                     },
//                     "distanceAlongGeometry": 635.124
//                   }
//                 ],
//                 "voiceInstructions": [
//                   {
//                     "ssmlAnnouncement": "<speak><amazon:effect name=\"drc\"><prosody rate=\"1.08\">Continue for a half mile.</prosody></amazon:effect></speak>",
//                     "announcement": "Continue for a half mile.",
//                     "distanceAlongGeometry": 625.124
//                   },
//                   {
//                     "ssmlAnnouncement": "<speak><amazon:effect name=\"drc\"><prosody rate=\"1.08\">In a quarter mile, Turn left onto <say-as interpret-as=\"address\">Aquarium Drive</say-as>.</prosody></amazon:effect></speak>",
//                     "announcement": "In a quarter mile, Turn left onto Aquarium Drive.",
//                     "distanceAlongGeometry": 402.336
//                   },
//                   {
//                     "ssmlAnnouncement": "<speak><amazon:effect name=\"drc\"><prosody rate=\"1.08\">Turn left onto <say-as interpret-as=\"address\">Aquarium Drive</say-as>. Then Your destination will be on the left.</prosody></amazon:effect></speak>",
//                     "announcement": "Turn left onto Aquarium Drive. Then Your destination will be on the left.",
//                     "distanceAlongGeometry": 76.806
//                   }
//                 ],
//                 "intersections": [
//                   {
//                     "entry": [true, false, true],
//                     "in": 1,
//                     "bearings": [125, 212, 298],
//                     "duration": 29.93,
//                     "turn_weight": 10,
//                     "turn_duration": 5.93,
//                     "mapbox_streets_v8": {"class": "street"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 2,
//                     "weight": 35.8,
//                     "geometry_index": 84,
//                     "location": [-74.068944, 40.77029]
//                   },
//                   {
//                     "entry": [true, false, true],
//                     "in": 1,
//                     "bearings": [23, 118, 301],
//                     "duration": 0.368,
//                     "turn_weight": 1,
//                     "turn_duration": 0.008,
//                     "mapbox_streets_v8": {"class": "street"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 2,
//                     "weight": 1.387,
//                     "geometry_index": 85,
//                     "location": [-74.069989, 40.770717]
//                   },
//                   {
//                     "entry": [false, true, true],
//                     "in": 0,
//                     "bearings": [121, 201, 299],
//                     "duration": 1.961,
//                     "turn_weight": 1,
//                     "turn_duration": 0.022,
//                     "mapbox_streets_v8": {"class": "street"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 2,
//                     "weight": 3.084,
//                     "geometry_index": 86,
//                     "location": [-74.07002, 40.770731]
//                   },
//                   {
//                     "entry": [false, true, true],
//                     "in": 0,
//                     "bearings": [119, 201, 307],
//                     "duration": 3.954,
//                     "turn_weight": 1,
//                     "turn_duration": 0.011,
//                     "mapbox_streets_v8": {"class": "street"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 2,
//                     "weight": 5.239,
//                     "geometry_index": 87,
//                     "location": [-74.070162, 40.770791]
//                   },
//                   {
//                     "entry": [true, false, true],
//                     "in": 1,
//                     "bearings": [42, 127, 335],
//                     "duration": 11.205,
//                     "turn_weight": 1.5,
//                     "turn_duration": 0.045,
//                     "mapbox_streets_v8": {"class": "street"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 2,
//                     "weight": 13.497,
//                     "geometry_index": 88,
//                     "location": [-74.07038, 40.770915]
//                   },
//                   {
//                     "entry": [false, true, true],
//                     "in": 0,
//                     "bearings": [160, 252, 340],
//                     "duration": 2.08,
//                     "turn_weight": 1,
//                     "turn_duration": 0.007,
//                     "mapbox_streets_v8": {"class": "street"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 2,
//                     "weight": 3.228,
//                     "geometry_index": 90,
//                     "location": [-74.070789, 40.771688]
//                   },
//                   {
//                     "entry": [false, true, true],
//                     "in": 0,
//                     "bearings": [160, 251, 340],
//                     "duration": 15.165,
//                     "turn_weight": 1,
//                     "turn_duration": 0.007,
//                     "mapbox_streets_v8": {"class": "street"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 2,
//                     "weight": 17.295,
//                     "geometry_index": 91,
//                     "location": [-74.070866, 40.771849]
//                   },
//                   {
//                     "entry": [false, true, true],
//                     "in": 0,
//                     "bearings": [160, 244, 340],
//                     "duration": 0.83,
//                     "turn_weight": 1,
//                     "turn_duration": 0.007,
//                     "mapbox_streets_v8": {"class": "street"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 2,
//                     "weight": 1.885,
//                     "geometry_index": 93,
//                     "location": [-74.071504, 40.773199]
//                   },
//                   {
//                     "entry": [true, false, true],
//                     "in": 1,
//                     "bearings": [79, 160, 325],
//                     "duration": 10.959,
//                     "turn_weight": 1.5,
//                     "turn_duration": 0.056,
//                     "mapbox_streets_v8": {"class": "street"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 2,
//                     "weight": 13.221,
//                     "geometry_index": 94,
//                     "location": [-74.071536, 40.773267]
//                   },
//                   {
//                     "entry": [true, false, true],
//                     "in": 1,
//                     "bearings": [23, 114, 292],
//                     "duration": 0.142,
//                     "turn_weight": 1,
//                     "turn_duration": 0.022,
//                     "mapbox_streets_v8": {"class": "street"},
//                     "is_urban": true,
//                     "admin_index": 0,
//                     "out": 2,
//                     "weight": 1.129,
//                     "geometry_index": 98,
//                     "location": [-74.072614, 40.773711]
//                   },
//                   {
//                     "entry": [false, true, true],
//                     "in": 0,
//                     "bearings": [112, 201, 294],
//                     "duration": 7.623,
//                     "turn_weight": 1.6,
//                     "turn_duration": 0.007,
//                     "mapbox_streets_v8": {"class": "street"},
//                     "is_urban": false,
//                     "admin_index": 0,
//                     "out": 2,
//                     "weight": 9.596,
//                     "geometry_index": 99,
//                     "location": [-74.07263, 40.773716]
//                   },
//                   {
//                     "entry": [false, true, true],
//                     "in": 0,
//                     "bearings": [114, 190, 295],
//                     "duration": 1.928,
//                     "turn_weight": 1,
//                     "turn_duration": 0.008,
//                     "mapbox_streets_v8": {"class": "street"},
//                     "is_urban": false,
//                     "admin_index": 0,
//                     "out": 2,
//                     "weight": 3.016,
//                     "geometry_index": 100,
//                     "location": [-74.073224, 40.773916]
//                   },
//                   {
//                     "bearings": [23, 115, 293],
//                     "entry": [true, false, true],
//                     "in": 1,
//                     "turn_weight": 6,
//                     "turn_duration": 0.021,
//                     "mapbox_streets_v8": {"class": "street"},
//                     "is_urban": false,
//                     "admin_index": 0,
//                     "out": 2,
//                     "geometry_index": 101,
//                     "location": [-74.073308, 40.773945]
//                   }
//                 ],
//                 "maneuver": {
//                   "type": "end of road",
//                   "instruction": "Turn left onto Metro Way.",
//                   "modifier": "left",
//                   "bearing_after": 298,
//                   "bearing_before": 32,
//                   "location": [-74.068944, 40.77029]
//                 },
//                 "name": "Metro Way",
//                 "duration": 96.517,
//                 "distance": 635.124,
//                 "driving_side": "right",
//                 "weight": 125.243,
//                 "mode": "driving",
//                 "geometry": "i}ywFzqacMuApEADKZWj@y@b@aBl@_@NKBaGxBMFMDKTWhAe@nBABg@tBCPa@bB"
//               },
//               {
//                 "bannerInstructions": [
//                   {
//                     "primary": {
//                       "components": [
//                         {
//                           "type": "text",
//                           "text": "Your destination will be on the left"
//                         }
//                       ],
//                       "type": "arrive",
//                       "modifier": "left",
//                       "text": "Your destination will be on the left"
//                     },
//                     "distanceAlongGeometry": 134.026
//                   },
//                   {
//                     "primary": {
//                       "components": [
//                         {
//                           "type": "text",
//                           "text": "Your destination is on the left"
//                         }
//                       ],
//                       "type": "arrive",
//                       "modifier": "left",
//                       "text": "Your destination is on the left"
//                     },
//                     "distanceAlongGeometry": 55.556
//                   }
//                 ],
//                 "voiceInstructions": [
//                   {
//                     "ssmlAnnouncement": "<speak><amazon:effect name=\"drc\"><prosody rate=\"1.08\">Your destination is on the left.</prosody></amazon:effect></speak>",
//                     "announcement": "Your destination is on the left.",
//                     "distanceAlongGeometry": 55.556
//                   }
//                 ],
//                 "intersections": [
//                   {
//                     "bearings": [113, 202, 286],
//                     "entry": [false, true, true],
//                     "in": 0,
//                     "turn_weight": 5,
//                     "turn_duration": 5.622,
//                     "mapbox_streets_v8": {"class": "street"},
//                     "is_urban": false,
//                     "admin_index": 0,
//                     "out": 1,
//                     "geometry_index": 102,
//                     "location": [-74.073809, 40.774105]
//                   }
//                 ],
//                 "maneuver": {
//                   "type": "turn",
//                   "instruction": "Turn left onto Aquarium Drive.",
//                   "modifier": "left",
//                   "bearing_after": 202,
//                   "bearing_before": 293,
//                   "location": [-74.073809, 40.774105]
//                 },
//                 "name": "Aquarium Drive",
//                 "duration": 24.179,
//                 "distance": 134.026,
//                 "driving_side": "right",
//                 "weight": 24.485,
//                 "mode": "driving",
//                 "geometry": "euzwFhpbcM~EtB"
//               },
//               {
//                 "bannerInstructions": [],
//                 "voiceInstructions": [],
//                 "intersections": [
//                   {
//                     "bearings": [22],
//                     "entry": [true],
//                     "in": 0,
//                     "admin_index": 0,
//                     "geometry_index": 103,
//                     "location": [-74.074404, 40.772989]
//                   }
//                 ],
//                 "maneuver": {
//                   "type": "arrive",
//                   "instruction": "Your destination is on the left.",
//                   "modifier": "left",
//                   "bearing_after": 0,
//                   "bearing_before": 202,
//                   "location": [-74.074404, 40.772989]
//                 },
//                 "name": "Aquarium Drive",
//                 "duration": 0,
//                 "distance": 0,
//                 "driving_side": "right",
//                 "weight": 0,
//                 "mode": "driving",
//                 "geometry": "enzwF~sbcM??"
//               }
//             ],
//             "distance": 2594.257,
//             "summary": "Castle Road, Metro Way"
//           }
//         ],
//         "geometry": "gtywFnyccM^MdCwA\\S\\SVSLMJM^i@dBaDR]RSNO~AsATQ~@o@r@i@POTWPUVa@Vc@n@qAf@aAZo@AKCUGg@Ky@??Gk@?AGi@_@kCCMIc@Ge@_@qCGeAIm@Mm@Ic@SoAAMKKKq@Ik@??G]EYGOEQKUKSCIEGSUGGGGGGGGGEEEEAUO}@i@i@[]SSMcDmB?As@c@oAw@CHIPIRiBfDO`@MZENEJEPGPeD_B[WuApEADKZWj@y@b@aBl@_@NKBaGxBMFMDKTWhAe@nBABg@tBCPa@bB~EtB",
//         "voiceLocale": "en-US"
//       }
//     ],
//     "waypoints": [
//       {
//         "distance": 0.675,
//         "name": "Castle Road",
//         "location": [-74.080395, 40.768843]
//       },
//       {
//         "distance": 11.474,
//         "name": "Aquarium Drive",
//         "location": [-74.074404, 40.772989]
//       }
//     ],
//     "code": "Ok",
//     "uuid": "9uEz1YR1GBCwqUj667axeI-DpjodGcZxlup8rGrV7gFrp2dccQeJzA=="
//   }