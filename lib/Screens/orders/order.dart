import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';
import 'package:rawcuts_pvt_ltd/Constants/style.dart';
import 'package:rawcuts_pvt_ltd/Providers/cart_provider.dart';
import 'package:rawcuts_pvt_ltd/Providers/order_provider.dart';
import 'package:rawcuts_pvt_ltd/Screens/orders/order_empty.dart';
import 'package:rawcuts_pvt_ltd/Screens/orders/order_full.dart';

class OrderPage extends StatefulWidget {
  static const String id = 'order_page';
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    // final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    return FutureBuilder(
        future: orderProvider.fetchOrders(),
        builder: (context, snapshot) {
          return orderProvider.getOrders.isEmpty
              ? Scaffold(body: OrderEmpty())
              : Scaffold(
                  appBar: AppBar(
                    title: Center(
                        child: PrimaryText(
                      text: 'My Orders (${orderProvider.getOrders.length})',
                      color: AppColors.white,
                      size: 25,
                      fontWeight: FontWeight.w500,
                    )),
                    backgroundColor: AppColors.primary,
                  ),
                  body: Container(
                    margin: EdgeInsets.only(bottom: 100),
                    child: ListView.builder(
                      itemCount: orderProvider.getOrders.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ChangeNotifierProvider.value(
                          value: orderProvider.getOrders[index],
                          child: OrderFull(),
                        );
                      },
                    ),
                  ),
                  // bottomSheet:
                  //     checkoutSection(context, cartProvider.totalAmount.toDouble()),
                );
        });
  }

  Widget checkoutSection(BuildContext context, double subtotal) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black, width: 0.5),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: ${subtotal}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins'),
            ),

            // ignore: deprecated_member_use
            RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.orangeAccent)),
              color: Colors.orangeAccent,
              child: Text(
                'Proceed To Checkout',
                textAlign: TextAlign.center,
                style: TextStyle(
                    // ignore: deprecated_member_use
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
