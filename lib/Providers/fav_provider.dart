import 'package:flutter/cupertino.dart';
import 'package:rawcuts_pvt_ltd/Models/fav_attributes.dart';

class FavProvider with ChangeNotifier {
  Map<String, FavAttributes> _favItems = {};

  Map<String, FavAttributes> get getFavsItems {
    return _favItems;
  }

  void addAndRemoveFromFav(
      String productId, int price, String title, String imageURL) {
    if (_favItems.containsKey(productId)) {
      removeItem(productId);
    } else {
      _favItems.putIfAbsent(
          productId,
          () => FavAttributes(
              id: DateTime.now().toString(),
              price: price,
              title: title,
              imageURL: imageURL));
    }
    notifyListeners();
  }

  void reduceCartItemByOne(
      String productId, int price, String title, String imageURL) {
    if (_favItems.containsKey(productId)) {
      _favItems.update(
          productId,
          (ExistingCartItem) => FavAttributes(
              id: ExistingCartItem.id,
              price: ExistingCartItem.price,
              title: ExistingCartItem.title,
              imageURL: ExistingCartItem.imageURL));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _favItems.remove(productId);
    notifyListeners();
  }
}
