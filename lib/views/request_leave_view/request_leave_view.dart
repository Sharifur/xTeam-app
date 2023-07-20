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
    return Scaffold(
        appBar: AppBar(
          title: const Text("Request Leave"),
        ),
        body: Form(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              FieldTitle("Select Date"),
              Consumer<RequestLeaveServices>(
                  builder: (context, rlProvider, child) {
                return OutlinedButton(
                    onPressed: () {
                      final now = DateTime.now();
                      showDatePicker(
                        context: context,
                        initialDate: now.add(Duration(days: 1)),
                        firstDate: now.add(Duration(days: 1)),
                        lastDate: now.add(const Duration(days: 15)),
                        selectableDayPredicate: (day) =>
                            day.weekday == 5 ? false : true,
                      ).then((value) {
                        if (value != null) {
                          rlProvider.setDay(value);
                        }
                      });
                    },
                    child: Text(rlProvider.selectedDay == null
                        ? "Select date"
                        : DateFormat.yMMMMEEEEd()
                            .format(rlProvider.selectedDay!)));
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

                      if (rlProvider.selectedDay == null) {
                        showToast("Please select a date");
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
