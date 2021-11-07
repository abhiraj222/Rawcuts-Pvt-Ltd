import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:rawcuts_pvt_ltd/Models/order_attr.dart';
import 'package:rawcuts_pvt_ltd/Models/product.dart';

class OrderProvider with ChangeNotifier {
  List<OrderAttr> _orders = [];

  List<OrderAttr> get getOrders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User _user = _auth.currentUser;
    var _uid = _user.uid;
    await FirebaseFirestore.instance
        .collection('Orders')
        .where('userId', isEqualTo: _uid)
        .get()
        .then((QuerySnapshot ordersSnapshot) {
      _orders.clear();
      ordersSnapshot.docs.forEach((element) {
        _orders.insert(
          0,
          OrderAttr(
              orderId: element.get('orderId'),
              userId: element.get('userId'),
              productId: element.get('productId'),
              title: element.get('title'),
              price: element.get('price').toString(),
              imageURL: element.get('imageURL'),
              quantity: element.get('weight').toString(),
              orderDate: element.get('orderDate')),
        );
      });
    });
    // notifyListeners();
  }
}
