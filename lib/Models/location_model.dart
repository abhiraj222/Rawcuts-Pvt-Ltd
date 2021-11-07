import 'package:flutter/cupertino.dart';

class Location with ChangeNotifier {
  final double leftBoundary;
  final double bottomBoundary;
  final double rightBoundary;
  final double topBoundary;

  Location(
      {this.leftBoundary,
      this.bottomBoundary,
      this.rightBoundary,
      this.topBoundary});
}
