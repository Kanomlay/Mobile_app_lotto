import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config.dart';
import 'package:flutter_application_1/model/lotto_prize_res.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/pages/wallet_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/pages/Lotto_buy.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/profile.dart';

class CheckPage extends StatefulWidget {
  final int id;
  const CheckPage({super.key, required this.id});
  
  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  int _currentIndex = 2;
  String url = '';

  /// รายการลอตเตอรี่ที่ได้จาก backend
  List<LottoPrizeRes> _winningLottos = [];

  /// โหลดข้อมูลจาก backend
  Future<void> _loadWinningLottos() async {
    if (url.isEmpty) return; // กันกรณียังไม่ได้โหลด config
    try {
      final response = await http.get(
        Uri.parse('$url/users/check-wins/${widget.id}'),
        // route backend
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body is List) {
          final list = body
              .map<LottoPrizeRes>((item) => LottoPrizeRes.fromJson(item))
              .toList();
          setState(() {
            _winningLottos = list;
          });
        } else if (body is Map && body['message'] != null) {
          setState(() {
            _winningLottos = [];
          });
        }
      } else {
        debugPrint('Load failed: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      setState(() {
        url = config['apiEndpoint'];
      });
      _loadWinningLottos(); // เรียกหลังได้ url แล้ว
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("ตรวจลอตเตอรี่"),
        actions:  [
           TextButton(
            onPressed: () {
              int id = 0;
              Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const loginpages()),
                    );
            },
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _winningLottos.isEmpty
            ? const Center(child: Text("คุณยังไม่มีลอตเตอรี่ที่ถูกรางวัล"))
            : ListView.builder(
                itemCount: _winningLottos.length,
                itemBuilder: (context, index) {
                  final lotto = _winningLottos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "หมายเลข: ${lotto.lottoNumber}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "ถูกรางวัล: ${lotto.prizeName}",
                            style: const TextStyle(color: Colors.green),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "มูลค่า: ${lotto.prizeAmount} บาท",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            onPressed: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("ยืนยันการขึ้นเงิน"),
                                  content: Text(
                                    "คุณถูกรางวัล: ${lotto.prizeName}\n"
                                    "จำนวนเงิน: ${lotto.prizeAmount} บาท\n\n"
                                    "คุณต้องการขึ้นเงินหรือไม่?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text("ยกเลิก"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text("ยืนยัน"),
                                    ),
                                  ],
                                ),
                              );

                              if (confirmed == true) {
                                _redeemLotto(lotto.lottoId);
                              }
                            },
                            child: const Text("ขึ้นเงิน"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: const Color.fromARGB(255, 99, 99, 99),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomePage(id: widget.id)),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LottoBuyPage(id: widget.id)),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => CheckPage(id: widget.id)),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => WalletPage(id: widget.id)),
              );
              break;
            case 4:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => ProfilePage(id: widget.id)),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "หน้าแรก"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "คำสั่งซื้อ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: "ตรวจสอบ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: "กระเป๋าสตางค์ และสลาก",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "โปรไฟล์"),
        ],
      ),
    );
  }
  Future<void> _redeemLotto(int lottoId) async {
  if (url.isEmpty) return;
  try {
    final response = await http.post(
      Uri.parse('$url/users/redeem-lotto/$lottoId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': widget.id}), // ส่ง userId ไป
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      // โชว์ snackbar บอกว่าได้เงินเท่าไหร่
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ขึ้นเงินสำเร็จ +${body['prizeAmount']} บาท')),
      );
      // reload list อีกครั้งหลังขึ้นเงิน
      _loadWinningLottos();
    } else {
      // กรณี error
      final body = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(body['message'] ?? 'ขึ้นเงินไม่สำเร็จ')),
      );
    }
  } catch (e) {
    debugPrint('Error redeem: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('เกิดข้อผิดพลาดในการขึ้นเงิน')),
    );
  }
}

}

