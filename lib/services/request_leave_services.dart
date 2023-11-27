import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:office_attendence/api_routes.dart';
import 'package:office_attendence/data/network/network_api_services.dart';
import 'package:office_attendence/helpers/common_helper.dart';

class RequestLeaveServices with ChangeNotifier {
  final leaveOptions = ["Sick Leave", "Paid Leave", "Work From Home"];
  String? selectedOption = "Sick Leave";
  DateTime? selectedDay;
  DateTimeRange? dateTimeRange;

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

  setDateRange(value) {
    if (value == dateTimeRange) {
      return;
    }
    dateTimeRange = value;
    notifyListeners();
  }

  disposeClass() {
    selectedOption = "Sick Leave";
    selectedDay = null;

    debugPrint("Clearing request service attributes".toString());
  }

  requestLeave() async {
    debugPrint((dateTimeRange).toString());
    debugPrint((selectedDay).toString());
    final date =
        DateFormat("dd-MMMM-yyyy").format(dateTimeRange?.start ?? selectedDay!);
    final endDate = dateTimeRange?.end != null
        ? DateFormat("dd-MMMM-yyyy").format(dateTimeRange!.end)
        : "";
    final option = selectedOption!.replaceAll(" ", "-").toLowerCase();
    final url = ApiRoutes.requestLeaveRoute +
        "?date_time=$date&end_date=$endDate&type=$option";
    debugPrint(url.toString());
    final responseData =
        await NetworkApiServices().postApi({}, url, "Request Leave");

    if (responseData == null) {
      return false;
    }
    showToast("Request succeeded");

    return true;
  }
}
