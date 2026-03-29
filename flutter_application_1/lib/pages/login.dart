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
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // ❌ ห้าม back ออกจากหน้า login
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "SIGN IN",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
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
                      decoration: const InputDecoration(
                        hintText: "Input your email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: passwordHash,
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
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () {
                          login();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("ยังไม่ได้เป็นสมาชิก CS ใช่ไหม? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const register(),
                        ),
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
      ),
    );
  }

  void login() {
    LoginReq req = LoginReq(email: email.text, password: passwordHash.text);

    http
        .post(
          Uri.parse('$url/users/login'),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: jsonEncode(req.toJson()),
        )
        .then((value) {
          log('>>> email: ${req.email}');
          log('>>> password: ${req.password}');
          log(value.body);

          final data = jsonDecode(value.body);
          if (data['error'] != null) {
            log('Login error: ${data['error']}');
            return;
          }

          LoginRes loginRes = LoginRes.fromJson(data);
          log(loginRes.message);

          // ตรวจ role
          if (loginRes.user.role.toLowerCase() == 'admin') {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => AdminPage()),
              (Route<dynamic> route) => false,
            );
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(id: loginRes.user.userId),
              ),
              (Route<dynamic> route) => false,
            );
          }
        })
        .catchError((error) {
          log(error.toString());
        });
  }
}
