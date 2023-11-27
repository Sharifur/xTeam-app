import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';
import 'notification_hleper.dart';

class PushNotificationHelper {
  static final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();

  static NotificationAppLaunchDetails? notificationDetails;

  static String? selectedNotificationPayload;

  static staticFuctionOnForground(details) {
    print(details.payload);
    selectedNotificationPayload = details.payload;
    selectNotificationStream.add('chat_message');
    print(details.payload);
  }
}

staticFuctionOnBackground(NotificationResponse details) {
  print(details.payload);
  // selectedNotificationPayload = details.payload;
  // selectNotificationStream.add('chat_message');
  print(details.payload);
}

bool isFlutterLocalNotificationsInitialized = false;
Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

Future<void> configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await setupFlutterNotifications();
  debugPrint(message.data.toString());
  triggerNotification(
    id: DateTime.now().day,
    bod: message.data,
  );
  print('Handling a background message ${message.messageId}');
}
