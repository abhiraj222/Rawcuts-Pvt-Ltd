import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rawcuts_pvt_ltd/Constants/category.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';
import 'package:rawcuts_pvt_ltd/Constants/style.dart';
import 'package:rawcuts_pvt_ltd/Models/product.dart';
import 'package:rawcuts_pvt_ltd/Providers/cart_provider.dart';

import 'package:rawcuts_pvt_ltd/Providers/products.dart';
import 'package:rawcuts_pvt_ltd/Screens/user_profile.dart';
import 'package:rawcuts_pvt_ltd/Services/search_field.dart';

import 'package:rawcuts_pvt_ltd/Widgets/best_value.dart';
import 'package:rawcuts_pvt_ltd/innerScreens/category_feeds.dart';
import 'package:rawcuts_pvt_ltd/innerScreens/product_details.dart';

import 'feeds.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedCategoryCard = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    productsProvider.fetchProducts();
    final popularItems = productsProvider.popularProduct;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: Text(
          '  RawCuts',
          style: TextStyle(
              fontSize: 35,
              color: AppColors.white,
              fontFamily: 'rodfat-two-demo.ttf'),
        ),
      ),
      drawer: Drawer(
        backgroundColor: AppColors.primary,
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            children: [
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: AppColors.white,
                ),
                title: PrimaryText(
                  text: 'Profile',
                  color: AppColors.white,
                ),
                onTap: () {
                  Navigator.pushNamed(context, UserrInfo.id);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: AppColors.white,
                ),
                title: PrimaryText(
                  text: 'Profile',
                  color: AppColors.white,
                ),
                onTap: () {
                  Navigator.pushNamed(context, UserrInfo.id);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: AppColors.white,
                ),
                title: PrimaryText(
                  text: 'Profile',
                  color: AppColors.white,
                ),
                onTap: () {
                  Navigator.pushNamed(context, UserrInfo.id);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: AppColors.white,
                ),
                title: PrimaryText(
                  text: 'Profile',
                  color: AppColors.white,
                ),
                onTap: () {
                  Navigator.pushNamed(context, UserrInfo.id);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: AppColors.white,
                ),
                title: PrimaryText(
                  text: 'Profile',
                  color: AppColors.white,
                ),
                onTap: () {
                  Navigator.pushNamed(context, UserrInfo.id);
                },
              )
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Products').snapshots(),
          builder: (ctx, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }

            return ListView(scrollDirection: Axis.vertical, children: [
              Container(
                padding: EdgeInsets.only(
                  left: 20,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 10, right: 20),
                child: SearchField(),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 20),
                child: PrimaryText(
                  text: 'Categories',
                  fontWeight: FontWeight.w800,
                  size: 25,
                ),
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: foodCategoryList.length,
                    itemBuilder: (ctx, index) => Padding(
                          padding: EdgeInsets.only(left: index == 0 ? 20 : 0),
                          child: foodCategoryCard(
                              foodCategoryList[index]['imagePath'] ?? '',
                              foodCategoryList[index]['name'] ?? '',
                              index ?? ''),
                        )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: PrimaryText(
                        text: 'Best Value',
                        size: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, FeedPage.id);
                        },
                        child: PrimaryText(
                          color: AppColors.primary,
                          text: 'View all..',
                          size: 15,
                          fontWeight: FontWeight.w500,
                        )),
                  ],
                ),
              ),
              Container(
                height: 285,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 3),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: popularItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ChangeNotifierProvider.value(
                        value: popularItems[index],
                        child: BestValue(),
                      );
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30, top: 20),
                child: PrimaryText(
                  text: 'Popular ',
                  fontWeight: FontWeight.w800,
                  size: 25,
                ),
              ),
              Column(
                  children: List.generate(
                      snapshot.data.docs.length,
                      (index) => snapshot.data.docs[index]['isPopular']
                          ? popularFoodCard(
                              ctx,
                              snapshot.data.docs[index]['imageURL'] ?? '',
                              snapshot.data.docs[index]['title'] ?? '',
                              snapshot.data.docs[index]['weight'] ?? '',
                              snapshot.data.docs[index]['price'] ?? '',
                              snapshot.data.docs[index]['productId'] ?? '',
                              snapshot.data.docs[index]['inStock'] ?? '')
                          : Container()))
            ]);
          }),
    );
  }

  Widget foodCategoryCard(String imagePath, String name, int index) {
    return GestureDetector(
      onTap: () => {
        setState(
          () => {selectedCategoryCard = index},
        ),
      },
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(CategoryFeedPage.id,
              arguments: '${foodCategoryList[index]['name']}');
        },
        child: Container(
          margin: EdgeInsets.only(right: 25, top: 20, bottom: 20, left: 5),
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: selectedCategoryCard == index
                  ? AppColors.primary
                  : AppColors.white,
              boxShadow: [
                BoxShadow(color: AppColors.lighterGray, blurRadius: 10)
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                imagePath,
                height: 45,
                width: 45,
              ),
              PrimaryText(text: name, size: 16, fontWeight: FontWeight.w700),
              RawMaterialButton(
                onPressed: null,
                fillColor: selectedCategoryCard == index
                    ? AppColors.white
                    : AppColors.tertiary,
                shape: CircleBorder(),
                child: Icon(
                  Icons.chevron_right,
                  color: selectedCategoryCard == index
                      ? AppColors.secondary
                      : AppColors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget popularFoodCard(BuildContext context, String imagePath, String name,
    String weight, String price, String id, bool stock) {
  final cartProvider = Provider.of<CartProvider>(context);
  return GestureDetector(
    onTap: () => {Navigator.pushNamed(context, FoodDetail.id, arguments: id)},
    child: Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 25),
      decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(color: AppColors.lighterGray, blurRadius: 10),
          ],
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.1,
                        padding: EdgeInsets.only(left: 20, top: 20),
                        child: PrimaryText(
                          text: name,
                          fontWeight: FontWeight.w800,
                          size: 22,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, bottom: 20),
                      child: PrimaryText(
                        text: weight,
                        color: AppColors.lightGray,
                        size: 18,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 45, vertical: 18),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)),
                              color: AppColors.primary),
                          child: InkWell(
                            onTap: () {
                              stock
                                  ? () {
                                      cartProvider.addProductToCart(id,
                                          int.parse(price), name, imagePath);
                                    }
                                  : () {};
                              child:
                              Icon(
                                stock
                                    ? cartProvider.getCartItems.containsKey(id)
                                        ? Icons.shopping_cart
                                        : Icons.shopping_cart_outlined
                                    : null,
                                // color:
                                color: AppColors.white,
                              );
                            },
                            child: Icon(
                              Icons.shopping_cart,
                              size: 20,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Row(
                          children: [
                            PrimaryText(
                              text: '\u{20B9}$price',
                              fontWeight: FontWeight.w500,
                              size: 20,
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                child: Badge(
                  toAnimate: false,
                  shape: BadgeShape.square,
                  badgeColor: stock ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(5),
                  badgeContent: Text(
                    stock ? 'In Stock' : 'Out of Stock',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
          Container(
            transform: Matrix4.translationValues(10, 0, 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
            child: Hero(
              tag: 'product-img-$id',
              child: Image.network(imagePath,
                  width: MediaQuery.of(context).size.width / 3),
            ),
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    ),
  );
}
