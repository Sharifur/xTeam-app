import 'package:flutter/material.dart';
import 'package:office_attendence/common/custom_preloader.dart';
import 'package:office_attendence/services/profile_info_service.dart';
import 'package:office_attendence/views/home_view/home_view.dart';
import 'package:office_attendence/views/login_view/login_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/common_helper.dart';
import '../helpers/responsive.dart';

class SplashView extends StatelessWidget {
  SplashView({super.key});
  ValueNotifier isLoading = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    screenSizeAndPlatform(context);
    initialize(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: cc.pureWhite,
                  child: Image.asset(
                    'assets/images/splash.png',
                    fit: BoxFit.cover,
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: isLoading,
                  builder: (context, value, child) => isLoading.value
                      ? Positioned(
                          bottom: screenWidth / 1.5, child: CustomPreloader())
                      : SizedBox(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  initialize(BuildContext context) async {
    final hasConnection = await checkConnection(context);
    if (!hasConnection) {
      snackBar(context, 'Connection failed!',
          buttonText: "Retry",
          backgroundColor: cc.red,
          duration: const Duration(minutes: 10), onTap: () {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        initialize(context);
      });
      return;
    }
    isLoading.value = true;
    final sp = await SharedPreferences.getInstance();
    final tok = sp.getString("nutsflsd");
    await setToken(tok);
    await Provider.of<ProfileInfoService>(context, listen: false)
        .getProfileInfo()
        .then((value) {
      if (value) {
        Navigator.of(context).pushReplacementNamed(HomeView.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(LoginView.routeName);
      }
    });
    isLoading.value = false;
  }
}
