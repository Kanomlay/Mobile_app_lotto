import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'admin.dart';

class DrawResultPage extends StatefulWidget {
  const DrawResultPage({super.key});

  @override
  State<DrawResultPage> createState() => _DrawResultPageState();
}

class _DrawResultPageState extends State<DrawResultPage> {
  final Random random = Random();
  List<Map<String, dynamic>> results = [];

  // เงินรางวัลแต่ละลำดับ
  final prizeMoney = [2000000, 200000, 20000, 2000, 200];

  void drawLotto() {
    Set<int> numbers = {};
    while (numbers.length < 5) {
      numbers.add(random.nextInt(1000000)); // สุ่มเลข 6 หลัก
    }

    final nums = numbers.toList();

    setState(() {
      results = List.generate(nums.length, (index) {
        return {
          "prize": "รางวัลที่ ${index + 1}",
          "number": nums[index].toString().padLeft(6, "0"),
          "money": prizeMoney[index],
        };
      });

      // เพิ่มรางวัลเลขท้าย 3 ตัว และ 2 ตัว
      if (results.isNotEmpty) {
        final firstPrize = results[0]["number"];
        results.add({
          "prize": "รางวัลเลขท้าย 3 ตัว",
          "number": firstPrize.substring(3),
          "money": 4000,
        });
        results.add({
          "prize": "รางวัลเลขท้าย 2 ตัว",
          "number": firstPrize.substring(4),
          "money": 2000,
        });
      }
    });
  }

  void resetDraw() {
    setState(() {
      results.clear();
    });
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
                      onPressed: drawLotto,
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: resetDraw,
                      child: const Text(
                        "รีเซ็ต",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("บันทึกผลการออกรางวัลแล้ว"),
                          ),
                        );
                      },
                      child: const Text(
                        "บันทึกออกรางวัล",
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
