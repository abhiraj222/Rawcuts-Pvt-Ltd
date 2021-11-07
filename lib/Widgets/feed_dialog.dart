import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';
import 'package:rawcuts_pvt_ltd/Providers/cart_provider.dart';
import 'package:rawcuts_pvt_ltd/Providers/fav_provider.dart';
import 'package:rawcuts_pvt_ltd/Providers/products.dart';
import 'package:rawcuts_pvt_ltd/innerScreens/product_details.dart';

class FeedDialog extends StatelessWidget {
  static const String id = 'Feed_dialog';
  final String productId;
  const FeedDialog({@required this.productId});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: false);
    final productList = productsData.products;

    final cartProvider = Provider.of<CartProvider>(context);
    final favsProvider = Provider.of<FavProvider>(context);

    final productAttr = productsData.findById(productId);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Column(children: [
          Container(
            constraints: BoxConstraints(
                minHeight: 100,
                maxHeight: MediaQuery.of(context).size.height * 0.5),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.white,
            ),
            child: Image.network(productAttr.imageURL),
          ),
          Container(
            color: AppColors.white,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: dialogContent(
                        context,
                        0,
                        () => {
                              favsProvider.addAndRemoveFromFav(
                                  productId,
                                  productAttr.price.toInt(),
                                  productAttr.title,
                                  productAttr.imageURL),
                              Navigator.canPop(context)
                                  ? Navigator.pop(context)
                                  : null
                            }),
                  ),
                  Flexible(
                    child: dialogContent(
                        context,
                        1,
                        () => {
                              Navigator.pushNamed(context, FoodDetail.id,
                                      arguments: productAttr.id)
                                  .then((value) => Navigator.canPop(context)
                                      ? Navigator.pop(context)
                                      : null),
                            }),
                  ),
                  Flexible(
                    child: dialogContent(
                        context,
                        2,
                        cartProvider.getCartItems.containsKey(productId)
                            ? () {}
                            : () {
                                cartProvider.addProductToCart(
                                    productId,
                                    productAttr.price.toInt(),
                                    productAttr.title,
                                    productAttr.imageURL);
                                Navigator.canPop(context)
                                    ? Navigator.pop(context)
                                    : null;
                              }),
                  ),
                ]),
          ),

          /************close****************/
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.3),
                shape: BoxShape.circle),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                splashColor: Colors.grey,
                onTap: () =>
                    Navigator.canPop(context) ? Navigator.pop(context) : null,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.close, size: 28, color: Colors.white),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget dialogContent(BuildContext context, int index, Function fct) {
    final cart = Provider.of<CartProvider>(context);
    final favs = Provider.of<FavProvider>(context);
    List<IconData> _dialogIcons = [
      favs.getFavsItems.containsKey(productId)
          ? Icons.favorite
          : Icons.favorite_border,
      Icons.remove_red_eye_sharp,
      cart.getCartItems.containsKey(productId)
          ? Icons.shopping_cart
          : Icons.shopping_cart_outlined,
      Icons.delete_rounded,
    ];

    List<String> _texts = [
      favs.getFavsItems.containsKey(productId)
          ? 'In wishlist'
          : 'Add to wishlist',
      'View product',
      cart.getCartItems.containsKey(productId) ? 'In Cart ' : 'Add to cart',
    ];
    List<Color> _colors = [
      favs.getFavsItems.containsKey(productId) ? Colors.red : AppColors.black,
      AppColors.black,
      favs.getFavsItems.containsKey(productId)
          ? AppColors.tertiary
          : AppColors.black
    ];

    return FittedBox(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: fct,
          splashColor: Colors.grey,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.25,
            padding: EdgeInsets.all(4),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    // inkwell color
                    child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(
                          _dialogIcons[index],
                          color: _colors[index],
                          size: 25,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(
                    child: Text(
                      _texts[index],
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          //  fontSize: 15,
                          color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
