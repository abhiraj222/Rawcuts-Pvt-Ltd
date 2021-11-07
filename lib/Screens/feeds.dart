import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';
import 'package:rawcuts_pvt_ltd/Constants/style.dart';
import 'package:rawcuts_pvt_ltd/Models/product.dart';
import 'package:rawcuts_pvt_ltd/Providers/products.dart';
import 'package:rawcuts_pvt_ltd/Widgets/feed_products.dart';

class FeedPage extends StatefulWidget {
  static const String id = 'feed_page';

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);

    List<Product> productList = productsProvider.products;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: PrimaryText(
          text: 'Explore',
          color: AppColors.white,
          size: 30,
          fontWeight: FontWeight.w500,
        ),
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          childAspectRatio: 240 / 400,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: List.generate(productList.length, (index) {
            return ChangeNotifierProvider.value(
                value: productList[index], child: FeedProducts());
          }),
        ),
      ),
    );
  }
}
