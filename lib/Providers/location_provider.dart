import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rawcuts_pvt_ltd/Models/location_model.dart';

class LocationProvider with ChangeNotifier {
  double latitude;
  double longitude;
  bool permissionAllowed = false;
  var selectedAddress;
  bool loading = false;
  List<Location> _location = [];
  Location locationAttributes = Location();

  Future<void> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      this.latitude = position.latitude;
      this.longitude = position.longitude;

      final coordinates = new Coordinates(this.latitude, this.longitude);
      final addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      this.selectedAddress = addresses.first;

      this.permissionAllowed = true;
      notifyListeners();
    } else {
      print('Location Access Denied');
    }
  }

  void onCameraMove(CameraPosition cameraPosition) async {
    this.latitude = cameraPosition.target.latitude;
    this.longitude = cameraPosition.target.longitude;
    notifyListeners();
  }

  Future<void> getMoveCamera() async {
    final coordinates = new Coordinates(this.latitude, this.longitude);
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    this.selectedAddress = addresses.first;
    print('${selectedAddress.featureName} : ${selectedAddress.addressLine}');
  }

  Future<void> getLocation() async {
    await FirebaseFirestore.instance
        .collection('Location')
        .get()
        .then((QuerySnapshot locationSnapshot) {
      _location = [];
      locationSnapshot.docs.forEach((element) {
        _location.insert(
            0,
            Location(
                leftBoundary: double.parse(element.get('left')),
                bottomBoundary: double.parse(element.get('bottom')),
                rightBoundary: double.parse(element.get('right')),
                topBoundary: double.parse(element.get('top'))));
      });
    });
  }

  swlocationBounds() {
    final southwest = LatLng(locationAttributes.bottomBoundary ?? 0.0,
        locationAttributes.leftBoundary ?? 0.0);
    return southwest;
  }

  nelocationBounds() {
    final northeast = LatLng(locationAttributes.topBoundary ?? 0.0,
        locationAttributes.rightBoundary ?? 0.0);
    return northeast;
  }
}
