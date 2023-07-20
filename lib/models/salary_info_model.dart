import 'dart:convert';

SalaryInfoModel salaryInfoModelFromJson(String str) =>
    SalaryInfoModel.fromJson(json.decode(str));

class SalaryInfoModel {
  final String? type;
  final Salaries? salaries;

  SalaryInfoModel({
    this.type,
    this.salaries,
  });

  factory SalaryInfoModel.fromJson(Map<String, dynamic> json) =>
      SalaryInfoModel(
        type: json["type"],
        salaries: json["salaries"] == null
            ? null
            : Salaries.fromJson(json["salaries"]),
      );
}

class Salaries {
  final int? currentPage;
  List<Datum>? data;
  String? nextPageUrl;

  Salaries({
    this.currentPage,
    this.data,
    this.nextPageUrl,
  });

  factory Salaries.fromJson(Map<String, dynamic> json) => Salaries(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        nextPageUrl: json["next_page_url"],
      );
}

class Datum {
  final dynamic id;
  final dynamic employeeId;
  final num? salary;
  final DateTime? month;
  final List? extraEarningFields;
  final List? extraDeductionFields;
  final String? monthName;
  final String? year;
  final dynamic created;
  final Employee? employee;

  Datum({
    this.id,
    this.employeeId,
    this.salary,
    this.month,
    this.extraEarningFields,
    this.extraDeductionFields,
    this.monthName,
    this.year,
    this.created,
    this.employee,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        employeeId: json["employee_id"],
        salary: json["salary"],
        month: json["month"] == null ? null : DateTime.parse(json["month"]),
        extraEarningFields: json["extraEarningFields"] == null
            ? null
            : List<Map<String, dynamic>>.from(
                jsonDecode(json["extraEarningFields"])),
        extraDeductionFields: json["extraDeductionFields"] == null
            ? null
            : List<Map<String, dynamic>>.from(
                jsonDecode(json["extraDeductionFields"])),
        monthName: json["monthName"],
        year: json["year"],
        created: json["created"],
        employee: json["employee"] == null
            ? null
            : Employee.fromJson(json["employee"]),
      );
}

class Employee {
  final dynamic id;
  final String? name;

  Employee({
    this.id,
    this.name,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: json["id"],
        name: json["name"],
      );
}
