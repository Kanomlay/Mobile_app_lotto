// To parse this JSON data, do
//
//     final prizeReq = prizeReqFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PrizeReq prizeReqFromJson(String str) => PrizeReq.fromJson(json.decode(str));

String prizeReqToJson(PrizeReq data) => json.encode(data.toJson());

class PrizeReq {
    String prizeName;
    int prizeAmount;
    String winningNumber;
    String prizeType;
    DateTime drawDate;

    PrizeReq({
        required this.prizeName,
        required this.prizeAmount,
        required this.winningNumber,
        required this.prizeType,
        required this.drawDate,
    });

    factory PrizeReq.fromJson(Map<String, dynamic> json) => PrizeReq(
        prizeName: json["prize_name"],
        prizeAmount: json["prize_amount"],
        winningNumber: json["winning_number"],
        prizeType: json["prize_type"],
        drawDate: DateTime.parse(json["draw_date"]),
    );

    Map<String, dynamic> toJson() => {
        "prize_name": prizeName,
        "prize_amount": prizeAmount,
        "winning_number": winningNumber,
        "prize_type": prizeType,
        "draw_date": "${drawDate.year.toString().padLeft(4, '0')}-${drawDate.month.toString().padLeft(2, '0')}-${drawDate.day.toString().padLeft(2, '0')}",
    };
}
