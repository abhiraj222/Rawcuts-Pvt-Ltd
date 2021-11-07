import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';
import 'package:rawcuts_pvt_ltd/Constants/style.dart';
import 'package:rawcuts_pvt_ltd/Providers/location_provider.dart';
import 'package:rawcuts_pvt_ltd/Screens/map_screen.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:rawcuts_pvt_ltd/Screens/welcome_screen.dart';

import 'orders/order.dart';
import 'wishlist/wishlist.dart';
import 'cart/cart.dart';
import 'package:flutter/material.dart';

class UserrInfo extends StatefulWidget {
  static const String id = 'user_page';
  @override
  _UserrInfoState createState() => _UserrInfoState();
}

class _UserrInfoState extends State<UserrInfo> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String phoneNumber;
  String address;
  String name;
  var nameController = TextEditingController();
  final String ccNumber = 9707810806.toString();

  ScrollController _scrollController;
  var top = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      _getDataonRefresh();
    });
  }

  Future<String> _getDataonRefresh() async {
    User user = auth.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get()
          .then((value) {
        phoneNumber = value.get('number');
        address = value.get('address');
        name = value.get('Name');
      });
    }
    setState(() {});
  }

  Future updateUserData(String name) async {
    User user = auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('Users').doc(user.uid).update(
        {'Name': name},
      ).then((value) {
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var locationData = Provider.of<LocationProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                elevation: 4,
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  top = constraints.biggest.height;
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primary],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      centerTitle: true,
                      title: Row(
                        //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AnimatedOpacity(
                            duration: Duration(milliseconds: 300),
                            opacity: top <= 110.0 ? 1.0 : 0,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 12,
                                ),
                                Container(
                                  height: kToolbarHeight / 1.8,
                                  width: kToolbarHeight / 1.8,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white,
                                        blurRadius: 1.0,
                                      ),
                                    ],
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg'),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  // 'top.toString()',
                                  name ?? "Guest",
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      background: Image(
                        image: NetworkImage(
                            'https://cdn1.vectorstock.com/i/thumb-large/62/60/default-avatar-photo-placeholder-profile-image-vector-21666260.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
              ),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: userTitle('User Bag')),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Theme.of(context).splashColor,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WishlistPage()));
                          },
                          trailing: Icon(Icons.chevron_right_rounded),
                          title: PrimaryText(
                            text: ' Wishlist',
                            size: 18,
                          ),
                          leading: Icon(
                            Icons.favorite,
                            color: AppColors.primary,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: AppColors.primary,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CartPage()));
                          },
                          trailing: Icon(Icons.chevron_right_rounded),
                          title: PrimaryText(
                            text: ' Cart',
                            size: 18,
                          ),
                          leading: Icon(
                            Icons.shopping_cart,
                            color: AppColors.primary,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: AppColors.primary,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CartPage()));
                          },
                          trailing: Icon(Icons.chevron_right_rounded),
                          title: PrimaryText(
                            text: 'Orders',
                            size: 18,
                          ),
                          leading: Icon(
                            Icons.shopping_bag,
                            color: AppColors.primary,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: userTitle('User Information')),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),
                    RefreshIndicator(
                      onRefresh: _getDataonRefresh,
                      child: InkWell(
                        onTap: () {},
                        child: userListTile(
                            'Phone number', phoneNumber ?? '', 1, context),
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      title: PrimaryText(
                        text: 'Name',
                        fontWeight: FontWeight.w500,
                        size: 18,
                      ),
                      subtitle: PrimaryText(
                        text: name ?? 'Update Name',
                        size: 15,
                      ),
                      leading: Icon(
                        Icons.person,
                        color: AppColors.primary,
                        size: 30,
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text('Update Your Name'),
                              content: TextField(
                                controller: nameController,
                                decoration:
                                    InputDecoration(labelText: 'Enter Name'),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    updateUserData(nameController.text);
                                    setState(() {
                                      _getDataonRefresh();
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Icon(
                          Icons.edit,
                          color: AppColors.primary,
                          size: 30,
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      title: PrimaryText(
                        text: 'Location',
                        fontWeight: FontWeight.w500,
                        size: 18,
                      ),
                      subtitle: PrimaryText(
                        text: address ?? '',
                        size: 15,
                      ),
                      leading: Icon(
                        Icons.location_on,
                        color: AppColors.primary,
                        size: 30,
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          locationData.getCurrentPosition().then((value) {
                            pushNewScreenWithRouteSettings(context,
                                settings: RouteSettings(name: MapScreen.id),
                                screen: MapScreen(),
                                withNavBar: false,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino);
                          });
                        },
                        child: Icon(
                          Icons.edit,
                          color: AppColors.primary,
                          size: 30,
                        ),
                      ),
                    ),
                    userListTile(
                      'Status',
                      'Logged In',
                      3,
                      context,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: userTitle('User settings'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      title: PrimaryText(
                        text: 'Customer Support',
                        fontWeight: FontWeight.w500,
                        size: 18,
                      ),
                      subtitle: PrimaryText(
                        text: '9707810806',
                        size: 15,
                      ),
                      leading: Icon(
                        Icons.manage_accounts,
                        color: AppColors.primary,
                        size: 30,
                      ),
                      trailing: GestureDetector(
                        onTap: () async {
                          await FlutterPhoneDirectCaller.callNumber(ccNumber);
                        },
                        child: Icon(
                          Icons.phone,
                          color: AppColors.primary,
                          size: 30,
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        auth.signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomeScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      title: PrimaryText(
                        text: 'Logout',
                        fontWeight: FontWeight.w500,
                        size: 18,
                      ),
                      leading: Icon(
                        FontAwesomeIcons.signOutAlt,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
          // _buildFab()
        ],
      ),
    );
  }

  Widget _buildFab() {
    //starting fab position
    final double defaultTopMargin = 200.0 - 4.0;
    //pixels from top where scaling should start
    final double scaleStart = 160.0;
    //pixels from top where scaling should end
    final double scaleEnd = scaleStart / 2;

    double top = defaultTopMargin;
    double scale = 1.0;
    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      top -= offset;
      if (offset < defaultTopMargin - scaleStart) {
        //offset small => don't scale down
        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        //offset between scaleStart and scaleEnd => scale down
        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        //offset passed scaleEnd => hide fab
        scale = 0.0;
      }
    }

    return Positioned(
      top: top,
      right: 16.0,
      child: Transform(
        transform: Matrix4.identity()..scale(scale),
        alignment: Alignment.center,
        child: FloatingActionButton(
          backgroundColor: Colors.orangeAccent,
          heroTag: "btn1",
          onPressed: () {},
          child: Icon(Icons.camera_alt_outlined),
        ),
      ),
    );
  }

  List<IconData> _userTileIcons = [
    Icons.person,
    Icons.phone,
    Icons.location_on,
    Icons.lock
  ];
  List<IconData> _userTileIcons02 = [Icons.edit];

  Widget userListTile(
    String title,
    String subTitle,
    int index,
    BuildContext context,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: AppColors.primary,
        onTap: () {},
        child: ListTile(
          hoverColor: AppColors.primary,
          onTap: () {},
          title: PrimaryText(
            text: title,
            fontWeight: FontWeight.w500,
            size: 18,
          ),
          subtitle: PrimaryText(
            text: subTitle,
            size: 15,
          ),
          leading: InkWell(
            onTap: () {},
            child: Icon(
              _userTileIcons[index],
              color: AppColors.primary,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }

  Widget userListTile02(String title, String subTitle, int index,
      BuildContext context, int trailIndex) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: AppColors.primary,
        onTap: () {},
        child: ListTile(
          hoverColor: AppColors.primary,
          onTap: () {},
          title: PrimaryText(
            text: title,
            fontWeight: FontWeight.w500,
            size: 18,
          ),
          subtitle: PrimaryText(
            text: subTitle,
            size: 15,
          ),
          leading: Icon(
            _userTileIcons[index],
            color: AppColors.primary,
            size: 30,
          ),
          trailing: Icon(
            _userTileIcons02[trailIndex],
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget userTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: PrimaryText(
        text: title,
        fontWeight: FontWeight.bold,
        size: 23,
      ),
    );
  }
}
