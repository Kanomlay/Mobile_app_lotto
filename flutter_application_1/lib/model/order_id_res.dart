// To parse this JSON data, do
//
//     final orderIdRes = orderIdResFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

OrderIdRes orderIdResFromJson(String str) => OrderIdRes.fromJson(json.decode(str));

String orderIdResToJson(OrderIdRes data) => json.encode(data.toJson());

class OrderIdRes {
    int orderId;
    int userId;
    String purchaseDate;

    OrderIdRes({
        required this.orderId,
        required this.userId,
        required this.purchaseDate,
    });

    factory OrderIdRes.fromJson(Map<String, dynamic> json) => OrderIdRes(
        orderId: json["order_id"],
        userId: json["user_id"],
        purchaseDate: json["purchase_date"],
    );

    Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "user_id": userId,
        "purchase_date": purchaseDate,
    };
}
