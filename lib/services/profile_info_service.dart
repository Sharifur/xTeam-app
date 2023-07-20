import 'package:flutter/cupertino.dart';
import 'package:office_attendence/data/network/network_api_services.dart';
import 'package:office_attendence/models/profile_info_model.dart';

class ProfileInfoService with ChangeNotifier {
  ProfileInfoModel? profileInfo;

  logout() {
    profileInfo = null;
    notifyListeners();
  }

  getProfileInfo() async {
    final responseData = await NetworkApiServices().getApi("user/info", null);
    if (responseData == null) {
      return false;
    }
    profileInfo = ProfileInfoModel.fromJson(responseData);
    notifyListeners();
    return true;
  }
}
