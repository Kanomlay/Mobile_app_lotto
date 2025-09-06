import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/register.dart';

class loginpages extends StatelessWidget {
  const loginpages({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();
    final pinController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          "SIGN IN",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            // โลโก้ชื่อแอป
            const Text(
              "Lotto\nCS",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'VampiroOne',
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
                shadows: [
                  Shadow(
                    blurRadius: 3,
                    color: Colors.black26,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // กล่องฟอร์ม
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("มีบัญชีผู้แล้วใช่ไหม?"),
                  const SizedBox(height: 10),

                  // ช่องกรอก Phone/Email
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      hintText: "Input your phone or email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // ช่องกรอก PIN
                  TextField(
                    controller: pinController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Input PIN",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "ลืมรหัส PIN การเข้าสู่ระบบ?",
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ปุ่ม Sign In
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                        // ใช้ pushReplacement เพื่อไปหน้า HomePage
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                      child: const Text(
                        "SIGN IN",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // สมัครสมาชิก
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("ยังไม่ได้เป็นสมาชิก CS ใช่ไหม? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const register()),
                    );
                  },
                  child: const Text(
                    "สมัครที่นี่",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
