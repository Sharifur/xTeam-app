import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:office_attendence/helpers/common_helper.dart';
import 'package:office_attendence/helpers/empty_space_helper.dart';
import 'package:office_attendence/helpers/responsive.dart';
import 'package:office_attendence/services/attendance_service.dart';
import 'package:provider/provider.dart';

class CustomCalendar extends StatelessWidget {
  const CustomCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Consumer<AttendanceService>(builder: (context, aProvider, child) {
      return Column(
        children: [
          Table(
            children: Iterable.generate(1)
                .map((e) => TableRow(
                        children: [
                      'Sun',
                      'Mon',
                      'Tue',
                      'Wed',
                      'Thu',
                      'Fri',
                      'Sat',
                    ]
                            .map((e) => Container(
                                height: 60,
                                width: 60,
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(horizontal: 3),
                                child: Text(
                                  e,
                                  style: TextStyle(color: Colors.grey[600]),
                                )))
                            .toList()))
                .toList(),
          ),
          Table(
            children: Iterable.generate(5)
                .map((e1) => TableRow(
                        children: Iterable.generate(7).map((e2) {
                      if (((e1 * 7) + (e2 + 1) < aProvider.firstDay) ||
                          ((e1 * 7) + (e2 + 1) - aProvider.firstDay) >=
                              aProvider.maxDays) {
                        return Text("");
                      }
                      final tempDate = aProvider.calenderData?.keys
                          .toList()[((e1 * 7) + (e2 + 1) - aProvider.firstDay)];
                      final colorValue = aProvider.calenderData?.values
                          .toList()[((e1 * 7) + (e2 + 1) - aProvider.firstDay)];
                      return Row(
                        children: [
                          Hero(
                            tag: tempDate!.day,
                            child: GestureDetector(
                              onTap: () {
                                final data = aProvider.attendanceInfo["logs"]
                                    [DateFormat("dd-MM-yyyy").format(tempDate)];
                                debugPrint(data.toString());
                                if (data == null) {
                                  showToast("No data found");
                                  return;
                                }
                                final nature = data?['working_nature'];
                                final workingDuration = data?['working_hour'];
                                final checkIn = data?['in_time'];
                                final checkout = data?['out_time'];
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            // height: 150,
                                            width: screenWidth / 1.3,
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      height: 60,
                                                      width: 60,
                                                      alignment:
                                                          Alignment.center,
                                                      margin: EdgeInsets.all(3),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              aProvider.colors[
                                                                  colorValue],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      child: Text(
                                                        "${tempDate.day}",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    )),
                                                Expanded(
                                                    flex: 1, child: SizedBox()),
                                                Expanded(
                                                    flex: 6,
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          height: 100 -
                                                              ((checkIn == null
                                                                      ? 20
                                                                      : 0) +
                                                                  (checkout ==
                                                                          null
                                                                      ? 20
                                                                      : 0) +
                                                                  (workingDuration ==
                                                                          null
                                                                      ? 20
                                                                      : 0)),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "${nature}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: aProvider
                                                                            .colors[
                                                                        colorValue]),
                                                              ),
                                                              if (checkIn !=
                                                                  null)
                                                                EmptySpaceHelper
                                                                    .emptyHight(
                                                                        4),
                                                              if (checkIn !=
                                                                  null)
                                                                Text(
                                                                  "Check in: ${checkIn ?? "Not available"}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: aProvider
                                                                              .colors[
                                                                          colorValue]),
                                                                ),
                                                              if (checkout !=
                                                                  null)
                                                                EmptySpaceHelper
                                                                    .emptyHight(
                                                                        4),
                                                              if (checkout !=
                                                                  null)
                                                                Text(
                                                                  "Check out: ${checkout ?? "Not available"}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: aProvider
                                                                              .colors[
                                                                          colorValue]),
                                                                ),
                                                              if (workingDuration !=
                                                                  null)
                                                                EmptySpaceHelper
                                                                    .emptyHight(
                                                                        4),
                                                              if (workingDuration !=
                                                                  null)
                                                                Text(
                                                                  "${workingDuration ?? "Not available"}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: aProvider
                                                                              .colors[
                                                                          colorValue]),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                                // ScaffoldMessenger.of(context)
                                //     .removeCurrentSnackBar();
                                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                //     content: Text(
                                //         "Work Status: $nature, Working Duration: $workingDuration")));
                              },
                              child: Container(
                                height: 36,
                                width: 36,
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: aProvider.colors[colorValue]!
                                        .withOpacity(.20),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  "${tempDate.day}",
                                  style: TextStyle(
                                      color: aProvider.colors[colorValue]),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList()))
                .toList(),
          ),
        ],
      );
    });
  }
}
