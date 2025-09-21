// To parse this JSON data, do
//
//     final lottoRes = lottoResFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LottoRes lottoResFromJson(String str) => LottoRes.fromJson(json.decode(str));

String lottoResToJson(LottoRes data) => json.encode(data.toJson());

class LottoRes {
  int lottoId;
  String lottoNumber;
  String lottoPrice;
  String status;
  String createdAt;
  int createdByUserId;
  dynamic orderId;
  dynamic prizeId;

  LottoRes({
    required this.lottoId,
    required this.lottoNumber,
    required this.lottoPrice,
    required this.status,
    required this.createdAt,
    required this.createdByUserId,
    required this.orderId,
    required this.prizeId,
  });

  factory LottoRes.fromJson(Map<String, dynamic> json) => LottoRes(
    lottoId: json["lotto_id"],
    lottoNumber: json["lotto_number"],
    lottoPrice: json["lotto_price"],
    status: json["status"],
    createdAt: json["created_at"],
    createdByUserId: json["created_by_user_id"],
    orderId: json["order_id"],
    prizeId: json["prize_id"],
  );

  Map<String, dynamic> toJson() => {
    "lotto_id": lottoId,
    "lotto_number": lottoNumber,
    "lotto_price": lottoPrice,
    "status": status,
    "created_at": createdAt,
    "created_by_user_id": createdByUserId,
    "order_id": orderId,
    "prize_id": prizeId,
  };
}
