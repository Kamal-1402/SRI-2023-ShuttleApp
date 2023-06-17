// class PlacePredictions {
//   String? secondaryText;
//   String? mainText;
//   String? placeId;

//   PlacePredictions({this.secondaryText, this.mainText, this.placeId});

//   PlacePredictions.fromJson(Map<String, dynamic> json) {
//     secondaryText = json['secondary_text'];
//     mainText = json["structured_formatting"]['main_text'];
//     placeId = json["structured_formatting"]['place_id'];
//   }
// }

class PlacePredictions {
  String? place_formatted;
  String? country_code_alpha_3;
  String? postcode;
  String? neighborhood;
  String? street;
  String? placeId;
  // String? place_formatted;

  PlacePredictions(
      {this.place_formatted, this.country_code_alpha_3, this.neighborhood,this.postcode,this.street,this.placeId});

  PlacePredictions.fromJson(Map<String, dynamic> json) {
    place_formatted = json['place_formatted'] ?? "";
    country_code_alpha_3 = json["context"]["country"]?['country_code_alpha_3'] ?? "";
    postcode = json["context"]?['postcode']?["name"] ?? "";
    neighborhood = json["context"]?['neighborhood']?["name"]  ?? "";
    street = json["context"]?['street']?["name"]  ?? "";
    placeId=json["mapbox_id"] ?? "";
  }
}
