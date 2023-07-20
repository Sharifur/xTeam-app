import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:office_attendence/common/custom_outlined_button.dart';
import 'package:office_attendence/common/custom_preloader.dart';
import 'package:office_attendence/helpers/common_helper.dart';
import 'package:office_attendence/helpers/empty_space_helper.dart';
import 'package:office_attendence/helpers/responsive.dart';
import 'package:office_attendence/services/request_list_service.dart';
import 'package:provider/provider.dart';

import '../../services/request_leave_services.dart';
import '../request_leave_view/request_leave_view.dart';

class RequestListView extends StatelessWidget {
  static const routeName = "request_list_view";
  RequestListView({super.key});
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      tryToLoadMore(context);
    });
    final rlProvider = Provider.of<RequestListService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("Requests"),
        actions: [
          CustomOutlinedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(RequestLeaveView.routeName).then(
                  (value) =>
                      Provider.of<RequestLeaveServices>(context, listen: false)
                          .disposeClass());
            },
            btText: "Send Request",
            isLoading: false,
            width: 150,
            height: 36,
          ),
          EmptySpaceHelper.emptywidth(12)
        ],
      ),
      body: FutureBuilder(
        future: rlProvider.requestLeaveList != null
            ? null
            : rlProvider.getRequestList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomPreloader(),
              ],
            );
          }
          if (rlProvider.requestLeaveList == null ||
              rlProvider.requestLeaveList!.leaveList!.data == []) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("No request found!"),
              ],
            );
          }
          return Consumer<RequestListService>(
              builder: (context, rlProvider, child) {
            return RefreshIndicator(
              onRefresh: () async {
                final result = await rlProvider.getRequestList();
                if (result) {
                  showToast("Requests refreshed");
                  return result;
                }
                showToast("Requests refresh failed");
                return result;
              },
              child: ListView.separated(
                  controller: scrollController,
                  padding: EdgeInsets.all(20),
                  itemBuilder: (context, index) {
                    if (rlProvider.requestLeaveList!.leaveList!.data!.length ==
                        index) {
                      return CustomPreloader();
                    }
                    final element =
                        rlProvider.requestLeaveList!.leaveList!.data![index];
                    return Container(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            element.type!.replaceAll("-", " ").capitalize(),
                            style: TextStyle(fontSize: 16),
                          ),
                          EmptySpaceHelper.emptyHight(4),
                          Text(
                            "Status: " + rlProvider.getStatus(element.status!),
                            style: TextStyle(fontSize: 12),
                          ),
                          // EmptySpaceHelper.emptyHight(4),
                          // Text(
                          //   "Type: " +
                          //       element.type!.replaceAll("-", " ").capitalize(),
                          //   style: TextStyle(fontSize: 12),
                          // ),
                          EmptySpaceHelper.emptyHight(4),
                          Text(
                            "Date: " +
                                DateFormat.yMMMMEEEEd()
                                    .format(element.dateTime!),
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: rlProvider
                          .requestLeaveList!.leaveList!.data!.length +
                      (rlProvider.requestLeaveList!.leaveList!.nextPageUrl !=
                              null
                          ? 1
                          : 0)),
            );
          });
        },
      ),
    );
  }

  tryToLoadMore(
    BuildContext context,
  ) {
    final rlProvider = Provider.of<RequestListService>(context, listen: false);
    final nextPage = rlProvider.requestLeaveList!.leaveList!.nextPageUrl;
    try {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        if (nextPage == null) {
          return;
        }
        if (!rlProvider.nextPageLoading) {
          rlProvider.getRequestListNextPage();
          return;
        }
      }
    } catch (e) {}
  }
}
