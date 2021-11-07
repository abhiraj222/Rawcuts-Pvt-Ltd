import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';
import 'package:rawcuts_pvt_ltd/Constants/style.dart';
import 'package:rawcuts_pvt_ltd/Models/cart_attributes.dart';
import 'package:rawcuts_pvt_ltd/Models/order_attr.dart';
import 'package:rawcuts_pvt_ltd/Providers/cart_provider.dart';
import 'package:rawcuts_pvt_ltd/Services/global_method.dart';
import 'package:rawcuts_pvt_ltd/innerScreens/product_details.dart';

class OrderFull extends StatefulWidget {
  static const String id = 'order_full';
  final String productId;

  OrderFull({this.productId});

  @override
  _OrderFullState createState() => _OrderFullState();
}

class _OrderFullState extends State<OrderFull> {
  @override
  Widget build(BuildContext context) {
    GlobalMethods globalMethods = GlobalMethods();
    final cartAttr = Provider.of<CartAttributes>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final orderAttrProvider = Provider.of<OrderAttr>(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Expanded(
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, FoodDetail.id,
                  arguments: orderAttrProvider.productId);
            },
            child: Material(
              color: Colors.white,
              elevation: 15,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Container(
                height: 130,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.white),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                            image: NetworkImage(orderAttrProvider.imageURL),
                          )),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Flexible(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  orderAttrProvider.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                      fontSize: 15),
                                ),
                              ),
                              // Material(
                              //   color: Colors.transparent,
                              //   child: InkWell(
                              //     borderRadius: BorderRadius.circular(32),
                              //     onTap: () {
                              //       globalMethods.showDialogg(
                              //           'Remove',
                              //           'Do you want to remove this item from your cart?',
                              //           () => cartProvider
                              //               .removeItem(widget.productId),
                              //           context);
                              //     },
                              //     child: Container(
                              //       height: 50,
                              //       width: 50,
                              //       child: Icon(
                              //         Icons.close,
                              //         color: Colors.red,
                              //         size: 22,
                              //       ),
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: [
                              Text('Weight:'),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                orderAttrProvider.quantity.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total:'),
                              Text(
                                orderAttrProvider.price.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                width: 22,
                              ),
                              // Material(
                              //     color: Colors.transparent,
                              //     child: InkWell(
                              //       borderRadius: BorderRadius.circular(32),
                              //       onTap: cartAttr.quantity < 2
                              //           ? null
                              //           : () {
                              //               cartProvider.reduceCartItemByOne(
                              //                   widget.productId,
                              //                   cartAttr.price,
                              //                   cartAttr.title,
                              //                   cartAttr.imageURL);
                              //             },
                              //       child: Container(
                              //         height: 20,
                              //         width: 20,
                              //         child: Icon(
                              //           Icons.remove,
                              //           color: Colors.green,
                              //           size: 22,
                              //         ),
                              //       ),
                              //     )),
                              Card(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.11,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                    Colors.orange,
                                    Colors.orangeAccent
                                  ], stops: [
                                    0.0,
                                    0.7
                                  ])),
                                  child: Text(
                                    cartAttr.quantity.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(32),
                                    onTap: () {
                                      cartProvider.addProductToCart(
                                          widget.productId,
                                          cartAttr.price,
                                          cartAttr.title,
                                          cartAttr.imageURL);
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 10,
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                    ),
                                  )),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
