import 'package:animated_check/animated_check.dart';
import 'package:flutter/material.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';
import 'package:rawcuts_pvt_ltd/Constants/style.dart';

import 'mainscreen.dart';

class ThankYou extends StatefulWidget {
  @override
  _ThankYouState createState() => _ThankYouState();
}

class _ThankYouState extends State<ThankYou>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _animation = new Tween<double>(begin: 0, end: 1).animate(
        new CurvedAnimation(
            parent: _animationController, curve: Curves.easeInOutCirc));
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        PrimaryText(
          text: 'Order Confirmed!!',
          size: 30,
          color: Colors.green,
        ),
        Center(
          child: Container(
              height: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                  // color: Colors.red,
                  borderRadius: BorderRadius.circular(30)),
              child: AnimatedCheck(
                progress: _animation,
                size: 200,
                color: Colors.orange,
              )),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: PrimaryText(
            text: 'Thank You ',
            size: 20,
            color: Colors.black,
          ),
        ),
        PrimaryText(
          text: 'for Choosing our Service!',
          size: 20,
          color: Colors.black,
        ),
        SizedBox(
          height: 70,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.06,
          child: RaisedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                  (route) => false);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: AppColors.primary),
            ),
            color: AppColors.primary,
            child: Text(
              'Continue Shopping',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ]),
    );
  }
}
