import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OrderAttr with ChangeNotifier {
  final String orderId;
  final String userId;
  final String productId;
  final String title;
  final String price;
  final String imageURL;
  final String quantity;
  final Timestamp orderDate;
  final String address;

  OrderAttr(
      {this.address,
      this.orderId,
      this.userId,
      this.productId,
      this.title,
      this.price,
      this.imageURL,
      this.quantity,
      this.orderDate});
}
