import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';
import 'package:rawcuts_pvt_ltd/Constants/style.dart';

import 'package:rawcuts_pvt_ltd/Providers/cart_provider.dart';
import 'package:rawcuts_pvt_ltd/Screens/cart/cart_empty.dart';
import 'package:rawcuts_pvt_ltd/Screens/cart/cart_full.dart';
import 'package:rawcuts_pvt_ltd/Screens/confirm_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  static const String id = 'cart_page';
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return cartProvider.getCartItems.isEmpty
        ? Scaffold(body: CartEmpty())
        : Scaffold(
            appBar: AppBar(
              title: Center(
                  child: PrimaryText(
                text: 'Your Basket (${cartProvider.getCartItems.length})',
                color: AppColors.white,
                size: 25,
                fontWeight: FontWeight.w500,
              )),
              backgroundColor: AppColors.primary,
            ),
            body: Container(
              margin: EdgeInsets.only(bottom: 100),
              child: ListView.builder(
                itemCount: cartProvider.getCartItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return ChangeNotifierProvider.value(
                    value: cartProvider.getCartItems.values.toList()[index],
                    child: CartFull(
                      productId: cartProvider.getCartItems.keys.toList()[index],
                    ),
                  );
                },
              ),
            ),
            bottomSheet:
                checkoutSection(context, cartProvider.totalAmount.toDouble()),
          );
  }

  Widget checkoutSection(BuildContext context, double subtotal) {
    final cartProvider = Provider.of<CartProvider>(context);
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    final _uid = user.uid;
    String phoneNumber;
    String address;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black, width: 0.5),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: \u{20B9} $subtotal',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins'),
            ),

            // ignore: deprecated_member_use
            RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              onPressed: () {
                Navigator.pushNamed(context, ConfirmPage.id);
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.orangeAccent)),
              color: Colors.orangeAccent,
              child: Text(
                'Proceed',
                textAlign: TextAlign.center,
                style: TextStyle(
                    // ignore: deprecated_member_use
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
