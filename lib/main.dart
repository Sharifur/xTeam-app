import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/helpers/push_notification_helper.dart';
import '/services/attendance_service.dart';
import '/services/profile_info_service.dart';
import '/services/request_leave_services.dart';
import '/services/request_list_service.dart';
import '/services/salary_info_service.dart';
import '/services/sign_in_service.dart';
import '/views/change_password_view/change_password_view.dart';
import 'views/login_view/login_view.dart';
import '/views/profile_edit_view/profile_edit_view.dart';
import '/views/request_leave_view/request_leave_view.dart';
import '/views/request_list_view/request_list_view.dart';
import '/views/salary_info_view/salary_info_view.dart';
import 'package:provider/provider.dart';

import 'helpers/constant_colors.dart';
import 'themes/default_themes.dart';
import 'views/home_view/home_view.dart';
import 'views/splash_view.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
triggerNotification({id, title, bod, payload}) {
  Map body = {};
  if (bod == String) {
    body = jsonDecode(bod);
  } else {
    body = bod;
  }
  flutterLocalNotificationsPlugin.cancelAll();
  flutterLocalNotificationsPlugin.show(
      body['id'] is String ? int.parse(body['id']) : body['id'],
      body['title'],
      body['body'],
      // DateTime.now().add(Duration(seconds: 10)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'id1',
          'channelName',
          priority: Priority.max,
          importance: Importance.max,
          visibility: NotificationVisibility.public,
          // actions: [AndroidNotificationAction('01', 'Done')],
        ),
      ),
      payload: 'chat_message');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // needed if you intend to initialize in the `main` function

  await configureLocalTimeZone();
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    onDidReceiveLocalNotification: (id, title, body, payload) {
      // staticFuctionOnForground();
    },
  );

  flutterLocalNotificationsPlugin.initialize(
    InitializationSettings(
      android: AndroidInitializationSettings('notification_icon'),
      iOS: initializationSettingsDarwin,
    ),
    onDidReceiveBackgroundNotificationResponse:
        PushNotificationHelper.staticFuctionOnForground,
    onDidReceiveNotificationResponse:
        PushNotificationHelper.staticFuctionOnForground,
  );
  final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  final bool? granted = await androidImplementation?.requestPermission();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }

  PushNotificationHelper.notificationDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
    statusBarIconBrightness: Brightness.dark,
  ));
  // ErrorWidget.builder = (details) {
  //   bool debugMode = false;
  //   assert(() {
  //     debugMode = true;
  //     return true;
  //   }());
  //   if (debugMode) {
  //     return ErrorWidget(details.exception);
  //   }
  //   return Scaffold(
  //     body: Container(
  //         alignment: Alignment.center,
  //         child: SingleChildScrollView(
  //           padding: const EdgeInsets.all(20),
  //           child: Column(
  //             children: [
  //               Text(
  //                 details.exception.toString(),
  //                 style: const TextStyle(
  //                   color: Colors.orangeAccent,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //               const Text(
  //                 'An error ocurred with the app, please contact the developer',
  //                 style: TextStyle(
  //                   color: Colors.orangeAccent,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //             ],
  //           ),
  //         )),
  //   );
  // };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProfileInfoService()),
        ChangeNotifierProvider(create: (context) => RequestLeaveServices()),
        ChangeNotifierProvider(create: (context) => SignInService()),
        ChangeNotifierProvider(create: (context) => AttendanceService()),
        ChangeNotifierProvider(create: (context) => RequestListService()),
        ChangeNotifierProvider(create: (context) => SalaryInfoService()),
      ],
      child: MaterialApp(
        title: 'Attendance',
        builder: (context, rtlchild) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: rtlchild!,
          );
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: cc.blackColor),
            bodySmall: TextStyle(color: cc.blackColor),
            titleLarge: TextStyle(color: cc.blackColor),
            titleMedium: TextStyle(color: cc.blackColor),
            bodyMedium: TextStyle(color: cc.blackColor),
          ),
          radioTheme: DefaultThemes().radioThemeData(context),
          elevatedButtonTheme: DefaultThemes().elevatedButtonTheme(context),
          outlinedButtonTheme: DefaultThemes().outlinedButtonTheme(context),
          inputDecorationTheme: DefaultThemes().inputDecorationTheme(context),
          checkboxTheme: DefaultThemes().checkboxTheme(context),
          appBarTheme: DefaultThemes().appBarTheme(context),
          switchTheme: DefaultThemes().switchThemeData(),
          scaffoldBackgroundColor: Colors.white,
        ),
        home: SplashView(),
        routes: {
          HomeView.routeName: (context) => HomeView(),
          LoginView.routeName: (context) => LoginView(),
          RequestLeaveView.routeName: (context) => const RequestLeaveView(),
          RequestListView.routeName: (context) => RequestListView(),
          ChangePasswordView.routeName: (context) => const ChangePasswordView(),
          ProfileEditView.routeName: (context) => ProfileEditView(),
          SalaryInfoView.routeName: (context) => SalaryInfoView(),
        },
      ),
    );
  }
}
