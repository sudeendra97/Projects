import 'dart:convert';

import 'dart:typed_data';

class Business {
  final String id;
  final String description;
  final String businessName;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final List imagepath;
  final int index;

  Business({
    required this.id,
    required this.description,
    required this.businessName,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    required this.imagepath,
    required this.index,
  });
}
