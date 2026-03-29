// To parse this JSON data, do
//
//     final orderReq = orderReqFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

OrderReq orderReqFromJson(String str) => OrderReq.fromJson(json.decode(str));

String orderReqToJson(OrderReq data) => json.encode(data.toJson());

class OrderReq {
    int userId;
    int lottoId;
    String purchaseDate;

    OrderReq({
        required this.userId,
        required this.lottoId,
        required this.purchaseDate,
    });

    factory OrderReq.fromJson(Map<String, dynamic> json) => OrderReq(
        userId: json["user_id"],
        lottoId: json["lotto_id"],
        purchaseDate: json["purchase_date"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "lotto_id": lottoId,
        "purchase_date": purchaseDate,
    };
}
