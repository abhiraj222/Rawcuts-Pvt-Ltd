import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';
import 'package:rawcuts_pvt_ltd/Constants/style.dart';
import 'package:rawcuts_pvt_ltd/Screens/feeds.dart';

class CartEmpty extends StatelessWidget {
  static const String id = 'cart_empty';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/emptycart.png'))),
            ),
            Text(
              'Your Basket is Empty!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 36, color: AppColors.black),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Looks like you didn\'t \n add anything to your basket yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 20, color: AppColors.black),
            ),
            SizedBox(
              height: 70,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.06,
              child: RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, FeedPage.id);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: AppColors.primary),
                ),
                color: AppColors.primary,
                child: Text(
                  'Order Now',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      color: AppColors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
