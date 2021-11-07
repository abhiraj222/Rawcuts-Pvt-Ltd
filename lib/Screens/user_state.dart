import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rawcuts_pvt_ltd/Constants/style.dart';
import 'package:rawcuts_pvt_ltd/Screens/Auth/login_screen.dart';
import 'package:rawcuts_pvt_ltd/Screens/mainscreen.dart';

class UserState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            Center(
              child: CircularProgressIndicator(),
            );
          } else if (userSnapshot.connectionState == ConnectionState.active) {
            if (userSnapshot.hasData) {
              return MainScreen();
            } else {
              return SignInPage();
            }
          } else if (userSnapshot.hasError) {
            return Center(
              child: PrimaryText(
                text: 'Error Occured',
              ),
            );
          }
        });
  }
}
