import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constant_colors.dart';

ConstantColors cc = ConstantColors();

const String baseApi = '';

String _token = '';

String get token {
  return _token;
}

setToken(token) async {
  _token = token ?? '';
  final sp = await SharedPreferences.getInstance();
  sp.setString("nutsflsd", token ?? '');
}

// late AppStringService asProvider;

// initiateAppStringProvider(BuildContext context) {
//   asProvider = Provider.of<AppStringService>(context, listen: false);
// }

snackBar(BuildContext context, String content,
    {String? buttonText,
    void Function()? onTap,
    Color? backgroundColor,
    duration}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(

      // width: screenWidth - 100,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.all(5),
      backgroundColor: backgroundColor ?? cc.primaryColor,
      duration: duration ?? const Duration(seconds: 2),
      content: Row(
        children: [
          Text(
            content,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          if (buttonText != null)
            GestureDetector(
              onTap: onTap,
              child: Text(buttonText),
            )
        ],
      )));
}

void showToast(String msg, {Color? color}) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color ?? Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}

Future<bool> checkConnection(BuildContext context) async {
  // final asProvider = Provider.of<AppStringService>(context, listen: false);
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    showToast("Please turn on your internet connection", color: Colors.black);
    return false;
  } else {
    return true;
  }
}
