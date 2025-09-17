// model/login_res.dart

import 'dart:convert';

LoginRes loginResFromJson(String str) => LoginRes.fromJson(json.decode(str));

String loginResToJson(LoginRes data) => json.encode(data.toJson());

class LoginRes {
    String message;
    User user;

    LoginRes({
        required this.message,
        required this.user,
    });

    factory LoginRes.fromJson(Map<String, dynamic> json) => LoginRes(
        message: json["message"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "user": user.toJson(),
    };
}

class User {
    int userId;
    String? firstName;
    String? lastName;
    String email;
    String role;
    double walletBalance;
    DateTime createdAt;

    User({
        required this.userId,
        this.firstName,
        this.lastName,
        required this.email,
        required this.role,
        required this.walletBalance,
        required this.createdAt,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        role: json["role"],
        walletBalance: double.tryParse(json["wallet_balance"].toString()) ?? 0.0,
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "role": role,
        "wallet_balance": walletBalance,
        "created_at": createdAt.toIso8601String(),
    };
}