import 'dart:convert';
import 'dart:developer'; // ใช้ log() ได้
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/order_id_res.dart';
import 'package:flutter_application_1/model/user_id_res.dart';
import 'package:flutter_application_1/pages/Check_lottery.dart';
import 'package:flutter_application_1/pages/Lotto_buy.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/profile.dart';
import 'wallet_info_page.dart';
import 'package:flutter_application_1/config.dart';
import 'package:http/http.dart' as http;

class WalletPage extends StatefulWidget {
  int id = 0;

  WalletPage({super.key, required this.id});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late Future<void> _initializeData;
  UserIdRes? user;
  OrderIdRes? order; // เก็บข้อมูลที่โหลดมา
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    log('User ID from WalletPage: ${widget.id}'); // log id ตอนเปิดหน้า
    _initializeData = _loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Lotto CS"),
        actions: const [
          Padding(padding: EdgeInsets.all(8.0), child: Text("Logout")),
        ],
      ),
      body: FutureBuilder(
        future: _initializeData,
        builder: (context, snapshot) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (user == null) {
            return const Center(child: Text('ไม่สามารถโหลดข้อมูลได้'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Account Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "เลขบัญชี",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "*** * **123 4",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${user!.walletBalance} บาท", // แสดงเงินจาก API
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _actionButton(Icons.credit_card, "เติมเงิน"),
                    _actionButton(Icons.account_balance, "โอนเงิน"),
                    _actionButton(Icons.history, "ประวัติ"),
                  ],
                ),
                const SizedBox(height: 16),

                // Ticket list (ของเดิม)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4),
                    ],
                  ),
                  // child: Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     const Text(
                  //       "สลากกินแบ่งรัฐบาลทั้งหมด",
                  //       style: TextStyle(fontWeight: FontWeight.bold),
                  //     ),
                  //     const SizedBox(height: 8),
                  //     for (var t in widget.tickets)
                  //       GestureDetector(
                  //         onTap: () {
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //               builder: (_) => WalletInfoPage(ticket: t),
                  //             ),
                  //           );
                  //         },
                  //         child: Card(
                  //           child: ListTile(
                  //             leading: Text(
                  //               "${t['price']} บาท",
                  //               style: const TextStyle(
                  //                 color: Colors.red,
                  //                 fontWeight: FontWeight.bold,
                  //               ),
                  //             ),
                  //             title: Text(
                  //               t['number'],
                  //               style: const TextStyle(
                  //                 fontSize: 18,
                  //                 fontWeight: FontWeight.bold,
                  //               ),
                  //             ),
                  //             subtitle: Row(
                  //               mainAxisAlignment:
                  //                   MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Text("งวดที่ ${t['round']}"),
                  //                 Text("ชุดที่ ${t['set']}"),
                  //                 Text(
                  //                   t['status'],
                  //                   style: TextStyle(
                  //                     color: t['status'] == "จ่ายแล้ว"
                  //                         ? Colors.green
                  //                         : Colors.red,
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //   ],
                  // ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        currentIndex: 3, // กระเป๋าสตางค์
        onTap: (index) {
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
              // อยู่หน้านี้แล้ว ไม่ต้องทำอะไร
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "หน้าหลัก"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "กำลังซื้อ",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "ตรวจสอบ"),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: "กระเป๋าสตางค์",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "โปรไฟล์"),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey[200],
          child: Icon(icon, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }

Future<void> _loadDataAsync() async {
  try {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    // โหลด user
    var res = await http.get(Uri.parse('$url/users/${widget.id}'));
    if (res.statusCode == 200) {
      var userRes = userIdResFromJson(res.body);
      user = userRes;
    }

    // โหลด orders ของ user
    var resOrders = await http.get(Uri.parse('$url/orders/${widget.id}'));
    if (resOrders.statusCode == 200) {
      order = jsonDecode(resOrders.body);
    }

    setState(() {
      _isLoading = false;
    });
  } catch (e) {
    log('Error loading user or orders: $e');
    setState(() {
      _isLoading = false;
    });
  }
}

}
