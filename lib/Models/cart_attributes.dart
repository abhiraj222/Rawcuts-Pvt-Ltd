import 'package:flutter/material.dart';

class CartAttributes with ChangeNotifier {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final int price;
  final String imageURL;
  final String weight;

  CartAttributes(
      {this.productId,
      this.id,
      this.weight,
      this.title,
      this.quantity,
      this.price,
      this.imageURL});
}
