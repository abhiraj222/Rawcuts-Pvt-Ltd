import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';
import 'package:rawcuts_pvt_ltd/Constants/style.dart';
import 'package:rawcuts_pvt_ltd/Models/location_model.dart';
import 'package:rawcuts_pvt_ltd/Providers/auth_provider.dart';
import 'package:rawcuts_pvt_ltd/Providers/location_provider.dart';
import 'package:rawcuts_pvt_ltd/Screens/welcome_screen.dart';

import 'Auth/login_screen.dart';
import 'mainscreen.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'map=screen';
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng currentLocation;
  GoogleMapController _mapController;
  bool _locating = false;
  bool _loggedIn = false;
  User user;

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
    if (user != null) {
      setState(() {
        _loggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    final _auth = Provider.of<AuthProvider>(context);

    setState(() {
      currentLocation = LatLng(locationData.latitude, locationData.longitude);
    });

    void onCreated(GoogleMapController controller) {
      setState(() {
        _mapController = controller;
      });
    }

    LatLngBounds _jorhatBounds = LatLngBounds(
        southwest: locationData.swlocationBounds(),
        northeast: locationData.nelocationBounds());
    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: currentLocation,
            zoom: 14.4746,
          ),
          zoomControlsEnabled: false,
          minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.8),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          mapToolbarEnabled: true,
          onCameraMove: (CameraPosition position) {
            setState(() {
              _locating = true;
            });
            locationData.onCameraMove(position);
          },
          onMapCreated: onCreated,
          // cameraTargetBounds: CameraTargetBounds(LatLngBounds(
          //     southwest: locationData.swlocationBounds(),
          //     northeast: locationData.nelocationBounds())),
          onCameraIdle: () {
            setState(() {
              _locating = false;
            });
            locationData.getMoveCamera();
          },
        ),
        Center(
          child: Container(
              height: 60,
              margin: EdgeInsets.only(bottom: 40),
              child: Image.asset(
                'assets/images/marker.png',
              )),
        ),
        Center(
          child: SpinKitPulse(
            color: AppColors.primary,
            size: 100,
          ),
        ),
        Positioned(
          bottom: 0.0,
          child: Container(
            height: 220,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _locating
                      ? LinearProgressIndicator(
                          backgroundColor: Colors.transparent,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.primary),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 20),
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.location_searching,
                        color: AppColors.primary,
                        size: 30,
                      ),
                      label: Text(
                        _locating
                            ? 'Locating...'
                            : locationData.selectedAddress.featureName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: AppColors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 28, right: 20),
                    child: PrimaryText(
                        text: locationData.selectedAddress.addressLine),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: AbsorbPointer(
                        absorbing: _locating ? true : false,
                        child: Material(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 8,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            onPressed: () {
                              if (_loggedIn == false) {
                                Navigator.pushNamed(context, SignInPage.id);
                              } else {
                                _auth.updateUser(
                                    id: user.uid,
                                    number: user.phoneNumber,
                                    latitude: locationData.latitude,
                                    longitude: locationData.longitude,
                                    address: locationData
                                        .selectedAddress.addressLine);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainScreen()),
                                );
                              }
                            },
                            color: AppColors.primary,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: PrimaryText(
                                text: 'CONFIRM LOCATION',
                                color: _locating
                                    ? AppColors.lightGray
                                    : AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    )));
  }
}
