import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

class NotificationHelper {
  notificationAppLaunchChecker(
      BuildContext context, notificationDetails) async {
    print((notificationDetails?.notificationResponse?.payload).toString() +
        'App launch notification details');
    if (notificationDetails != null) {
      if (notificationDetails?.notificationResponse?.payload ==
          'chat_message') {
        print('from app launch');
        await Future.delayed(Duration(milliseconds: 10));
        // Navigator.pushNamed(context, ChatView.routeName);
      }
      notificationDetails = null;
    }
  }

  // streamListener(BuildContext context) {
  //   selectNotificationStream.stream.listen(
  //     (event) async {
  //       bool notNavigated = true;
  //       if (event == 'chat_message' && notNavigated) {
  //         print('from app foreground');
  //         notNavigated = false;
  //         await Future.delayed(Duration(milliseconds: 10));
  //         Navigator.pushNamed(context, ChatView.routeName);
  //         // selectNotificationStream.close();
  //       }

  //       // selectNotificationStream.close();
  //       // streamListener(context);

  //       notificationDetails = null;
  //     },
  //   );
  // }
}
