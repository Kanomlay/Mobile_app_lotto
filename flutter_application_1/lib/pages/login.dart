//import 'dart:nativewrappers/_internal/vm/lib/developer.dart';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/login_req.dart';
import 'package:flutter_application_1/model/login_res.dart';
import 'package:flutter_application_1/pages/admin.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/pages/register.dart';
import 'package:flutter_application_1/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class loginpages extends StatefulWidget {
  const loginpages({super.key});

  @override
  State<loginpages> createState() => _LoginpagesState();
}

class _LoginpagesState extends State<loginpages> {
  var email = TextEditingController();
  var passwordHash = TextEditingController();
  String url = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Configuration.getConfig().then((config) {
      setState(() {
        url = config['apiEndpoint'];
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    pinController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (url.isEmpty) {
      print("API endpoint URL is not loaded yet.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot connect to server. Please try again later.'),
        ),
      );
      return;
    }

    final req = LoginReq(
      email: emailController.text,
      passwordHash: pinController.text,
    );

    try {
      final response = await http.post(
        Uri.parse('$url/users/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(req.toJson()),
      );

      // ใช้ mounted check เพื่อความปลอดภัย
      if (!mounted) return;

      if (response.statusCode == 200) {
        final res = loginResFromJson(response.body);
        final userRole = res.user.role;

        if (userRole == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } else {
        final errorBody = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Login failed: ${errorBody['error'] ?? 'Unknown error'}',
            ),
          ),
        );
      }
    } catch (e) {
      print("An error occurred: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cannot connect to the server. Please check your connection.',
          ),
        ),
      );
    }
  }

  //--- ส่วนของการสร้าง UI ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Allows the back button to function correctly
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "SIGN IN",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.black),
            onPressed: () {
              // ควรใส่ Navigator.pushAndRemoveUntil เพื่อกลับไปหน้าแรกสุด
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
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
                  const Text("มีบัญชีผู้ใช้แล้วใช่ไหม?"),
                  const SizedBox(height: 10),
                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                      hintText: "Input your email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: passwordHash,
                    //obscureText: true,
                    decoration: InputDecoration(
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: login,
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
