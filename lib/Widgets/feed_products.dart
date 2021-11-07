import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';
import 'package:rawcuts_pvt_ltd/Constants/style.dart';
import 'package:rawcuts_pvt_ltd/Models/product.dart';
import 'package:rawcuts_pvt_ltd/Widgets/feed_dialog.dart';
import 'package:rawcuts_pvt_ltd/innerScreens/product_details.dart';

class FeedProducts extends StatefulWidget {
  static const String id = 'feed_products';

  @override
  _FeedProductsState createState() => _FeedProductsState();
}

class _FeedProductsState extends State<FeedProducts>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(milliseconds: 800), vsync: this);

    animation = Tween(begin: -1.0, end: 0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAttributes = Provider.of<Product>(context);
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return Transform(
          transform: Matrix4.translationValues(
              animation.value * MediaQuery.of(context).size.width, 0.0, 0.0),
          child: Scaffold(
            body: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 10,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, FoodDetail.id,
                      arguments: productsAttributes.id);
                },
                child: Container(
                  width: 250,
                  height: 290,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.white),
                  child: Column(children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Hero(
                                tag: 'product-img-${productsAttributes.id}',
                                child: Image.network(
                                  productsAttributes.imageURL,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
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
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      margin: EdgeInsets.only(left: 5, bottom: 2, right: 3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            productsAttributes.description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 15,
                                color: AppColors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            productsAttributes.price.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 18,
                                color: AppColors.black,
                                fontWeight: FontWeight.w900),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                productsAttributes.weight.toString(),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            FeedDialog(
                                                productId:
                                                    productsAttributes.id));
                                  },
                                  borderRadius: BorderRadius.circular(18),
                                  splashColor: AppColors.primary,
                                  child: Icon(
                                    Icons.more_horiz_rounded,
                                    color: AppColors.tertiary,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
