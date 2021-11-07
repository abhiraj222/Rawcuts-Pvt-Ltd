import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:rawcuts_pvt_ltd/Models/product.dart';

class Products with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products {
    return _products;
  }

  Future<void> fetchProducts() async {
    await FirebaseFirestore.instance
        .collection('Products')
        .get()
        .then((QuerySnapshot productsSnapshot) {
      _products = [];
      productsSnapshot.docs.forEach((element) {
        _products.insert(
          0,
          Product(
              id: element.get('productId'),
              title: element.get('title'),
              description: element.get('description'),
              price: double.parse(element.get('price')),
              imageURL: element.get('imageURL'),
              productCategoryName: element.get('productCategoryName'),
              weight: element.get('weight'),
              isPopular: element.get('isPopular'),
              inStock: element.get('inStock')),
        );
      });
    });
    notifyListeners();
  }

  List<Product> get popularProduct {
    return _products.where((element) => element.isPopular).toList();
  }

  Product findById(String productId) {
    return _products.firstWhere((element) => element.id == productId);
  }

  List<Product> findByCategory(String categoryName) {
    List _categoryList = _products
        .where((element) => element.productCategoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();
    return _categoryList;
  }
}
