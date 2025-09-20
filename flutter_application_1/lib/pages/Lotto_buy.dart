import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config.dart';
import 'package:flutter_application_1/model/lotto_req.dart';
import 'package:flutter_application_1/pages/Check_lottery.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class LottoBuyPage extends StatefulWidget {
  const LottoBuyPage({super.key});

  @override
  State<LottoBuyPage> createState() => _LottoBuyPageState();
}

class _LottoBuyPageState extends State<LottoBuyPage> {
  int _currentIndex = 1;
  String url = '';
  bool _isLoading = true;
  List<LottoRes> _allLotto = [];
  List<LottoRes> _displayedLotto = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
      getlottos();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ไม่ต้องใช้ lottoNumbers แบบเดิมแล้ว
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Lotto CS", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
              ),
              const Positioned(
                right: 6,
                top: 6,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.white,
                  child: Text(
                    "1",
                    style: TextStyle(fontSize: 10, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ช่องค้นหา
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "กรอกหมายเลขสลาก",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 12,
                            ),
                          ),
                          onChanged: (value) {
                            // ค้นหาเรียลไทม์
                            _searchLottoByNumber(value);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // ค้นหาตอนกดปุ่ม
                          _searchLottoByNumber(_searchController.text);
                          // หรือถ้าจะค้นหา user ใช้ _searchLottoByUser(_searchController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text("ค้นหา"),
                      ),
                    ],
                  ),
                ),

                // รายการสลาก
                Expanded(
                  child: ListView.builder(
                    itemCount: _displayedLotto.length,
                    itemBuilder: (context, index) {
                      final lotto = _displayedLotto[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                lotto.lottoPrice, // แสดงราคาจาก model
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              ),
                              const Text("บาท", style: TextStyle(fontSize: 12)),
                            ],
                          ),
                          title: Text(
                            "สลากกินแบ่งรัฐบาล\n${lotto.lottoNumber}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                            ),
                            child: const Text("ใส่ตะกร้า"),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        // เหมือนเดิม
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
                MaterialPageRoute(builder: (_) => const HomePage(id: 0)),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LottoBuyPage()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const CheckPage()),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage(id: 0)),
              );
              break;
            case 4:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) =>  ProfilePage(id: 0)),
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

  Future<void> getlottos() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var res = await http.get(Uri.parse('$url/lottos'));
      if (res.statusCode == 200) {
        final List<LottoRes> lottoResList = (json.decode(res.body) as List)
            .map((e) => LottoRes.fromJson(e))
            .toList();
        log(res.body);
        setState(() {
          _allLotto = lottoResList;
          _displayedLotto = _allLotto;
          _isLoading = false;
        });
      }
    } catch (e) {
      log('Error fetching trips: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ฟังก์ชันค้นหาตามหมายเลขสลาก
  void _searchLottoByNumber(String query) {
    setState(() {
      if (query.isEmpty) {
        // ถ้ากล่องค้นหาว่าง แสดงทั้งหมด
        _displayedLotto = _allLotto;
      } else {
        _displayedLotto = _allLotto
            .where(
              (lotto) =>
                  lotto.lottoNumber.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  // ฟังก์ชันค้นหาตามชื่อคนสร้าง (หรือ field อื่น ๆ เช่น createdByUserId)
  // สมมติใน model มีชื่อคนสร้างชื่อว่า createdByUserId หรือ userName
  void _searchLottoByUser(String query) {
    setState(() {
      if (query.isEmpty) {
        _displayedLotto = _allLotto;
      } else {
        _displayedLotto = _allLotto
            .where(
              (lotto) => lotto.createdByUserId.toString().contains(query),
            ) // หรือ .userName
            .toList();
      }
    });
  }
}
