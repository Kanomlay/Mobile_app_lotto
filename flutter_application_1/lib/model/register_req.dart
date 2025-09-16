// To parse this JSON data, do
//
//     final customerIdxGetResponse = customerIdxGetResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CustomerIdxGetResponse customerIdxGetResponseFromJson(String str) => CustomerIdxGetResponse.fromJson(json.decode(str));

String customerIdxGetResponseToJson(CustomerIdxGetResponse data) => json.encode(data.toJson());

class CustomerIdxGetResponse {
    int userId;
    String firstName;
    String lastName;
    String email;
    String passwordHash;
    String role;
    String walletBalance;
    String createdAt;

    CustomerIdxGetResponse({
        required this.userId,
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.passwordHash,
        required this.role,
        required this.walletBalance,
        required this.createdAt,
    });

    factory CustomerIdxGetResponse.fromJson(Map<String, dynamic> json) => CustomerIdxGetResponse(
        userId: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
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
        "email": email,
        "password_hash": passwordHash,
        "role": role,
        "wallet_balance": walletBalance,
        "created_at": createdAt,
    };
}
