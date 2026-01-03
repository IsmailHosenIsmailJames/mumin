import "package:geocoding/geocoding.dart";

AppPlacemark onePlacemarkFromMulti(List<Placemark> placemarks) {
  AppPlacemark placemarkToReturn = AppPlacemark.fromPlacemark(placemarks.first);
  for (Placemark placemark in placemarks) {
    if ((placemarkToReturn.administrativeArea == null ||
            placemarkToReturn.administrativeArea!.isEmpty) &&
        placemark.administrativeArea?.isNotEmpty == true) {
      placemarkToReturn.administrativeArea = placemark.administrativeArea;
    }
    if ((placemarkToReturn.country == null ||
            placemarkToReturn.country!.isEmpty) &&
        placemark.country?.isNotEmpty == true) {
      placemarkToReturn.country = placemark.country;
    }
    if ((placemarkToReturn.isoCountryCode == null ||
            placemarkToReturn.isoCountryCode!.isEmpty) &&
        placemark.isoCountryCode?.isNotEmpty == true) {
      placemarkToReturn.isoCountryCode = placemark.isoCountryCode;
    }
    if ((placemarkToReturn.locality == null ||
            placemarkToReturn.locality!.isEmpty) &&
        placemark.locality?.isNotEmpty == true) {
      placemarkToReturn.locality = placemark.locality;
    }
    if ((placemarkToReturn.name == null || placemarkToReturn.name!.isEmpty) &&
        placemark.name?.isNotEmpty == true) {
      placemarkToReturn.name = placemark.name;
    }
    if ((placemarkToReturn.postalCode == null ||
            placemarkToReturn.postalCode!.isEmpty) &&
        placemark.postalCode?.isNotEmpty == true) {
      placemarkToReturn.postalCode = placemark.postalCode;
    }
    if ((placemarkToReturn.subAdministrativeArea == null ||
            placemarkToReturn.subAdministrativeArea!.isEmpty) &&
        placemark.subAdministrativeArea?.isNotEmpty == true) {
      placemarkToReturn.subAdministrativeArea = placemark.subAdministrativeArea;
    }
    if ((placemarkToReturn.subLocality == null ||
            placemarkToReturn.subLocality!.isEmpty) &&
        placemark.subLocality?.isNotEmpty == true) {
      placemarkToReturn.subLocality = placemark.subLocality;
    }
    if ((placemarkToReturn.thoroughfare == null ||
            placemarkToReturn.thoroughfare!.isEmpty) &&
        placemark.thoroughfare?.isNotEmpty == true) {
      placemarkToReturn.thoroughfare = placemark.thoroughfare;
    }
    if ((placemarkToReturn.subThoroughfare == null ||
            placemarkToReturn.subThoroughfare!.isEmpty) &&
        placemark.subThoroughfare?.isNotEmpty == true) {
      placemarkToReturn.subThoroughfare = placemark.subThoroughfare;
    }
    if ((placemarkToReturn.street == null ||
            placemarkToReturn.street!.isEmpty) &&
        placemark.street?.isNotEmpty == true) {
      placemarkToReturn.street = placemark.street;
    }
  }
  return placemarkToReturn;
}

class AppPlacemark {
  String? name;
  String? street;
  String? isoCountryCode;
  String? country;
  String? postalCode;
  String? administrativeArea;
  String? subAdministrativeArea;
  String? locality;
  String? subLocality;
  String? thoroughfare;
  String? subThoroughfare;
  AppPlacemark({
    this.name,
    this.street,
    this.isoCountryCode,
    this.country,
    this.postalCode,
    this.administrativeArea,
    this.subAdministrativeArea,
    this.locality,
    this.subLocality,
    this.thoroughfare,
    this.subThoroughfare,
  });
  factory AppPlacemark.fromPlacemark(Placemark placemark) {
    return AppPlacemark(
      name: placemark.name,
      street: placemark.street,
      isoCountryCode: placemark.isoCountryCode,
      country: placemark.country,
      postalCode: placemark.postalCode,
      administrativeArea: placemark.administrativeArea,
      subAdministrativeArea: placemark.subAdministrativeArea,
      locality: placemark.locality,
      subLocality: placemark.subLocality,
      thoroughfare: placemark.thoroughfare,
      subThoroughfare: placemark.subThoroughfare,
    );
  }
  // encoder decoder
  Map<String, dynamic> toJson() => {
        "name": name,
        "street": street,
        "isoCountryCode": isoCountryCode,
        "country": country,
        "postalCode": postalCode,
        "administrativeArea": administrativeArea,
        "subAdministrativeArea": subAdministrativeArea,
        "locality": locality,
        "subLocality": subLocality,
        "thoroughfare": thoroughfare,
        "subThoroughfare": subThoroughfare,
      };
  factory AppPlacemark.fromJson(Map<String, dynamic> json) {
    return AppPlacemark(
      name: json["name"],
      street: json["street"],
      isoCountryCode: json["isoCountryCode"],
      country: json["country"],
      postalCode: json["postalCode"],
      administrativeArea: json["administrativeArea"],
      subAdministrativeArea: json["subAdministrativeArea"],
      locality: json["locality"],
      subLocality: json["subLocality"],
      thoroughfare: json["thoroughfare"],
      subThoroughfare: json["subThoroughfare"],
    );
  }

  String toAddressString() {
    String stringFrom = "";
    if (name != null && name!.isNotEmpty) stringFrom += "$name, ";
    if (subThoroughfare != null &&
        subThoroughfare!.isNotEmpty &&
        !stringFrom.contains(subThoroughfare!)) {
      stringFrom += "$subThoroughfare, ";
    }
    if (thoroughfare != null &&
        thoroughfare!.isNotEmpty &&
        !stringFrom.contains(thoroughfare!)) {
      stringFrom += "$thoroughfare, ";
    }
    if (street != null && street!.isNotEmpty && !stringFrom.contains(street!)) {
      stringFrom += "$street, ";
    }
    if (subLocality != null &&
        subLocality!.isNotEmpty &&
        !stringFrom.contains(subLocality!)) {
      stringFrom += "$subLocality, ";
    }
    if (locality != null &&
        locality!.isNotEmpty &&
        !stringFrom.contains(locality!)) {
      stringFrom += "$locality, ";
    }
    if (subAdministrativeArea != null &&
        subAdministrativeArea!.isNotEmpty &&
        !stringFrom.contains(subAdministrativeArea!)) {
      stringFrom += "$subAdministrativeArea, ";
    }
    if (administrativeArea != null &&
        administrativeArea!.isNotEmpty &&
        !stringFrom.contains(administrativeArea!)) {
      stringFrom += "$administrativeArea, ";
    }
    if (postalCode != null &&
        postalCode!.isNotEmpty &&
        !stringFrom.contains(postalCode!)) {
      stringFrom += "$postalCode, ";
    }
    if (country != null &&
        country!.isNotEmpty &&
        !stringFrom.contains(country!)) {
      stringFrom += "$country";
    }
    return stringFrom;
  }
}
