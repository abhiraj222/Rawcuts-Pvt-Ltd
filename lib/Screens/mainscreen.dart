import 'package:badges/badges.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';
import 'package:rawcuts_pvt_ltd/Providers/cart_provider.dart';
import 'package:rawcuts_pvt_ltd/Providers/fav_provider.dart';
import 'package:rawcuts_pvt_ltd/Screens/orders/order.dart';
import 'home.dart';
import 'feeds.dart';
import 'cart/cart.dart';
import 'user_profile.dart';
import 'wishlist/wishlist.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'main_screen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List _pages;

  int _selectedindex = 2;

  @override
  void initState() {
    _pages = [FeedPage(), CartPage(), HomePage(), UserrInfo(), CartPage()];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final favsProvider = Provider.of<FavProvider>(context);
    return Scaffold(
      body: _pages[_selectedindex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedindex,
        onTap: (index) {
          setState(() {
            _selectedindex = index;
          });
        },
        color: Colors.white,
        backgroundColor: Colors.orangeAccent,
        buttonBackgroundColor: Colors.white,
        height: 50,
        items: <Widget>[
          Icon(
            Icons.explore_rounded,
            size: 30,
            color: Colors.black87,
          ),
          Badge(
            badgeColor: AppColors.tertiary,
            animationType: BadgeAnimationType.slide,
            animationDuration: Duration(milliseconds: 1000),
            toAnimate: true,
            position: BadgePosition.topEnd(top: 10, end: -5),
            badgeContent: Text(cartProvider.getCartItems.length.toString(),
                style: TextStyle(color: AppColors.white)),
            child: Icon(
              Icons.shopping_bag,
              size: 30,
              color: Colors.black87,
            ),
          ),
          Icon(
            Icons.home,
            size: 30,
            color: Colors.black87,
          ),
          Icon(
            Icons.person,
            size: 30,
            color: Colors.black87,
          ),
          Icon(
            Icons.shopping_basket,
            size: 30,
            color: Colors.black87,
          ),
        ],
        animationDuration: Duration(milliseconds: 400),
        animationCurve: Curves.easeInOutQuart,
      ),
    );
  }
}
