import 'dart:convert';

LottosRes lottosResFromJson(String str) => LottosRes.fromJson(json.decode(str));

String lottosResToJson(LottosRes data) => json.encode(data.toJson());

class LottosRes {
  List<Lotto> lottos;

  LottosRes({required this.lottos});

  factory LottosRes.fromJson(Map<String, dynamic> json) => LottosRes(
    lottos: List<Lotto>.from(json["lottos"].map((x) => Lotto.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "lottos": List<dynamic>.from(lottos.map((x) => x.toJson())),
  };
}

class Lotto {
  int lottoId;
  String lottoNumber;
  double lottoPrice;
  String status;
  String createdAt;
  int createdByUserId;
  int? orderId;
  int? prizeId;

  Lotto({
    required this.lottoId,
    required this.lottoNumber,
    required this.lottoPrice,
    required this.status,
    required this.createdAt,
    required this.createdByUserId,
    this.orderId,
    this.prizeId,
  });

  factory Lotto.fromJson(Map<String, dynamic> json) => Lotto(
    lottoId: int.tryParse(json["lotto_id"].toString()) ?? 0,
    lottoNumber: json["lotto_number"] ?? '',
    lottoPrice: double.tryParse(json["lotto_price"].toString()) ?? 0,
    status: json["status"] ?? 'UNKNOWN',
    createdAt: json["created_at"] ?? '',
    createdByUserId: int.tryParse(json["created_by_user_id"].toString()) ?? 0,
    orderId: json["order_id"] != null
        ? int.tryParse(json["order_id"].toString())
        : null,
    prizeId: json["prize_id"] != null
        ? int.tryParse(json["prize_id"].toString())
        : null,
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
  @override
  String toString() {
    return 'Lotto(id: $lottoId, number: $lottoNumber, price: $lottoPrice, status: $status)';
  }
}
