class NominatimAddress {
  String road;
  String village;
  String stateDistrict;
  String state;
  String postcode;
  String country;
  String countryCode;
  String displayName;
  String name;

  NominatimAddress(
      {required this.road,
      required this.village,
      required this.stateDistrict,
      required this.state,
      required this.postcode,
      required this.country,
      required this.countryCode,
      required this.displayName,
      required this.name});

  factory NominatimAddress.fromJSON(
      Map<String, dynamic> json, String displayName, String name) {
    return NominatimAddress(
        road: json['road'] ??= '',
        village: json['village'] ??= '',
        stateDistrict: json['state_district'] ??= '',
        state: json['state'] ??= '',
        postcode: json['postcode'] ??= '',
        country: json['country'] ??= '',
        countryCode: json['country_code'] ??= '',
        displayName: displayName,
        name: name);
  }
}
