import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';
import 'package:rawcuts_pvt_ltd/Constants/style.dart';
import 'package:rawcuts_pvt_ltd/Providers/fav_provider.dart';
import 'package:rawcuts_pvt_ltd/Screens/wishlist/full_wishlist.dart';
import 'package:rawcuts_pvt_ltd/Screens/wishlist/wishlist_empty.dart';

class WishlistPage extends StatelessWidget {
  static const String id = 'wishlist_page';
  @override
  Widget build(BuildContext context) {
    final favsProvider = Provider.of<FavProvider>(context);
    return favsProvider.getFavsItems.isEmpty
        ? Scaffold(body: WishlistEmpty())
        : Scaffold(
            appBar: AppBar(
              elevation: 10,
              backgroundColor: AppColors.primary,
              title: Center(
                  child: PrimaryText(
                text: 'Your Wishlist (${favsProvider.getFavsItems.length})',
                size: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
              )),
            ),
            body: ListView.builder(
              itemCount: favsProvider.getFavsItems.length,
              itemBuilder: (BuildContext context, int index) {
                return ChangeNotifierProvider.value(
                    value: favsProvider.getFavsItems.values.toList()[index],
                    child: WishlistFull(
                      productId: favsProvider.getFavsItems.keys.toList()[index],
                    ));
              },
            ),
          );
  }
}
