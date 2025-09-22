// To parse this JSON data, do
//
//     final userByIdRes = userByIdResFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UserByIdRes userByIdResFromJson(String str) => UserByIdRes.fromJson(json.decode(str));

String userByIdResToJson(UserByIdRes data) => json.encode(data.toJson());

class UserByIdRes {
    int userId;
    String firstName;
    String lastName;
    String phoneNumber;
    String email;
    String passwordHash;
    String role;
    String walletBalance;
    String createdAt;

    UserByIdRes({
        required this.userId,
        required this.firstName,
        required this.lastName,
        required this.phoneNumber,
        required this.email,
        required this.passwordHash,
        required this.role,
        required this.walletBalance,
        required this.createdAt,
    });

    factory UserByIdRes.fromJson(Map<String, dynamic> json) => UserByIdRes(
        userId: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phoneNumber: json["phone_number"],
        email: json["email"],
        passwordHash: json["password_hash"],
        role: json["role"],
        walletBalance: json["wallet_balance"],
        createdAt: json["created_at"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phoneNumber,
        "email": email,
        "password_hash": passwordHash,
        "role": role,
        "wallet_balance": walletBalance,
        "created_at": createdAt,
    };
}
