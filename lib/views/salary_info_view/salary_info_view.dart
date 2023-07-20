import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:office_attendence/common/custom_preloader.dart';
import 'package:office_attendence/helpers/common_helper.dart';
import 'package:office_attendence/helpers/empty_space_helper.dart';
import 'package:office_attendence/services/salary_info_service.dart';
import 'package:provider/provider.dart';

class SalaryInfoView extends StatelessWidget {
  static const routeName = 'salary_info_view';
  SalaryInfoView({super.key});
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      tryToLoadMore(context);
    });
    final siProvider = Provider.of<SalaryInfoService>(context, listen: false);
    return Scaffold(
        appBar: AppBar(title: Text("Salary Info")),
        body: FutureBuilder(
          future:
              siProvider.salaryInfo == null ? siProvider.getSalaryInfo() : null,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SafeArea(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CustomPreloader()],
              ));
            }
            return RefreshIndicator(
              child: Consumer<SalaryInfoService>(
                  builder: (context, siProvider, child) {
                return siProvider.salaryInfo?.salaries?.data?.isEmpty != false
                    ? SizedBox()
                    : ListView.separated(
                        controller: scrollController,
                        padding: EdgeInsets.all(20),
                        itemBuilder: (context, index) {
                          if (siProvider.salaryInfo!.salaries!.data!.length ==
                              index) {
                            return CustomPreloader();
                          }
                          final element =
                              siProvider.salaryInfo!.salaries!.data![index];
                          return ExpansionTile(
                            backgroundColor: Colors.black.withOpacity(.01),
                            textColor: Colors.black.withOpacity(.60),
                            collapsedTextColor: Colors.black.withOpacity(.60),
                            tilePadding: const EdgeInsets.all(12),
                            childrenPadding: const EdgeInsets.all(12),
                            collapsedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    color: Colors.black.withOpacity(.05))),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                    color: Colors.black.withOpacity(.05))),
                            title: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    siProvider
                                            .salaryCalculate(element)
                                            .toDouble()
                                            .toStringAsFixed(2) +
                                        " ৳",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  EmptySpaceHelper.emptyHight(6),
                                  Text(
                                    DateFormat("MMMM, yyyy")
                                        .format(element.month!),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Extra added: ",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(.60),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              EmptySpaceHelper.emptyHight(6),
                              if (element.extraEarningFields != null)
                                ...element.extraEarningFields!.map((ele) {
                                  return ele["description"] == null
                                      ? SizedBox()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "${ele["description"]} : ${ele["amount"]} ৳",
                                                  style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(.60),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            EmptySpaceHelper.emptyHight(6),
                                          ],
                                        );
                                }),
                              Row(
                                children: [
                                  Text(
                                    "Deducted: ",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(.60),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              EmptySpaceHelper.emptyHight(6),
                              if (element.extraDeductionFields != null)
                                ...element.extraDeductionFields!.map((ele) {
                                  return ele["description"] == null
                                      ? SizedBox()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "${ele["description"]} : ${ele["amount"]} ৳",
                                                  style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(.60),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            EmptySpaceHelper.emptyHight(6),
                                          ],
                                        );
                                }),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) =>
                            EmptySpaceHelper.emptyHight(12),
                        itemCount:
                            siProvider.salaryInfo!.salaries!.data!.length +
                                (siProvider.salaryInfo!.salaries!.nextPageUrl ==
                                        null
                                    ? 0
                                    : 1));
              }),
              onRefresh: () async {
                final result = await siProvider.getSalaryInfo();
                if (result) {
                  showToast("Salary info refreshed");
                  return;
                }
                showToast("Salary info refresh failed");
              },
            );
          },
        ));
  }

  tryToLoadMore(
    BuildContext context,
  ) {
    final siProvider = Provider.of<SalaryInfoService>(context, listen: false);
    final nextPage = siProvider.salaryInfo!.salaries!.nextPageUrl;
    try {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        if (nextPage == null) {
          return;
        }
        if (!siProvider.nextPageLoading) {
          siProvider.getNextSalaryInfo();
          return;
        }
      }
    } catch (e) {}
  }
}
