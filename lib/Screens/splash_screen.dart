import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';

import 'package:rawcuts_pvt_ltd/Screens/mainscreen.dart';

import 'package:rawcuts_pvt_ltd/Screens/welcome_screen.dart';

import 'Auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: AnimatedSplashScreen(
        duration: 10,
        splash: Center(
          child: Container(
            child: Image.asset(
              'assets/images/splash.png',
            ),
          ),
        ),
        splashTransition: SplashTransition.fadeTransition,
        nextScreen: FirebaseAuth.instance.currentUser == null
            ? WelcomeScreen()
            : MainScreen(),
        splashIconSize: 150,
      ),
    );
  }
}
