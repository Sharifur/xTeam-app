import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:office_attendence/helpers/common_helper.dart';
import 'package:office_attendence/services/attendance_service.dart';
import 'package:office_attendence/services/profile_info_service.dart';
import 'package:provider/provider.dart';

import '../../helpers/notification_hleper.dart';
import 'components/home_attendence.dart';
import 'components/home_drawer.dart';

class HomeView extends StatelessWidget {
  static const routeName = 'home_view';
  HomeView({super.key});
  bool isOpacityMode = true;

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  initiateNotification(BuildContext context) async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      NotificationHelper().triggerNotification(
          id: DateTime.now().millisecond.toInt(), bod: message.data);

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    // messaging.subscribeToTopic('all');
    final topic =
        "${Provider.of<ProfileInfoService>(context, listen: false).profileInfo?.userInfo?.id}";
    messaging.subscribeToTopic(topic);
  }

  @override
  Widget build(BuildContext context) {
    initiateNotification(context);
    ValueNotifier<bool> isLoading = ValueNotifier(false);
    final now = DateTime.now();
    ValueNotifier<DateTime> date =
        ValueNotifier(DateTime(now.year, now.month - 1));
    isOffDay(DateTime.now());
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        title:
            Consumer<ProfileInfoService>(builder: (context, piProvider, child) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              piProvider.profileInfo!.userInfo!.name!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("Xgenious"),
          );
        }),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final aProvider =
              Provider.of<AttendanceService>(context, listen: false);
          final result = await aProvider.getAttendance(date.value);
          if (result) {
            showToast("Refresh complete");
          } else {
            showToast("Refresh failed");
          }
          return result;
        },
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Column(
              children: [
                HomeAttendance(date: date, isLoading: isLoading),
              ],
            )
          ],
        ),
      ),
    );
  }

  isOffDay(DateTime date) {
    if (date.weekday == 5) {
      return 0;
    }
    return 1;
  }
}
