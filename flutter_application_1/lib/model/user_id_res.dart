// To parse this JSON data, do
//
//     final userIdRes = userIdResFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UserIdRes userIdResFromJson(String str) => UserIdRes.fromJson(json.decode(str));

String userIdResToJson(UserIdRes data) => json.encode(data.toJson());

class UserIdRes {
  int userId;
  String firstName;
  String lastName;
  String email;
  String role;
  String walletBalance;
  String createdAt;

  UserIdRes({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.walletBalance,
    required this.createdAt,
  });

  factory UserIdRes.fromJson(Map<String, dynamic> json) => UserIdRes(
    userId: json["user_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    role: json["role"],
    walletBalance: json["wallet_balance"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "role": role,
    "wallet_balance": walletBalance,
    "created_at": createdAt,
  };
}
