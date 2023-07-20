import 'package:flutter/material.dart';
import 'package:office_attendence/api_routes.dart';
import 'package:office_attendence/data/network/network_api_services.dart';
import 'package:office_attendence/models/salary_info_model.dart';

class SalaryInfoService with ChangeNotifier {
  SalaryInfoModel? salaryInfo;
  bool nextPageLoading = false;

  setNextPageLoading(value) {
    if (value == nextPageLoading) {
      return;
    }
    nextPageLoading = value;
  }

  salaryCalculate(element) {
    num salary = element.salary ?? 0;
    element.extraEarningFields?.forEach((element) {
      salary += element['amount'] is String
          ? num.tryParse(element['amount'])
          : element['amount'];
    });
    element.extraDeductionFields?.forEach((element) {
      salary -= element['amount'] is String
          ? num.tryParse(element['amount'])
          : element['amount'];
    });

    return salary;
  }

  getSalaryInfo() async {
    final responseData = await NetworkApiServices()
        .postApi({}, ApiRoutes.salaryInfo, "Salary Info");
    if (responseData == null) {
      return false;
    }
    salaryInfo = SalaryInfoModel.fromJson(responseData);
    notifyListeners();
    return true;
  }

  getNextSalaryInfo() async {
    nextPageLoading = true;
    final responseData = await NetworkApiServices().postApi(
        {},
        salaryInfo!.salaries!.nextPageUrl!
            .replaceAll("http://xghrm.org/api/", ""),
        "Salary Info");
    if (responseData == null) {
      nextPageLoading = false;
      return false;
    }
    final tempInfo = SalaryInfoModel.fromJson(responseData);
    tempInfo.salaries?.data?.forEach((element) {
      salaryInfo?.salaries?.data?.add(element);
    });
    salaryInfo?.salaries?.nextPageUrl = tempInfo.salaries?.nextPageUrl;
    nextPageLoading = false;
    notifyListeners();
    return true;
  }
}
