import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:office_attendence/api_routes.dart';
import 'package:office_attendence/data/network/network_api_services.dart';

class AttendanceService with ChangeNotifier {
  var attendanceInfo;
  var logs = {};
  Map<DateTime, int>? calenderData;
  var firstDay = 1;
  int maxDays = 30;
  List<String> get months {
    List<String> list = [];
    final now = DateTime.now();
    // for (var i = 1; i < 13; i++) {
    //   list.add(DateFormat("MMMM").format(now.subtract(Duration(days: 30 * i))));
    // }
    list = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    debugPrint(list.toString());
    return list;
  }

  final colors = {
    0: const Color.fromARGB(255, 74, 170, 42), //Off day
    1: Color(0xff9DB2BF), //Off day
    4: Color.fromARGB(255, 174, 53, 44), //Absent
    3: Color(0xff2C74B3), //remote work
    2: Color.fromARGB(255, 40, 186, 162), //Leave
  };

  getColorFromString(status) {
    switch (status) {
      case "Office":
        return colors[0];
      case "Leave":
        return colors[2];
      case "Remote":
        return colors[3];
      default:
        return colors[0];
    }
  }

  getMonthName(monthNumber) {
    return months[monthNumber - 1];
  }

  getMonthNumber(monthName) {
    return months.indexOf(monthName) + 1;
  }

  int getHolydays() {
    if (attendanceInfo == null) {
      return 0;
    }
    int holydays = 0;
    calenderData?.values.forEach((element) {
      if (element == 1) {
        holydays++;
      }
    });
    return holydays;
  }

  getPhysicalOffice() {
    num physicalOffice = attendanceInfo['inCount'] < attendanceInfo['outCount']
        ? attendanceInfo['outCount']
        : attendanceInfo['inCount'];

    if (physicalOffice > 7) {
      return physicalOffice;
    }
    debugPrint("Max days is-$maxDays".toString());
    physicalOffice = maxDays -
        (getHolydays() +
            attendanceInfo['paidLeaveCount'] +
            attendanceInfo['sickLeaveCount'] +
            attendanceInfo['workFormHome']);

    return physicalOffice;
  }

  getAttendance(DateTime date) async {
    final now = DateTime.now();
    final firstDate =
        DateFormat("dd-MMMM-yyyy").format(DateTime(date.year, date.month, 0));
    final lastDate = DateFormat("dd-MMMM-yyyy")
        .format(DateTime(date.year, date.month + 1, 1));
    final url =
        ApiRoutes.attendanceInfo + "?startDate=$firstDate&endDate=$lastDate";
    final responseData =
        await NetworkApiServices().getApi(url, "Attendance info");
    if (responseData == null) {
      return false;
    }
    logs = responseData['logs'] is List ? {} : responseData['logs'];
    maxDays = DateTime(date.year, date.month + 1, 0).day;
    calenderData = {};

    for (var i = 1; i <= maxDays; i++) {
      final tempDate = DateTime(date.year, date.month, i);
      final key = DateFormat("dd-MM-yyyy").format(tempDate);
      if (i == 1) {
        firstDay = tempDate.weekday + 1;
      }
      // debugPrint("$i day".toString());
      if (tempDate.weekday == 5) {
        // debugPrint("$i is friday".toString());
        calenderData![tempDate] = 1;
      } else if (1 < i && i < 16 && tempDate.weekday == 6) {
        calenderData![tempDate] = 1;
      } else {
        calenderData![tempDate] = 0;
      }
      if (logs.containsKey(key) && logs[key]['working_nature'] == "Office") {
        calenderData![tempDate] = 0;
      }
      if (logs.containsKey(key) && logs[key]['working_nature'] == "Leave") {
        calenderData![tempDate] = 2;
      }
      // debugPrint(calenderData?[tempDate].toString());

      if (logs.containsKey(key) && logs[key]['working_nature'] == "Remote") {
        calenderData![tempDate] = 3;
      }
    }
    attendanceInfo = responseData;
    notifyListeners();
    return true;
  }
}
