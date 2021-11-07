import 'package:flutter/cupertino.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageURL;
  final String productCategoryName;
  final bool isPopular;
  final bool inStock;

  final String weight;

  Product(
      {this.id,
      this.title,
      this.description,
      this.price,
      this.imageURL,
      this.productCategoryName,
      this.weight,
      this.isPopular,
      this.inStock});
}
