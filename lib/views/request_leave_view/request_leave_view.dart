import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:office_attendence/common/custom_common_button.dart';
import 'package:office_attendence/common/custom_dropdown.dart';
import 'package:office_attendence/common/field_title.dart';
import 'package:office_attendence/helpers/common_helper.dart';
import 'package:office_attendence/helpers/empty_space_helper.dart';
import 'package:office_attendence/services/request_leave_services.dart';
import 'package:office_attendence/services/request_list_service.dart';
import 'package:provider/provider.dart';

class RequestLeaveView extends StatelessWidget {
  static const routeName = 'request_leave_view';
  const RequestLeaveView({super.key});
  @override
  Widget build(BuildContext context) {
    ValueNotifier isLoading = ValueNotifier(false);
    ValueNotifier<bool> selectMultipleDate = ValueNotifier(false);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Request Leave"),
        ),
        body: Form(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ValueListenableBuilder(
                  valueListenable: selectMultipleDate,
                  builder: (context, md, c) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          value: md,
                          onChanged: (newValue) {
                            Provider.of<RequestLeaveServices>(context,
                                    listen: false)
                                .setDay(null);
                            Provider.of<RequestLeaveServices>(context,
                                    listen: false)
                                .setDateRange(null);
                            selectMultipleDate.value = !md;
                          },
                          title: FieldTitle(
                            "Select multiple days",
                          ),
                        ),
                        FieldTitle("Select Date"),
                        Consumer<RequestLeaveServices>(
                            builder: (context, rlProvider, child) {
                          return SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                                onPressed: () {
                                  final now = DateTime.now();
                                  if (md) {
                                    showDateRangePicker(
                                      context: context,
                                      firstDate: now,
                                      lastDate:
                                          now.add(const Duration(days: 15)),
                                    ).then((value) {
                                      if (value != null) {
                                        rlProvider.setDateRange(value);
                                      }
                                    });
                                    return;
                                  }
                                  showDatePicker(
                                    context: context,
                                    initialDate: now,
                                    firstDate: now,
                                    lastDate: now.add(const Duration(days: 15)),
                                  ).then((value) {
                                    if (value != null) {
                                      rlProvider.setDay(value);
                                    }
                                  });
                                },
                                child: Text(rlProvider.selectedDay == null &&
                                        rlProvider.dateTimeRange == null
                                    ? "Select date"
                                    : DateFormat.yMMMMEEEEd().format(
                                            rlProvider.dateTimeRange?.start ??
                                                rlProvider.selectedDay!) +
                                        "${md ? (" - " + DateFormat.yMMMMEEEEd().format(rlProvider.dateTimeRange!.end)) : ""}")),
                          );
                        }),
                      ],
                    );
                  }),
              FieldTitle("Select Option"),
              Consumer<RequestLeaveServices>(
                  builder: (context, rlProvider, child) {
                return CustomDropdown("Select Option", rlProvider.leaveOptions,
                    (newValue) {
                  rlProvider.setLeaveOption(newValue);
                }, value: rlProvider.selectedOption);
              }),
              EmptySpaceHelper.emptyHight(16),
              ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (context, value, child) {
                  return CustomCommonButton(
                    onPressed: () async {
                      final rlProvider = Provider.of<RequestLeaveServices>(
                          context,
                          listen: false);

                      if (rlProvider.selectedDay == null &&
                          rlProvider.dateTimeRange == null) {
                        showToast("Please select a date");
                        return;
                      }
                      if (rlProvider.selectedDay?.day == DateTime.now().day &&
                          rlProvider.selectedOption == 'Paid Leave') {
                        showToast("Paid leave is not available for today");
                        return;
                      }
                      isLoading.value = true;
                      final result = await rlProvider.requestLeave();
                      if (result) {
                        await Provider.of<RequestListService>(context,
                                listen: false)
                            .getRequestList();
                        Navigator.pop(context);
                      }
                      isLoading.value = false;
                    },
                    btText: "Send Request",
                    isLoading: value,
                  );
                },
              )
            ],
          ),
        ));
  }
}
