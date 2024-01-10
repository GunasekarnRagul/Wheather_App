import 'package:flutter/cupertino.dart';

class Dimensions
{
//   static double get screenHeight => Get.height;
//   static double get screenWidth => Get.width;
//   // 844
// // 390
//   static double get height200 => screenHeight / 0.2369;
//   static double get width200 => screenWidth / 0.5128;


  static  updateDimensions(BuildContext context,String orientation, double value) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    // print(screenHeight);
    // print(screenWidth);
    // print(value);
    // print(orientation);
    //
    // double height = screenHeight / value;
    //
    // print(height);
    //
    // print(screenHeight/height);

    if(orientation == 'h')
    {
      double height = screenHeight / value;
      return screenHeight/height;
    }
    else if(orientation == 'w')
    {
      double width = screenWidth / value;
      return screenWidth/width;
    }
    else
    {
      return null;
    }


  }
}