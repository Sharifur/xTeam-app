import 'dart:io';

import 'package:flutter/material.dart';

late bool isIos;
late bool isAndroid;

late double screenWidth;
late double screenHeight;

getScreenSize(BuildContext context) {
  screenWidth = MediaQuery.of(context).size.width;
  screenHeight = MediaQuery.of(context).size.height;
}

screenSizeAndPlatform(BuildContext context) {
  getScreenSize(context);
  checkPlatform();
}
//responsive screen codes ========>

var fourinchScreenHeight = 610;
var fourinchScreenWidth = 385;

checkPlatform() {
  isAndroid = Platform.isAndroid;
  isIos = Platform.isIOS;
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
