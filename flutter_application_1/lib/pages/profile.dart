import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Check_lottery.dart';
import 'package:flutter_application_1/pages/Lotto_buy.dart';
import 'package:flutter_application_1/pages/home.dart';

class ProfilePage extends StatefulWidget {
  int id = 0;
  ProfilePage({super.key,required this.id});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE9D8), // โทนพื้นหลังใกล้เคียงภาพ
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF8C42),
        title: const Text(
          'Lotto CS',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // ใส่เมนูแฮมเบอร์เกอร์ถ้าต้องการ
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              // ทำ logout
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Column(
          children: [
            // การ์ดโปรไฟล์
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // รูปโปรไฟล์วงกลม
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: const NetworkImage(
                      'https://i.pravatar.cc/150?img=3', // ตัวอย่างรูป, เปลี่ยนเป็น asset หรือ url ของจริงได้
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'HooHoo',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  // ข้อมูลเบอร์ และ อีเมล
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'เบอร์: 081-234-5678',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'อีเมล: user@email.com',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // ปุ่มแก้ไขข้อมูล
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit, color: Colors.black87),
                      label: const Text(
                        'แก้ไขข้อมูลส่วนตัว',
                        style: TextStyle(color: Colors.black87),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFAAF27F), // สีเขียวอ่อน
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        // ไปหน้าแก้ไขข้อมูล (ตัวอย่างใช้ dialog)
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('แก้ไขข้อมูล'),
                            content: const Text(
                              'ตัวอย่าง: เปิดหน้าแก้ไขข้อมูลที่นี่',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('ปิด'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // ปุ่มเปลี่ยนรหัสผ่าน
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.lock, color: Colors.white),
                      label: const Text('เปลี่ยนรหัสผ่าน'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8DAA), // สีชมพูอ่อน
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        // ไปหน้าเปลี่ยนรหัสผ่าน
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('เปลี่ยนรหัสผ่าน'),
                            content: const Text(
                              'ตัวอย่าง: เปิดหน้าเปลี่ยนรหัสผ่านที่นี่',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('ปิด'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // ถ้าต้องการเพิ่มข้อมูลอื่น ๆ ให้ใส่ที่นี่
          ],
        ),
      ),
      // BottomNavigationBar แบบแยกไฟล์/หน้า
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
                MaterialPageRoute(builder: (_) => LottoBuyPage(id: widget.id)),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) =>  CheckPage(id: widget.id)),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomePage(id: 0)
                ), //<<WalletPage
              );
              break;
            case 4:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) =>  ProfilePage(id: widget.id)),
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
