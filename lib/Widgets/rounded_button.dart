import 'package:flutter/material.dart';
import 'package:rawcuts_pvt_ltd/Constants/colors.dart';
import 'package:rawcuts_pvt_ltd/Constants/style.dart';

class RoundedButton extends StatelessWidget {
  final String buttonName;

  RoundedButton({@required this.buttonName});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.08,
      width: size.width * 0.8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16), color: AppColors.primary),
      // ignore: deprecated_member_use
      child: TextButton(
        onPressed: () {},
        child: PrimaryText(
          text: buttonName,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
          size: 22,
        ),
      ),
    );
  }
}
