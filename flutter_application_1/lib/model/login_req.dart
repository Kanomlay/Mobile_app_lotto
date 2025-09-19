// To parse this JSON data, do
//
//     final loginReq = loginReqFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LoginReq loginReqFromJson(String str) => LoginReq.fromJson(json.decode(str));

String loginReqToJson(LoginReq data) => json.encode(data.toJson());

class LoginReq {
    String email;
    String password;

    LoginReq({
        required this.email,
        required this.password,
    });

    factory LoginReq.fromJson(Map<String, dynamic> json) => LoginReq(
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
    };
}
