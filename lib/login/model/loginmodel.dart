// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  bool status;
  String message;
  Response response;

  LoginModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    status: json["status"],
    message: json["message"],
    response: Response.fromJson(json["response"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "response": response.toJson(),
  };
}

class Response {
  int userId;
  String userName;
  String userPass;
  String email;
  String mobile;
  String firstName;
  String middleName;
  String lastName;
  int createdDate;
  bool status;
  dynamic parentId;
  int roleId;
  String address;
  String createdBy;

  Response({
    required this.userId,
    required this.userName,
    required this.userPass,
    required this.email,
    required this.mobile,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.createdDate,
    required this.status,
    this.parentId,
    required this.roleId,
    required this.address,
    required this.createdBy,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    userId: json["userId"],
    userName: json["userName"],
    userPass: json["userPass"],
    email: json["email"],
    mobile: json["mobile"],
    firstName: json["firstName"],
    middleName: json["middleName"],
    lastName: json["lastName"],
    createdDate: json["createdDate"],
    status: json["status"],
    parentId: json["parentId"],
    roleId: json["roleId"],
    address: json["address"],
    createdBy: json["createdBy"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
    "userPass": userPass,
    "email": email,
    "mobile": mobile,
    "firstName": firstName,
    "middleName": middleName,
    "lastName": lastName,
    "createdDate": createdDate,
    "status": status,
    "parentId": parentId,
    "roleId": roleId,
    "address": address,
    "createdBy": createdBy,
  };
}
