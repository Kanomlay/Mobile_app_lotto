import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/config.dart';
import 'package:flutter_application_1/model/user_id_res.dart'; // ✅ ใช้ model นี้
import 'package:flutter_application_1/pages/Check_lottery.dart';
import 'package:flutter_application_1/pages/Lotto_buy.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/wallet_page.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  int id = 0; // ✅ ใช้ final ดีกว่า
  ProfilePage({super.key, required this.id});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _currentIndex = 4;

  String url = '';
  UserIdRes? user; // ✅ ใช้ model ใหม่

  @override
  void initState() {
    super.initState();
    // ดึง config ก่อน
    Configuration.getConfig().then((config) {
      setState(() {
        url = config['apiEndpoint'];
      });
      _fetchUser(); // โหลด user หลังจากได้ url
    });
  }

  Future<void> _fetchUser() async {
    if (url.isEmpty) return;
    try {
      final res = await http.get(Uri.parse('$url/users/${widget.id}'));
      if (res.statusCode == 200) {
        final u = UserIdRes.fromJson(jsonDecode(res.body));
        setState(() {
          user = u;
        });
      } else {
        debugPrint('Load user failed: ${res.body}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE9D8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF8C42),
        title: const Text(
          'Lotto CS',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          TextButton(
            onPressed: () {
              // logout
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Column(
          children: [
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
              child: user == null
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: const NetworkImage(
                            'https://i.pravatar.cc/150?img=3',
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${user!.firstName} ${user!.lastName}',
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'อีเมล: ${user!.email}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'ยอดเงินคงเหลือ: ${user!.walletBalance} บาท',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'สิทธิ์: ${user!.role}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
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
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "คำสั่งซื้อ"),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: "ตรวจสอบ"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet), label: "กระเป๋าสตางค์ และสลาก"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "โปรไฟล์"),
        ],
      ),
    );
  }
}
