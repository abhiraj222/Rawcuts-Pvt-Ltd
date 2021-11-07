import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';
import 'package:rawcuts_pvt_ltd/Constants/style.dart';
import 'package:rawcuts_pvt_ltd/Providers/location_provider.dart';
import 'package:rawcuts_pvt_ltd/Providers/popular_provider.dart';
import 'package:rawcuts_pvt_ltd/Providers/products.dart';
import 'package:rawcuts_pvt_ltd/Screens/confirm_page.dart';
import 'package:rawcuts_pvt_ltd/Screens/feeds.dart';
import 'package:rawcuts_pvt_ltd/Screens/Auth/sign_up.dart';
import 'package:rawcuts_pvt_ltd/Screens/map_screen.dart';
import 'package:rawcuts_pvt_ltd/Screens/orders/order.dart';
import 'package:rawcuts_pvt_ltd/Screens/splash_screen.dart';
import 'package:rawcuts_pvt_ltd/innerScreens/category_feeds.dart';
import 'package:rawcuts_pvt_ltd/innerScreens/product_details.dart';
import 'Providers/auth_provider.dart';
import 'Providers/cart_provider.dart';
import 'Providers/fav_provider.dart';
import 'Providers/order_provider.dart';
import 'Screens/cart/cart.dart';
import 'Screens/Auth/login_screen.dart';
import 'Screens/mainscreen.dart';
import 'Screens/home.dart';
import 'Screens/user_profile.dart';
import 'Screens/wishlist/wishlist.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: PrimaryText(
                    text: 'Error Occurred',
                  ),
                ),
              ),
            );
          }
          return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) {
                  return Products();
                }),
                ChangeNotifierProvider(create: (_) {
                  return CartProvider();
                }),
                ChangeNotifierProvider(create: (_) {
                  return FavProvider();
                }),
                ChangeNotifierProvider(create: (_) {
                  return AuthProvider();
                }),
                ChangeNotifierProvider(create: (_) {
                  return LocationProvider();
                }),
                ChangeNotifierProvider(create: (_) {
                  return PopularProductsProvider();
                }),
                ChangeNotifierProvider(create: (_) {
                  return OrderProvider();
                })
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Rawcuts',
                theme: ThemeData(primaryColor: AppColors.white),
                home: SplashScreen(),
                routes: {
                  MainScreen.id: (context) => MainScreen(),
                  HomePage.id: (context) => HomePage(),
                  CartPage.id: (context) => CartPage(),
                  CategoryFeedPage.id: (context) => CategoryFeedPage(),
                  FeedPage.id: (context) => FeedPage(),
                  FoodDetail.id: (context) => FoodDetail(),
                  WishlistPage.id: (context) => WishlistPage(),
                  UserrInfo.id: (context) => UserrInfo(),
                  SignUpPage.id: (context) => SignUpPage(),
                  SignInPage.id: (context) => SignInPage(),
                  SplashScreen.id: (context) => SplashScreen(),
                  MapScreen.id: (context) => MapScreen(),
                  ConfirmPage.id: (context) => ConfirmPage(),
                  OrderPage.id: (context) => OrderPage()
                },
              ));
        });
  }
}
