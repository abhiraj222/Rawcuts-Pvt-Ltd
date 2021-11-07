import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';
import 'package:rawcuts_pvt_ltd/Constants/style.dart';
import 'package:rawcuts_pvt_ltd/Providers/location_provider.dart';
import 'package:rawcuts_pvt_ltd/Screens/mainscreen.dart';
import 'package:rawcuts_pvt_ltd/Services/user_services.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;

  String smsOtp;
  String verificationId;
  String error = '';
  UserServices _userServices = UserServices();
  bool loading = false;
  LocationProvider locationData = LocationProvider();
  String screen;
  DocumentSnapshot snapshot;

  void createUser(
      {String id,
      String number,
      double latitude,
      double longitude,
      String address,
      String name}) {
    _userServices.createUser({
      'id': id,
      'number': number,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'Name': name
    });
  }

  void updateUser(
      {String id,
      String number,
      double latitude,
      double longitude,
      String address,
      String name}) {
    _userServices.updateUserData({
      'id': id,
      'number': number,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'Name': name
    });
    this.loading = false;
    notifyListeners();
  }

  Future<void> verifyPhone(
      {BuildContext context,
      String number,
      double latitude,
      double longitude,
      String address,
      String name}) async {
    this.loading = true;
    notifyListeners();
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      this.loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      this.loading = false;
      print(e.code);
      this.error = e.toString();
      notifyListeners();
    };

    final PhoneCodeSent smsotpSend = (String verId, int resendToken) async {
      this.verificationId = verId;

      //dialog to enter received OTP sms

      smsOtpDialog(context, number, latitude, longitude, address, name);
    };

    try {
      _auth.verifyPhoneNumber(
          phoneNumber: number,
          timeout: Duration(seconds: 60),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: smsotpSend,
          codeAutoRetrievalTimeout: (String verId) {
            this.verificationId = verId;
          });
    } catch (e) {
      this.error = e.toString();
      notifyListeners();
      print(e);
    }
  }

  Future<bool> smsOtpDialog(BuildContext context, String number,
      double latitude, double longitude, String address, String name) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                PrimaryText(
                  text: 'Verification Code',
                ),
                SizedBox(
                  height: 6,
                ),
                PrimaryText(
                  text: 'Enter 6 digit otp received as SMS',
                  color: AppColors.primary,
                  size: 12,
                )
              ],
            ),
            content: Container(
              height: 85,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) {
                  this.smsOtp = value;
                },
              ),
            ),
            actions: [
              // ignore: deprecated_member_use
              FlatButton(
                  color: AppColors.primary,
                  onPressed: () async {
                    try {
                      PhoneAuthCredential phoneAuthCredential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationId, smsCode: smsOtp);

                      final User user = (await _auth
                              .signInWithCredential(phoneAuthCredential))
                          .user;
                      if (locationData.selectedAddress != null) {
                        updateUser(
                            id: user.uid,
                            number: user.phoneNumber,
                            latitude: locationData.latitude,
                            longitude: locationData.longitude,
                            address: locationData.selectedAddress.addressLine,
                            name: user.displayName);
                      } else {
                        createUser(
                            id: user.uid,
                            number: user.phoneNumber,
                            latitude: latitude,
                            longitude: longitude,
                            address: address,
                            name: user.displayName);
                      }

                      // Naviagte to homepage after login
                      if (user != null) {
                        Navigator.of(context).pop();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainScreen()),
                        );
                      } else {
                        print('Login Failed');
                      }
                      // this.loading = false;
                    } catch (e) {
                      this.error = 'Invalid OTP';
                      notifyListeners();
                      print(e.toString());
                      Navigator.of(context).pop();
                    }
                    this.loading = true;
                  },
                  child: this.loading
                      ? PrimaryText(
                          text: 'DONE',
                          color: AppColors.white,
                        )
                      : CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.white),
                        ))
            ],
          );
        });
  }

  Future<DocumentSnapshot> getUserDetails() async {
    DocumentSnapshot result = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_auth.currentUser.uid)
        .get();

    this.snapshot = result;
    notifyListeners();
    return result;
  }
}
