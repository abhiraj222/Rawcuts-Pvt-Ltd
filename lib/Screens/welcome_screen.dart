import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';
import 'package:rawcuts_pvt_ltd/Constants/style.dart';
import 'package:rawcuts_pvt_ltd/Providers/auth_provider.dart';
import 'package:rawcuts_pvt_ltd/Providers/location_provider.dart';
import 'package:rawcuts_pvt_ltd/Screens/map_screen.dart';
import 'package:rawcuts_pvt_ltd/Screens/onboarding.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  Animation animation, delayedAnimation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);

    animation = Tween(begin: -1.0, end: 0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    delayedAnimation = Tween(begin: -1.0, end: 0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn)));

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    bool _validPhoneNumber = false;

    var _phoneNumberController = TextEditingController();

    void showBottomSheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, StateSetter myState) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: auth.error == 'Invalid OTP' ? true : false,
                      child: Container(
                        child: Column(
                          children: [
                            PrimaryText(
                              text: '${auth.error}',
                              color: Colors.red,
                              size: 12,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    PrimaryText(
                      text: 'Login',
                      size: 25,
                      color: AppColors.primary,
                    ),
                    PrimaryText(
                      text: 'Enter Your Phone Number to Process',
                      size: 15,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        focusColor: AppColors.primary,
                        prefixText: '+91',
                        labelText: '10 digit mobile number',
                      ),
                      autofocus: true,
                      maxLength: 10,
                      controller: _phoneNumberController,
                      onChanged: (value) {
                        if (value.length == 10) {
                          myState(() {
                            _validPhoneNumber = true;
                          });
                        } else {
                          myState(() {
                            _validPhoneNumber = false;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AbsorbPointer(
                            absorbing: _validPhoneNumber ? false : true,
                            // ignore: deprecated_member_use
                            child: FlatButton(
                              onPressed: () {
                                myState(() {
                                  auth.loading = true;
                                });
                                String number =
                                    '+91${_phoneNumberController.text}';
                                auth
                                    .verifyPhone(
                                        context: context,
                                        number: number,
                                        longitude: null,
                                        latitude: null,
                                        address: null)
                                    .then((value) {
                                  _phoneNumberController.clear();
                                  auth.loading = false;
                                });
                                // Navigator.pushNamed(context, MainScreen.id);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: _validPhoneNumber
                                  ? Colors.deepOrange
                                  : Colors.grey,
                              splashColor: AppColors.white,
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: auth.loading
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppColors.tertiary),
                                      )
                                    : PrimaryText(
                                        text: _validPhoneNumber
                                            ? 'PROCEED'
                                            : 'ENTER PHONE NUMBER',
                                        color: AppColors.white,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
    }

    final locationData = Provider.of<LocationProvider>(context, listen: false);

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return Scaffold(
          body: Transform(
            transform: Matrix4.translationValues(
                animation.value * MediaQuery.of(context).size.width, 0.0, 0.0),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(child: OnBoarding()),

                  PrimaryText(
                    text: 'Start Ordering Your Meat!',
                    size: 15,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // ignore: deprecated_member_use
                  Transform(
                    transform: Matrix4.translationValues(
                        delayedAnimation.value *
                            MediaQuery.of(context).size.width,
                        0.0,
                        0.0),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      color: Colors.deepOrange,
                      splashColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: locationData.loading
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.white),
                              )
                            : PrimaryText(
                                text: 'SET DELIVERY LOCATION',
                                color: AppColors.white,
                              ),
                      ),
                      onPressed: () async {
                        setState(() {
                          locationData.loading = true;
                        });

                        await locationData.getCurrentPosition();
                        if (locationData.permissionAllowed == true) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapScreen()),
                              (route) => false);
                          setState(() {
                            locationData.loading = false;
                          });
                        } else {
                          print('Permission not allowed');
                          setState(() {
                            locationData.loading = false;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // ignore: deprecated_member_use
                  // FlatButton(
                  //   color: Colors.transparent,
                  //   child: RichText(
                  //     text: TextSpan(
                  //         text: 'Already a Customer? ',
                  //         style:
                  //             TextStyle(color: AppColors.black, fontSize: 18),
                  //         children: [
                  //           TextSpan(
                  //               text: ' Login',
                  //               style: TextStyle(
                  //                   fontWeight: FontWeight.bold,
                  //                   color: AppColors.primary,
                  //                   fontSize: 18))
                  //         ]),
                  //   ),
                  //   onPressed: () {
                  //     setState(() {
                  //       auth.screen = 'screen';
                  //     });
                  //     showBottomSheet(context);
                  //   },
                  // )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
