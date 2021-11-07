import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';
import 'package:rawcuts_pvt_ltd/Constants/style.dart';
import 'package:dots_indicator/dots_indicator.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final _controller = PageController(
    initialPage: 0,
  );

  int _currentPage = 0;

  List<Widget> _pages = [
    Column(
      children: [
        Expanded(child: Image.asset('assets/images/location.png')),
        PrimaryText(
          text: 'Free Delivery to Your Doorstep',
          color: Colors.orange,
          size: 20,
          fontWeight: FontWeight.w700,
        )
      ],
    ),
    // Column(
    //   children: [
    //     Expanded(child: Image.asset('assets/images/orderfood.png')),
    //     PrimaryText(
    //       text: '   Order LiveStock From \n the comfort of your Home',
    //       color: AppColors.primary,
    //       size: 20,
    //       fontWeight: FontWeight.w700,
    //     )
    //   ],
    // ),
    Column(
      children: [
        Expanded(
            child: Image.asset(
          'assets/images/courier.png',
          fit: BoxFit.contain,
        )),
        PrimaryText(
          text: 'No Hassles, Just Order and recieve',
          color: AppColors.primary,
          size: 17,
          fontWeight: FontWeight.w700,
        )
      ],
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: PageView(
            controller: _controller,
            children: _pages,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),
        SizedBox(height: 20),
        DotsIndicator(
          dotsCount: _pages.length,
          position: _currentPage.toDouble(),
          decorator: DotsDecorator(
            color: AppColors.lightGray,
            activeColor: AppColors.primary,
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
