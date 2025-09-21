// To parse this JSON data, do
//
//     final orderReq = orderReqFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

OrderReq orderReqFromJson(String str) => OrderReq.fromJson(json.decode(str));

String orderReqToJson(OrderReq data) => json.encode(data.toJson());

class OrderReq {
  int orderId;
  int userId;
  String purchaseDate;

  OrderReq({
    required this.orderId,
    required this.userId,
    required this.purchaseDate,
  });

  factory OrderReq.fromJson(Map<String, dynamic> json) => OrderReq(
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
