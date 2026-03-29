// To parse this JSON data, do
//
//     final lottoPrizeRes = lottoPrizeResFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LottoPrizeRes lottoPrizeResFromJson(String str) => LottoPrizeRes.fromJson(json.decode(str));

String lottoPrizeResToJson(LottoPrizeRes data) => json.encode(data.toJson());

class LottoPrizeRes {
    int lottoId;
    String lottoNumber;
    String lottoPrice;
    int prizeId;
    String prizeName;
    String prizeAmount;
    String winningNumber;
    String drawDate;

    LottoPrizeRes({
        required this.lottoId,
        required this.lottoNumber,
        required this.lottoPrice,
        required this.prizeId,
        required this.prizeName,
        required this.prizeAmount,
        required this.winningNumber,
        required this.drawDate,
    });

    factory LottoPrizeRes.fromJson(Map<String, dynamic> json) => LottoPrizeRes(
        lottoId: json["lotto_id"],
        lottoNumber: json["lotto_number"],
        lottoPrice: json["lotto_price"],
        prizeId: json["prize_id"],
        prizeName: json["prize_name"],
        prizeAmount: json["prize_amount"],
        winningNumber: json["winning_number"],
        drawDate: json["draw_date"],
    );

    Map<String, dynamic> toJson() => {
        "lotto_id": lottoId,
        "lotto_number": lottoNumber,
        "lotto_price": lottoPrice,
        "prize_id": prizeId,
        "prize_name": prizeName,
        "prize_amount": prizeAmount,
        "winning_number": winningNumber,
        "draw_date": drawDate,
    };
}
