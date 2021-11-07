import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';
import 'package:rawcuts_pvt_ltd/Constants/style.dart';
import 'package:rawcuts_pvt_ltd/Models/get_number.dart';
import 'package:rawcuts_pvt_ltd/Providers/cart_provider.dart';
import 'package:rawcuts_pvt_ltd/Providers/products.dart';
import 'package:rawcuts_pvt_ltd/Screens/cart/cart_empty.dart';
import 'package:rawcuts_pvt_ltd/Screens/cart/cart_full.dart';
import 'package:rawcuts_pvt_ltd/Screens/thank_you.dart';
import 'package:uuid/uuid.dart';

class ConfirmPage extends StatefulWidget {
  static const String id = 'confirm_page';
  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return cartProvider.getCartItems.isEmpty
        ? Scaffold(body: CartEmpty())
        : Scaffold(
            appBar: AppBar(
              title: Center(
                  child: PrimaryText(
                text: 'Checkout Section (${cartProvider.getCartItems.length})',
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
}

Widget checkoutSection(BuildContext context, double subtotal) {
  final cartProvider = Provider.of<CartProvider>(context);
  FirebaseAuth auth = FirebaseAuth.instance;
  User user = auth.currentUser;
  final _uid = user.uid;
  String phoneNumber;
  String address;
  String deliveryAddress;
  Future<String> _getphNum() async {
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(_uid)
          .get()
          .then((value) {
        phoneNumber = value.get('number');
      });
    }
    return phoneNumber;
  }

  Future<String> _getaddress() async {
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(_uid)
          .get()
          .then((value) {
        address = value.get('address');
      });
    }
    return address;
  }

  _deliveryAddress() async {
    deliveryAddress = await _getaddress();
    return deliveryAddress;
  }

  var uuid = Uuid();
  return Container(
    height: 200,
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(color: Colors.black, width: 0.5),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Net Amount: \u{20B9} $subtotal (COD)',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins'),
              ),
            ],
          ),
          Center(
            child: PrimaryText(
              text:
                  'Delivery Time may vary according to location, Currently Delivering at Specific Locations in Jorhat',
              size: 12,
              color: Colors.red,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      title: Text("Confirm Order ?",
                          style: TextStyle(color: Colors.green)),
                      content: Text(
                          'We currently accept Payment on Delivery Only. You can pay via GPay or PhonePe or Cash  on Delivery'),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                          },
                          child: PrimaryText(
                            text: 'Cancel',
                            color: Colors.red,
                          ),
                        ),
                        FlatButton(
                          color: Colors.green,
                          onPressed: () {
                            cartProvider.getCartItems
                                .forEach((key, orderValue) async {
                              final productAttr =
                                  Provider.of<Products>(context, listen: false);
                              final specificProduct =
                                  productAttr.findById(orderValue.productId);
                              final phoneNumber = await _getphNum();
                              final deliveryAddress = await _getaddress();
                              final orderId = uuid.v4();
                              await FirebaseFirestore.instance
                                  .collection('Orders')
                                  .doc(orderId)
                                  .set({
                                'orderId': orderId,
                                'userId': _uid,
                                'weight': specificProduct.weight,
                                'title': orderValue.title,
                                'phoneNumber': phoneNumber,
                                'productId': orderValue.productId,
                                'price': orderValue.price,
                                'quantity': orderValue.quantity,
                                'imageURL': orderValue.imageURL,
                                'OrderDate': Timestamp.now(),
                                'DeliveryAddress': deliveryAddress
                              });
                            });
                            cartProvider.clearCart();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ThankYou()),
                                (route) => false);
                          },
                          child: PrimaryText(
                            text: "okay",
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.orangeAccent)),
                color: Colors.orangeAccent,
                child: Text(
                  'Order to current Address',
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
          )

          // ignore: deprecated_member_use
        ],
      ),
    ),
  );
}
