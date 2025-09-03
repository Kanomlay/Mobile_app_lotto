import 'dart:developer';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/register.dart';
import 'package:http/http.dart' as http;

class loginpages extends StatefulWidget {
  loginpages({super.key});

  @override
  State<loginpages> createState() => _loginpagesState();
}

class _loginpagesState extends State<loginpages> {
  String text = '';
  int count = 0;
  String number = '';
  var phone = TextEditingController();
  var pass = TextEditingController();
  String url = '';

  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () => login(),
              child: Image.asset(
                'assets/picture/25485ed144db9f474664a3600213d28d.png',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),

                  const Text(
                    'หมายเลขโทรศัพท์',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: phone,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'รหัสผ่าน',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    obscureText: true,
                    controller: pass,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),

                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: login,
                        child: const Text('เข้าสู่ระบบ'),
                      ),
                      FilledButton(
                        onPressed: register,
                        child: const Text('สมัครสมาชิก'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                child: Text(text),
                padding: const EdgeInsets.all(24.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login() {}

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => registers()),
    );
  }
}
