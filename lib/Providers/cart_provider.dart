import 'package:flutter/cupertino.dart';
import 'package:rawcuts_pvt_ltd/Models/cart_attributes.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartAttributes> _cartItems = {};

  Map<String, CartAttributes> get getCartItems {
    return _cartItems;
  }

  int get totalAmount {
    var total = 0;
    _cartItems.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addProductToCart(
    String productId,
    int price,
    String title,
    String imageURL,
  ) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
          productId,
          (ExistingCartItem) => CartAttributes(
              id: ExistingCartItem.id,
              productId: ExistingCartItem.productId,
              price: ExistingCartItem.price,
              title: ExistingCartItem.title,
              quantity: ExistingCartItem.quantity + 1,
              imageURL: ExistingCartItem.imageURL));
    } else {
      _cartItems.putIfAbsent(
          productId,
          () => CartAttributes(
              id: DateTime.now().toString(),
              productId: productId,
              price: price,
              title: title,
              quantity: 1,
              imageURL: imageURL));
    }
    notifyListeners();
  }

  void reduceCartItemByOne(
      String productId, int price, String title, String imageURL) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
          productId,
          (ExistingCartItem) => CartAttributes(
              id: ExistingCartItem.id,
              productId: ExistingCartItem.productId,
              price: ExistingCartItem.price,
              title: ExistingCartItem.title,
              quantity: ExistingCartItem.quantity - 1,
              imageURL: ExistingCartItem.imageURL));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
  }
}
