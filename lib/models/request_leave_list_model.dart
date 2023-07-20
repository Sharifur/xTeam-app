import 'dart:convert';

RequestLeaveListModel requestLeaveModelFromJson(String str) =>
    RequestLeaveListModel.fromJson(json.decode(str));

String requestLeaveModelToJson(RequestLeaveListModel data) =>
    json.encode(data.toJson());

class RequestLeaveListModel {
  final String? type;
  final LeaveList? leaveList;

  RequestLeaveListModel({
    this.type,
    this.leaveList,
  });

  factory RequestLeaveListModel.fromJson(Map<String, dynamic> json) =>
      RequestLeaveListModel(
        type: json["type"],
        leaveList: json["leaveList"] == null
            ? null
            : LeaveList.fromJson(json["leaveList"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "leaveList": leaveList?.toJson(),
      };
}

class LeaveList {
  List<Datum>? data;
  dynamic nextPageUrl;

  LeaveList({
    this.data,
    this.nextPageUrl,
  });

  factory LeaveList.fromJson(Map<String, dynamic> json) => LeaveList(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        nextPageUrl: json["next_page_url"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
      };
}

class Datum {
  final String? name;
  final DateTime? dateTime;
  final String? type;
  final int? status;

  Datum({
    this.name,
    this.dateTime,
    this.type,
    this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        name: json["name"],
        dateTime: json["date_time"] == null
            ? null
            : DateTime.parse(json["date_time"]),
        type: json["type"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "date_time": dateTime?.toIso8601String(),
        "type": type,
        "status": status,
      };
}
