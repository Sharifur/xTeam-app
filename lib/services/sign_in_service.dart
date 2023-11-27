import 'package:flutter/material.dart';
import 'package:office_attendence/api_routes.dart';
import 'package:office_attendence/data/network/network_api_services.dart';
import 'package:office_attendence/helpers/common_helper.dart';

class SignInService with ChangeNotifier {
  signIn(email, password, keepLogin) async {
    final url = ApiRoutes.singInRoute + "?username=$email&password=$password";
    final responseData = await NetworkApiServices().postApi({}, url, "Sign In");
    if (responseData == null) {
      return false;
    }

    setToken(responseData['token'], remember: keepLogin);
    showToast("Sign in succeeded");

    return true;
  }
}
