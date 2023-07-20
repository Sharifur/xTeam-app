import 'dart:convert';

ProfileInfoModel profileInfoModelFromJson(String str) =>
    ProfileInfoModel.fromJson(json.decode(str));

String profileInfoModelToJson(ProfileInfoModel data) =>
    json.encode(data.toJson());

class ProfileInfoModel {
  final String? type;
  final UserInfo? userInfo;

  ProfileInfoModel({
    this.type,
    this.userInfo,
  });

  factory ProfileInfoModel.fromJson(Map<String, dynamic> json) =>
      ProfileInfoModel(
        type: json["type"],
        userInfo: json["userInfo"] == null
            ? null
            : UserInfo.fromJson(json["userInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "userInfo": userInfo?.toJson(),
      };
}

class UserInfo {
  final String? email;
  final String? name;
  dynamic id;
  final String? phone;
  final String? address;
  final DateTime? joinDate;

  UserInfo({
    this.name,
    this.email,
    this.id,
    this.phone,
    this.address,
    this.joinDate,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        email: json["email"],
        name: json["name"],
        id: json["id"],
        phone: json["phone"],
        address: json["address"],
        joinDate:
            json["joinDate"] == null ? null : DateTime.parse(json["joinDate"]),
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "id": id,
        "phone": phone,
        "address": address,
        "joinDate": joinDate?.toIso8601String(),
      };
}
