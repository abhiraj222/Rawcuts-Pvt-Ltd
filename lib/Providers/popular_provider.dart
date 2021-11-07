import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:rawcuts_pvt_ltd/Models/popular_model.dart';

class PopularProductsProvider with ChangeNotifier {
  List<PopProduct> _products = [];

  List<PopProduct> get products {
    return _products;
  }

  Future<void> fetchPopProducts() async {
    await FirebaseFirestore.instance
        .collection('PopularProducts')
        .get()
        .then((QuerySnapshot productsSnapshot) {
      _products = [];
      productsSnapshot.docs.forEach((element) {
        _products.insert(
            0,
            PopProduct(
                id: element.get('productId'),
                title: element.get('title'),
                price: double.parse(element.get('price')),
                imageURL: element.get('imageURL'),
                quantity: element.get('quantity')));
      });
    });
  }
}
