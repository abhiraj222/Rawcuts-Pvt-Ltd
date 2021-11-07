import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';
import 'package:rawcuts_pvt_ltd/Constants/style.dart';
import 'package:rawcuts_pvt_ltd/Models/product.dart';
import 'package:rawcuts_pvt_ltd/Providers/cart_provider.dart';
import 'package:rawcuts_pvt_ltd/Providers/products.dart';
import 'package:rawcuts_pvt_ltd/innerScreens/product_details.dart';

class BestValue extends StatefulWidget {
  final String imageURL;
  final String name;
  final String price;
  final String quantity;

  BestValue({this.imageURL, this.name, this.price, this.quantity});

  @override
  State<BestValue> createState() => _BestValueState();
}

class _BestValueState extends State<BestValue>
    with SingleTickerProviderStateMixin {
  bool addWish = true;
  // ignore: non_constant_identifier_names
  AnimationController _controller;
  Animation<Color> _colorAnimation;
  Animation<double> _sizeAnimation;
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);

    _colorAnimation =
        ColorTween(begin: AppColors.primary, end: AppColors.primary)
            .animate(_controller);

    _sizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 30, end: 40), weight: 50),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 40, end: 30), weight: 50)
    ]).animate(_controller);

    _controller.addListener(() {
      print(_colorAnimation.value);
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isFav = true;
        });
      }
      if (status == AnimationStatus.dismissed) {
        setState(() {
          isFav = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAttributes = Provider.of<Product>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, FoodDetail.id,
              arguments: productsAttributes.id);
        },
        child: Material(
          shadowColor: AppColors.lightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 150,
                    width: 250,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Hero(
                        tag: 'product-img-${productsAttributes.imageURL}',
                        child: Center(
                            child: Image.network(productsAttributes.imageURL))),
                  ),
                  Positioned(
                    child: Badge(
                      toAnimate: false,
                      shape: BadgeShape.square,
                      badgeColor: productsAttributes.inStock
                          ? Colors.green
                          : Colors.red,
                      borderRadius: BorderRadius.circular(5),
                      badgeContent: Text(
                        productsAttributes.inStock
                            ? 'In Stock'
                            : 'Out of Stock',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: PrimaryText(
                      text: productsAttributes.title,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(
                    width: 45,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedBuilder(
                        animation: _controller,
                        builder: (BuildContext context, _) {
                          return InkWell(
                              onTap: productsAttributes.inStock
                                  ? () {
                                      cartProvider.addProductToCart(
                                          productsAttributes.id,
                                          productsAttributes.price.toInt(),
                                          productsAttributes.title,
                                          productsAttributes.imageURL);
                                      isFav
                                          ? _controller.reverse()
                                          : _controller.forward();
                                    }
                                  : () {},
                              child: Icon(
                                productsAttributes.inStock
                                    ? cartProvider.getCartItems
                                            .containsKey(productsAttributes.id)
                                        ? Icons.shopping_cart
                                        : Icons.shopping_cart_outlined
                                    : null,
                                // color:
                                color: _colorAnimation.value,
                                size: _sizeAnimation.value,
                              ));
                        }),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 2),
                    child: PrimaryText(
                        text: 'Price:', size: 15, color: AppColors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    child: PrimaryText(
                      text: '\u{20B9} ${productsAttributes.price.toString()}',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 2),
                    child: PrimaryText(
                      text: 'Weight: ',
                      size: 12,
                      color: AppColors.primary,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1),
                    child: PrimaryText(
                      text: productsAttributes.weight.toString(),
                      fontWeight: FontWeight.bold,
                      size: 15,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
