import 'package:flutter/material.dart';
import 'package:office_attendence/api_routes.dart';
import 'package:office_attendence/data/network/network_api_services.dart';

import '../models/request_leave_list_model.dart';

class RequestListService with ChangeNotifier {
  RequestLeaveListModel? requestLeaveList;
  bool nextPageLoading = false;

  getStatus(status) {
    switch (status) {
      case 0:
        return "Pending";
      case 1:
        return "Approved";
      default:
        return "Unknown";
    }
  }

  getRequestList() async {
    final responseData = await NetworkApiServices()
        .getApi(ApiRoutes.requestList, "Request List");
    if (responseData == null) {
      return false;
    }

    requestLeaveList = RequestLeaveListModel.fromJson(responseData);
    notifyListeners();
    return true;
  }

  getRequestListNextPage() async {
    nextPageLoading = true;
    final responseData = await NetworkApiServices().getApi(
        requestLeaveList!.leaveList!.nextPageUrl!
            .replaceAll("http://xghrm.org/api/", ""),
        "Request List");
    if (responseData == null) {
      nextPageLoading = false;
      return false;
    }
    final tempInfo = RequestLeaveListModel.fromJson(responseData);
    tempInfo.leaveList?.data?.forEach((element) {
      requestLeaveList!.leaveList?.data?.add(element);
    });
    requestLeaveList?.leaveList?.nextPageUrl = tempInfo.leaveList?.nextPageUrl;
    requestLeaveList!.leaveList!.data =
        requestLeaveList!.leaveList!.data!.reversed.toList();
    notifyListeners();
    nextPageLoading = false;
    return true;
  }
}
