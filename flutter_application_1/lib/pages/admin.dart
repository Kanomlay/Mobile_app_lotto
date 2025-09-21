import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config.dart';
import 'package:flutter_application_1/model/lotto_res.dart';

import 'package:flutter_application_1/pages/drawresult.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:http/http.dart' as http;

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String url = '';
  List<Lotto> lottos = [];

  @override
  void initState() {
    super.initState();
    // โหลดค่า URL จาก Configuration
    Configuration.getConfig().then((config) {
      setState(() {
        url = config['apiEndpoint'];
      });
    });
  }

  // ฟังก์ชันดึงข้อมูลล็อตโต้ทั้งหมด
  Future<void> fetchLottos() async {
    if (url.isEmpty) return;
    final uri = Uri.parse("$url/lottos");
    try {
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        // แปลง JSON เป็น List<Lotto>
        final List<dynamic> jsonData = json.decode(res.body);
        final List<Lotto> fetched = jsonData
            .map((e) => Lotto.fromJson(e))
            .toList();
        setState(() {
          lottos = fetched;
        });
        print("Fetched lottos: $fetched");
      } else {
        print("Failed to fetch lottos: ${res.statusCode}");
      }
    } catch (e) {
      print("Error fetching lottos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFCBA4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF8C42),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
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
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildRedButton(
                          context,
                          "ออกรางวัล",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DrawResultPage(),
                              ),
                            );
                          },
                        ),
                        _buildRedButton(
                          context,
                          "ดูรายการ",
                          onTap: fetchLottos,
                        ),
                        _buildRedButton(
                          context,
                          "รีเซ็ตระบบใหม่",
                          onTap: () async {
                            final uri = Uri.parse("$url/lottos/reset");
                            final res = await http.post(uri);
                            if (res.statusCode == 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "รีเซ็ตและสร้างล็อตโต้ใหม่แล้ว!",
                                  ),
                                ),
                              );
                              fetchLottos(); // โหลดข้อมูลใหม่
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: lottos.isEmpty
                          ? const Center(child: Text("ยังไม่มีข้อมูลล็อตโต้"))
                          : ListView.builder(
                              itemCount: lottos.length,
                              itemBuilder: (context, index) {
                                final lotto = lottos[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: ListTile(
                                    title: Text("เลข: ${lotto.lottoNumber}"),
                                    subtitle: Text(
                                      "ราคา: ${lotto.lottoPrice} บาท\nสถานะ: ${lotto.status}\nID: ${lotto.lottoId}",
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminPage()),
                  (route) => false,
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.menu, color: Colors.black),
                  Text(
                    "หน้าหลัก",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("ไปหน้าโปรไฟล์")));
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.person, color: Colors.black),
                  Text(
                    "โปรไฟล์",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRedButton(
    BuildContext context,
    String text, {
    VoidCallback? onTap,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onTap ?? () {},
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}

// class AdminService {
//   // ฟังก์ชันสุ่มล็อตโต้ 100 ใบ
//   static Future<void> genLottos(String url) async {
//     final random = Random();
//     List<Map<String, dynamic>> lottoList = [];

//     for (int i = 0; i < 100; i++) {
//       final number = random.nextInt(1000000);
//       final formattedNumber = number.toString().padLeft(6, '0');
//       lottoList.add({
//         "lotto_number": formattedNumber,
//         "lotto_price": 80,
//         "status": "AVAILABLE",
//         "created_by_user_id": 1,
//       });
//     }

//     // ❌ อย่าใส่ http ซ้ำ
//     // ✅ ตรวจสอบว่า url เริ่มด้วย http:// หรือ https://
//     if (!url.startsWith("http")) {
//       url = "http://$url";
//     }

//     final uri = Uri.parse("$url/lotto");
//     final res = await http.post(
//       uri,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"lottos": lottoList}),
//     );

//     if (res.statusCode == 200) {
//       print("บันทึกล็อตโต้สำเร็จ");
//     } else {
//       print("บันทึกล้มเหลว: ${res.body}");
//     }
//   }
// }
