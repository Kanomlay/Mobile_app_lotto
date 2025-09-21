// To parse this JSON data, do
//
//     final registerReq = registerReqFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RegisterReq registerReqFromJson(String str) =>
    RegisterReq.fromJson(json.decode(str));

String registerReqToJson(RegisterReq data) => json.encode(data.toJson());

class RegisterReq {
  String firstName;
  String lastName;
  String phoneNumber;
  String email;
  String passwordHash;
  int walletBalance;

  RegisterReq({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.passwordHash,
    required this.walletBalance,
  });

  factory RegisterReq.fromJson(Map<String, dynamic> json) => RegisterReq(
    firstName: json["first_name"],
    lastName: json["last_name"],
    phoneNumber: json["phone_number"],
    email: json["email"],
    passwordHash: json["password_hash"],
    walletBalance: json["wallet_balance"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "phone_number": phoneNumber,
    "email": email,
    "password_hash": passwordHash,
    "wallet_balance": walletBalance,
  };
}
