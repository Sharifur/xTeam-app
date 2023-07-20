import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:office_attendence/common/custom_preloader.dart';
import 'package:office_attendence/helpers/empty_space_helper.dart';
import 'package:office_attendence/helpers/responsive.dart';
import 'package:office_attendence/services/attendance_service.dart';
import 'package:office_attendence/services/profile_info_service.dart';
import 'package:provider/provider.dart';

class HomeAttendance extends StatelessWidget {
  const HomeAttendance({
    super.key,
    required this.date,
    required this.isLoading,
  });

  final ValueNotifier<DateTime> date;
  final ValueNotifier<bool> isLoading;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final joinDate = Provider.of<ProfileInfoService>(context, listen: false)
        .profileInfo
        ?.userInfo
        ?.joinDate;
    return Consumer<AttendanceService>(builder: (context, aProvider, child) {
      return FutureBuilder(
        future: aProvider.calenderData == null
            ? aProvider.getAttendance(date.value)
            : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomPreloader(),
              ],
            );
          }
          return ValueListenableBuilder(
              valueListenable: isLoading,
              builder: (context, value, child) => value ||
                      snapshot.connectionState == ConnectionState.waiting
                  ? Container(
                      color: Colors.white,
                      child: SizedBox(
                        height: screenHeight - 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomPreloader(),
                          ],
                        ),
                      ),
                    )
                  : Stack(
                      children: [
                        Center(
                          child: ValueListenableBuilder(
                            valueListenable: date,
                            builder: (context, value, child) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        onPressed: date.value.year ==
                                                    joinDate?.year &&
                                                date.value.month ==
                                                    joinDate?.month
                                            ? null
                                            : () async {
                                                isLoading.value = true;
                                                date.value = DateTime(
                                                    value.year,
                                                    value.month - 1);
                                                await aProvider
                                                    .getAttendance(date.value);
                                                isLoading.value = false;
                                              },
                                        icon: Icon(Icons.arrow_back_ios)),
                                    GestureDetector(
                                        onTap: () async {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: date.value,
                                                  firstDate: joinDate ??
                                                      date.value.subtract(
                                                          Duration(days: 600)),
                                                  lastDate: DateTime(
                                                      now.year, now.month, 0))
                                              .then((value) async {
                                            if (value == null ||
                                                value.month ==
                                                    date.value.month) {
                                              return;
                                            }
                                            isLoading.value = true;
                                            date.value = DateTime(
                                                value.year, value.month);
                                            await aProvider
                                                .getAttendance(date.value);
                                            isLoading.value = false;
                                          });
                                        },
                                        child: Text(
                                          DateFormat("MMMM-yyyy").format(value),
                                        )),
                                    IconButton(
                                        onPressed: date.value.year ==
                                                    now.year &&
                                                date.value.month ==
                                                    (now.month - 1)
                                            ? null
                                            : () async {
                                                isLoading.value = true;
                                                date.value = DateTime(
                                                    value.year,
                                                    value.month + 1);
                                                await aProvider
                                                    .getAttendance(date.value);
                                                isLoading.value = false;
                                              },
                                        icon: Icon(Icons.arrow_forward_ios)),
                                  ],
                                ),
                                EmptySpaceHelper.emptyHight(16),
                                if (snapshot.connectionState !=
                                    ConnectionState.waiting)
                                  Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    children: [
                                      infoChips(
                                          title: "Physical \nOffice",
                                          amount: aProvider.getPhysicalOffice(),
                                          color: aProvider.colors[0]),
                                      infoChips(
                                          title: "Holidays",
                                          amount: aProvider
                                              .attendanceInfo['holidayCount'],
                                          color: aProvider.colors[1]),
                                      infoChips(
                                          title: "Paid \nLeaves",
                                          amount: aProvider
                                              .attendanceInfo['paidLeaveCount'],
                                          color: aProvider.colors[2]),
                                      infoChips(
                                          title: "Sick \nLeaves",
                                          amount: aProvider
                                              .attendanceInfo['sickLeaveCount'],
                                          color: aProvider.colors[2]),
                                      infoChips(
                                          title: "Remote \nOffice",
                                          amount: aProvider
                                              .attendanceInfo['workFormHome'],
                                          color: aProvider.colors[3]),
                                    ],
                                  ),
                                EmptySpaceHelper.emptyHight(16),
                                if (aProvider.attendanceInfo != null)
                                  ...aProvider.logs.keys.toList().map((key) {
                                    final element = aProvider.logs[key];
                                    final date =
                                        DateFormat("dd-mm-yyyy").parse(key);
                                    if (element['working_nature'] == null) {
                                      return SizedBox();
                                    }
                                    final color = aProvider.getColorFromString(
                                        element['working_nature']);
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.black.withOpacity(.05),
                                      ),
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                DateFormat("EEEE, dd")
                                                        .format(date) +
                                                    "-" +
                                                    element['working_nature']!,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: color,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              if (element['in_time'] != null)
                                                EmptySpaceHelper.emptyHight(4),
                                              if (element['in_time'] != null)
                                                Text(
                                                  "Check In: " +
                                                      element['in_time'],
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: color),
                                                ),
                                              if (element['out_time'] != null)
                                                EmptySpaceHelper.emptyHight(4),
                                              if (element['out_time'] != null)
                                                Text(
                                                  "Check Out: " +
                                                      element['out_time'],
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: color),
                                                ),
                                              if (element['working_hour'] !=
                                                  null)
                                                EmptySpaceHelper.emptyHight(4),
                                              if (element['working_hour'] !=
                                                  null)
                                                Text(
                                                  "Working Hour: " +
                                                      element['working_hour'],
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: color),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                              ],
                            ),
                          ),
                        ),
                      ],
                    ));
        },
      );
    });
  }
}

class infoChips extends StatelessWidget {
  final title;
  final amount;
  final color;
  const infoChips({
    required this.title,
    required this.amount,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: (screenWidth - 60) / 2,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color.withOpacity(.20),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Text(
              '$amount',
              style: TextStyle(color: color),
            ),
          ),
          EmptySpaceHelper.emptywidth(12),
          Text(
            title,
            maxLines: 2,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}
