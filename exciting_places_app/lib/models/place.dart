import 'dart:io';

class PlaceLocation {
  final double Latitude;
  final double Longitude;
  var address;
  PlaceLocation(
      {required this.Latitude, required this.Longitude, this.address});
}

class Place {
  final String id;
  final String title;
  final PlaceLocation location;
  final File image;

  Place({
    required this.id,
    required this.image,
    required this.location,
    required this.title,
  });
}
