import 'package:flutter/material.dart';

class FavAttributes with ChangeNotifier {
  final String id;
  final String title;

  final int price;
  final String imageURL;

  FavAttributes({this.id, this.title, this.price, this.imageURL});
}
