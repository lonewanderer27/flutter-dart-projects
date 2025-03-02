import 'package:moments/models/place.dart';

class Address {
  String id;
  String road;
  String village;
  String stateDistrict;
  String state;
  String postCode;
  String country;
  String countryCode;
  String displayName;
  String name;
  double lat;
  double lon;

  Address(
      {String? id,
      required this.road,
      required this.village,
      required this.stateDistrict,
      required this.state,
      required this.postCode,
      required this.country,
      required this.countryCode,
      required this.displayName,
      required this.name,
      required this.lat,
      required this.lon})
      : id = id ?? uuid.v4();

  factory Address.fromJSON(Map<String, dynamic> json, String displayName,
      String name, double lat, double lon) {
    return Address(
        road: json['road'] ??= '',
        village: json['village'] ??= '',
        stateDistrict: json['state_district'] ??= '',
        state: json['state'] ??= '',
        postCode: json['postcode'] ??= '',
        country: json['country'] ??= '',
        countryCode: json['country_code'] ??= '',
        displayName: displayName,
        name: name,
        lat: lat,
        lon: lon);
  }
}
