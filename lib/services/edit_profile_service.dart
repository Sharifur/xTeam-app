import 'package:office_attendence/api_routes.dart';
import 'package:office_attendence/data/network/network_api_services.dart';
import 'package:office_attendence/helpers/common_helper.dart';

class EditProfileService {
  editProfile(name, email, phone, address) async {
    final url = ApiRoutes.editProfile +
        "?email=$email&name=$name&phone=$phone&address=$address";

    final responseApi =
        await NetworkApiServices().postApi({}, url, "Edit Profile");

    if (responseApi == null) {
      return false;
    }
    showToast("Edit profile succeeded");
    return true;
  }
}
