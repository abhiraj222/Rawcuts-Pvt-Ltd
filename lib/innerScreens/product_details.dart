import 'package:badges/badges.dart';
import 'package:easy_loader/easy_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';
import 'package:rawcuts_pvt_ltd/Providers/cart_provider.dart';
import 'package:rawcuts_pvt_ltd/Providers/fav_provider.dart';
import 'package:rawcuts_pvt_ltd/Providers/products.dart';
import 'package:rawcuts_pvt_ltd/Screens/cart/cart.dart';
import 'package:rawcuts_pvt_ltd/Screens/home.dart';
import 'package:rawcuts_pvt_ltd/Screens/wishlist/wishlist.dart';
import '../Constants/style.dart';
import 'package:flutter_svg/svg.dart';

class FoodDetail extends StatefulWidget with ChangeNotifier {
  static const String id = 'Product _details';
  // final imagePath;
  // FoodDetail(this.imagePath);

  @override
  _FoodDetailState createState() => _FoodDetailState();
}

class _FoodDetailState extends State<FoodDetail>
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
        ColorTween(begin: AppColors.black, end: AppColors.tertiary)
            .animate(_controller);

    _sizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 40, end: 60), weight: 50),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 60, end: 40), weight: 50)
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
    final productsData = Provider.of<Products>(context, listen: false);
    final productList = productsData.products;
    final productId = ModalRoute.of(context).settings.arguments as String;
    final cartProvider = Provider.of<CartProvider>(context);
    final favsProvider = Provider.of<FavProvider>(context);
    print(productId);

    final productAttr = productsData.findById(productId);

    return Scaffold(
        floatingActionButton: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 30, minHeight: 70),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 0.66,
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: productAttr.inStock
                      ? RaisedButton(
                          onPressed:
                              cartProvider.getCartItems.containsKey(productId)
                                  ? () => null
                                  : () {
                                      cartProvider.addProductToCart(
                                          productId,
                                          productAttr.price.toInt(),
                                          productAttr.title,
                                          productAttr.imageURL);
                                      // ignore: deprecated_member_use

                                      // ignore: deprecated_member_use
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Row(
                                          children: [
                                            Icon(
                                              Icons.done,
                                              color: AppColors.white,
                                            ),
                                            SizedBox(width: 5),
                                            PrimaryText(
                                              text: 'Item Added To Cart',
                                              color: AppColors.white,
                                              size: 12,
                                            ),
                                          ],
                                        ),
                                        duration: Duration(seconds: 2),
                                        action: SnackBarAction(
                                          label: 'UNDO',
                                          textColor: Colors.amber,
                                          onPressed: () {
                                            cartProvider.removeItem(productId);
                                          },
                                        ),
                                      ));
                                    },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: AppColors.primary),
                          ),
                          color: AppColors.primary,
                          child: Text(
                            cartProvider.getCartItems.containsKey(productId)
                                ? 'In Cart'
                                : 'Add to Cart',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: AppColors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      : RaisedButton(
                          onPressed: () {},
                          child: Text('Out of Stock'),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            // side: BorderSide(color: AppColors.black),
                          ),
                          color: AppColors.lighterGray,
                        )),
              SizedBox(
                width: 30,
              ),
              AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, _) {
                  return InkWell(
                      onTap: () {
                        favsProvider.addAndRemoveFromFav(
                            productId,
                            productAttr.price.toInt(),
                            productAttr.title,
                            productAttr.imageURL);
                        isFav ? _controller.reverse() : _controller.forward();
                      },
                      child: Icon(
                        favsProvider.getFavsItems.containsKey(productId)
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        // color:
                        color: _colorAnimation.value,
                        size: _sizeAnimation.value,
                      ));
                },
              ),
            ],
          ),
        ),
        body: ListView(children: [
          customAppBar(context),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 25, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 4.5,
                        decoration: BoxDecoration(
                            // color: Colors.red,
                            borderRadius: BorderRadius.circular(30)),
                        child: Hero(
                          tag: 'product-img-${productAttr.id}',
                          child: Image.network(
                            productAttr.imageURL,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        PrimaryText(
                          text: productAttr.title,
                          fontWeight: FontWeight.w600,
                          size: 30,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/images/rupee.svg',
                      color: AppColors.tertiary,
                      width: 15,
                    ),
                    PrimaryText(
                      text: productAttr.price.toString(),
                      fontWeight: FontWeight.w700,
                      color: AppColors.tertiary,
                      height: 1,
                      size: 40,
                    ),
                  ],
                ),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PrimaryText(
                              text: 'Description',
                              size: 18,
                              color: AppColors.lightGray,
                              fontWeight: FontWeight.w500,
                            ),
                            Text(
                              productAttr.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            PrimaryText(
                              text: 'Weight',
                              size: 18,
                              color: AppColors.lightGray,
                              fontWeight: FontWeight.w500,
                            ),
                            PrimaryText(
                              text: productAttr.weight.toString(),
                              size: 18,
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            PrimaryText(
                              text: 'Delivery in',
                              size: 18,
                              color: AppColors.lightGray,
                              fontWeight: FontWeight.w500,
                            ),
                            PrimaryText(
                              text: '45 minuites',
                              size: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            PrimaryText(
                              text: productAttr.inStock
                                  ? 'Currently in Stock'
                                  : 'Currently Out of Stock',
                              size: 18,
                              color: productAttr.inStock
                                  ? Colors.green
                                  : Colors.red.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]));
  }

  Widget ingredientCard(String imagePath) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      margin: EdgeInsets.only(right: 20, top: 15, bottom: 25),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(blurRadius: 10, color: AppColors.lightGray)]),
      child: Image.asset(
        imagePath,
        width: 90,
      ),
    );
  }

  Padding customAppBar(BuildContext context) {
    final favsProvider = Provider.of<FavProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightGray),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(
                Icons.chevron_left_rounded,
              ),
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, CartPage.id);
                },
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.lightGray),
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.primary),
                  child: Badge(
                    badgeColor: AppColors.tertiary,
                    animationType: BadgeAnimationType.slide,
                    toAnimate: true,
                    position: BadgePosition.topEnd(top: 5, end: 7),
                    badgeContent: Text(
                        cartProvider.getCartItems.length.toString(),
                        style: TextStyle(color: AppColors.white)),
                    child: IconButton(
                      icon: Icon(
                        CupertinoIcons.shopping_cart,
                        color: AppColors.white,
                        size: 30,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightGray),
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.primary),
                child: Badge(
                  badgeColor: AppColors.tertiary,
                  animationType: BadgeAnimationType.slide,
                  toAnimate: true,
                  position: BadgePosition.topEnd(top: 5, end: 7),
                  badgeContent: Text(
                      favsProvider.getFavsItems.length.toString(),
                      style: TextStyle(color: AppColors.white)),
                  child: IconButton(
                    icon: Icon(
                      Icons.favorite_rounded,
                      color: AppColors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, WishlistPage.id);
                    },
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
