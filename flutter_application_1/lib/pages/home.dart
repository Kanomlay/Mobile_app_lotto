import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Check_lottery.dart';
import 'package:flutter_application_1/pages/Lotto_buy.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/pages/profile.dart';
import 'package:flutter_application_1/pages/wallet_page.dart';

class HomePage extends StatefulWidget {
  final int id;
  const HomePage({super.key, required this.id});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          "Lotto CS",
          style: TextStyle(fontWeight: FontWeight.bold),
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
      drawer: const Drawer(), // เมนูซ้าย
      body: SingleChildScrollView(
        child: Column(
          children: [
            // รูปด้านบน
            Image.network(
              "https://www.lottery.co.th/sites/default/files/styles/lottery_ticket/public/lotto.jpg", // ตัวอย่าง URL
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            // แถบรอบออกรางวัล
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(8),
              child: const Text(
                "📢 รอบออกรางวัลต่อไป: 16/09/2568 📢",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            // การ์ดสวัสดี
            Container(
              width: double.infinity,
              color: Colors.orange,
              padding: const EdgeInsets.all(12),
              child: const Column(
                children: [
                  Text(
                    "สวัสดีคุณ",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    "HOOHOO",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "1 กันยายน 2568",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // การ์ดผลรางวัล
            Card(
              margin: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      "รางวัลที่ 1",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "735846",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text("รางวัลละ 6,000,000 บาท"),
                    const SizedBox(height: 16),

                    // เลขหน้า/ท้าย
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: const [
                            Text("เลขหน้า 3 ตัว"),
                            Text("561"),
                            Text("091"),
                            Text("2 รางวัล ๆ ละ 4,000 บาท"),
                          ],
                        ),
                        Column(
                          children: const [
                            Text("เลขท้าย 3 ตัว"),
                            Text("864"),
                            Text("025"),
                            Text("2 รางวัล ๆ ละ 4,000 บาท"),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: const [
                        Text("เลขท้าย 2 ตัว"),
                        Text(
                          "09",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("1 รางวัล ๆ ละ 2,000 บาท"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: const Color.fromARGB(255, 99, 99, 99),
        onTap: (index) {
          setState(() {
            _currentIndex = index; // อัปเดตปุ่มที่เลือก
          });

          // เปลี่ยนหน้า
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) =>  HomePage(id: widget.id)),
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
                MaterialPageRoute(builder: (_) => WalletPage(id: widget.id)
                ), //<<WalletPage
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
}
