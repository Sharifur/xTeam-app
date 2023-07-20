import 'package:office_attendence/api_routes.dart';
import 'package:office_attendence/data/network/network_api_services.dart';
import 'package:office_attendence/helpers/common_helper.dart';

class ChangePasswordService {
  changePassword(password) async {
    final url = ApiRoutes.changePassword +
        "?password=$password&password_confirmation=$password";
    final respnseData =
        await NetworkApiServices().postApi({}, url, "Password Change");
    if (respnseData == null) {
      return;
    }
    showToast("Password changed");
  }
}
