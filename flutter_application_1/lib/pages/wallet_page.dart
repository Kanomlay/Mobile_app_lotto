import 'package:flutter/material.dart';
import 'wallet_info_page.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  final double balance = 8000.00;

  final List<Map<String, dynamic>> tickets = const [
    {
      "price": 80,
      "number": "324958",
      "round": 24,
      "set": 1,
      "status": "ยังไม่จ่าย",
    },
    {
      "price": 80,
      "number": "324958",
      "round": 24,
      "set": 1,
      "status": "จ่ายแล้ว",
    },
  ];

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
      body: SingleChildScrollView(
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
                    children: const [
                      Text("เลขบัญชี", style: TextStyle(color: Colors.white)),
                      Text(
                        "*** * **123 4",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${balance.toStringAsFixed(2)} บาท",
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

            // Ticket list
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "สลากกินแบ่งรัฐบาลทั้งหมด",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  for (var t in tickets)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WalletInfoPage(ticket: t),
                          ),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          leading: Text(
                            "${t['price']} บาท",
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          title: Text(
                            t['number'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("งวดที่ ${t['round']}"),
                              Text("ชุดที่ ${t['set']}"),
                              Text(
                                t['status'],
                                style: TextStyle(
                                  color: t['status'] == "จ่ายแล้ว"
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        currentIndex: 3,
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
}
