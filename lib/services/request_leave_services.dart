import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:office_attendence/api_routes.dart';
import 'package:office_attendence/data/network/network_api_services.dart';
import 'package:office_attendence/helpers/common_helper.dart';

class RequestLeaveServices with ChangeNotifier {
  final leaveOptions = ["Sick Leave", "Paid Leave", "Work From Home"];
  String? selectedOption = "Sick Leave";
  DateTime? selectedDay;

  setLeaveOption(value) {
    if (value == selectedOption) {
      return;
    }
    selectedOption = value;
    notifyListeners();
  }

  setDay(value) {
    if (value == selectedDay) {
      return;
    }
    selectedDay = value;
    notifyListeners();
  }

  disposeClass() {
    selectedOption = "Sick Leave";
    selectedDay = null;

    debugPrint("Clearing request service attributes".toString());
  }

  requestLeave() async {
    final date = DateFormat("dd-MMMM-yyyy").format(selectedDay!);
    final option = selectedOption!.replaceAll(" ", "-").toLowerCase();
    final url = ApiRoutes.requestLeaveRoute + "?date_time=$date&type=$option";
    final responseData =
        await NetworkApiServices().postApi({}, url, "Request Leave");

    if (responseData == null) {
      return false;
    }
    showToast("Request succeeded");

    return true;
  }
}
