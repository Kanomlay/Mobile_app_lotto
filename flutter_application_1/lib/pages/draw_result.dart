import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/config.dart';
import 'package:flutter_application_1/model/prize_req.dart';
import 'package:http/http.dart' as http;
import 'admin.dart';

class DrawResultPage extends StatefulWidget {
  const DrawResultPage({super.key});

  @override
  State<DrawResultPage> createState() => _DrawResultPageState();
}

class _DrawResultPageState extends State<DrawResultPage> {
  final Random random = Random();
  List<Map<String, dynamic>> results = [];
  String url = '';

  // เงินรางวัลแต่ละลำดับ
  final prizeMoney = [2000000, 200000, 20000]; // รางวัลที่ 1,2,3

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      setState(() {
        url = config['apiEndpoint'];
      });
    });
  }

  Future<void> drawAndFetchPrizes() async {
    final res = await http.post(Uri.parse('$url/prizes/draw'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      // อัพเดต UI
      setState(() {
        results = (data['prizes'] as List).map((p) {
          return {
            "prize": p['prize_name'],
            "number": p['winning_number'],
            "money": p['prize_amount'],
          };
        }).toList();
      });
    } else {
      debugPrint('ออกรางวัลไม่สำเร็จ: ${res.body}');
    }
  }

  Future<void> drawsold() async {
  final res = await http.post(Uri.parse('$url/prizes/draw/sold'));
  if (res.statusCode == 200) {
    final data = jsonDecode(res.body);

    setState(() {
      results = (data['prizes'] as List).map((p) {
        return {
          "prize": p['prize_name'],
          "number": p['winning_number'],
          "money": p['prize_amount'],
        };
      }).toList();
    });
  } else {
    // อ่าน error message จาก API
    final err = jsonDecode(res.body);
    final errorMsg = err['error'] ?? 'เกิดข้อผิดพลาด';

    // แจ้งเตือนผู้ใช้
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('แจ้งเตือน'),
          content: Text(errorMsg),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ตกลง'),
            ),
          ],
        ),
      );
    }

    debugPrint('ออกรางวัลไม่สำเร็จ: ${res.body}');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFCBA4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF8C42),
        elevation: 0,
        title: const Text(
          "Lotto CS",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const loginpages()),
              );
            },
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: const Color(0xFFFF8C42),
            child: const Center(
              child: Text(
                "สวัสดีคุณ ADMIN\nSTEVE",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: drawAndFetchPrizes,
                      child: const Text(
                        "สุ่มรางวัล",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "🎉 ผลรางวัล",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (results.isEmpty) const Text("ยังไม่มีการออกรางวัล"),
                    for (var r in results)
                      Text(
                        "${r['prize']}: ${r['number']}   เงินรางวัล: ${r['money']}",
                      ),
                    const SizedBox(height: 20),

                    // 🔹 ปุ่มใหม่ สุ่มจากที่ขาย
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: drawsold,
                      child: const Text(
                        "สุ่มจากที่ขาย",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
