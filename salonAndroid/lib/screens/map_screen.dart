import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key, this.lattitude, this.longitude}) : super(key: key);

  var lattitude;
  var longitude;
  static const routeName = '/MapScreen';

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void dispose() {
    mapController.dispose();

    super.dispose();
  }
  // Completer<GoogleMapController> _controller = Completer();

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

  // static final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);
  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
  var initialLatitude = 15.334880;
  var initialLongitude = 76.462044;

  @override
  void initState() {
    super.initState();
    getMarker(initialLatitude, initialLongitude);
    _center = LatLng(initialLatitude, initialLongitude);
  }

  Location location = Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  void getMyLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation().then((value) {
      setState(() {
        double? lattitude = value.latitude;
        double? longitude = value.longitude;

        getMarker(value.latitude, value.longitude);
        _center = LatLng(lattitude!, longitude!);
        mapController
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(lattitude, longitude),
          zoom: 15.0,
        )));
      });
      return value;
    });

    print("locationLatitude: ${_locationData.latitude}");
    print("locationLongitude: ${_locationData.longitude}");
  }

  late GoogleMapController mapController;

  late LatLng _center;
  List<Marker> _origin = [];

  void getMarker(var latitude, var longitude) {
    _origin.add(Marker(
      markerId: MarkerId('Location'),
      infoWindow: InfoWindow(title: 'Location'),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      position: LatLng(latitude, longitude),
    ));
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  List<Marker> customMarkers = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          buildingsEnabled: true,
          mapType: MapType.hybrid,
          indoorViewEnabled: true,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          rotateGesturesEnabled: true,
          compassEnabled: true,
          markers: _origin.toSet(),
          onMapCreated: _onMapCreated,
          initialCameraPosition: _initialCameraPosition(),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            backgroundColor: Colors.black,
            onPressed: () => mapController.animateCamera(
                CameraUpdate.newCameraPosition(_initialCameraPosition())),
            label: const Text('Focus!'),
            icon: const Icon(Icons.center_focus_strong),
          ),
          const SizedBox(
            width: 20,
          ),
          FloatingActionButton.extended(
            backgroundColor: Colors.black,
            onPressed: getMyLocation,
            label: const Text('My Location'),
            icon: const Icon(Icons.location_on_outlined),
          )
        ],
      ),
    );
  }

  CameraPosition _initialCameraPosition() {
    return CameraPosition(
      target: _center,
      zoom: 15.0,
    );
  }
}
