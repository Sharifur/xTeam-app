import 'package:flutter/material.dart';

import '../../helpers/common_helper.dart';

snackBar(BuildContext context, String content,
    {String? buttonText, void Function()? onTap, Color? backgroundColor}) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(

      // width: screenWidth - 100,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.all(5),
      backgroundColor: backgroundColor ?? cc.primaryColor,
      duration: const Duration(seconds: 2),
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
