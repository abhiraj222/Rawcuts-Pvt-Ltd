import 'package:flutter/foundation.dart';

class PopProduct with ChangeNotifier {
  final String id;
  final int quantity;
  final double price;
  final String title;
  final String imageURL;

  PopProduct({this.quantity, this.price, this.title, this.imageURL, this.id});
}
