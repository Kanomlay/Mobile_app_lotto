import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config.dart';
import 'package:flutter_application_1/model/register_req.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:http/http.dart' as http;

class register extends StatefulWidget {
  const register({super.key});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  String url = '';
    final firstNameController =
        TextEditingController(); // ... (rest of the code)
    final lastNameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final passController = TextEditingController();
    final conpassController = TextEditingController();
    final moneyController = TextEditingController();
    bool agreeTerms = false;

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((config) {
      url = config['apiEndpoint'];
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "SIGN UP",
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
            // โลโก้
            const Text(
              "Lotto\nCS",
              textAlign: TextAlign.center,
              style: TextStyle(
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

            // ฟอร์ม
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
                children: [
                  // ชื่อ
                  TextField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      labelText: "กรอกชื่อ",
                      hintText: "ชื่อจะต้องตรงกับเอกสาร...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // นามสกุล
                  TextField(
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      labelText: "กรอกนามสกุล",
                      hintText: "นามสกุลจะต้องตรงกับเอกสาร...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // เบอร์โทรศัพท์
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: "รหัสประเทศ",
                            hintText: "+66",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 4,
                        child: TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: "หมายเลขโทรศัพท์",
                            hintText: "903686654",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Email
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email ID",
                      hintText: "กรอกอีเมล",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Email
                  TextField(
                    controller: moneyController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Money",
                      hintText: "กลอกเงินเริ่มต้น",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: passController,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      hintText: "กรอกรหัสผ่าน",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: conpassController,
                    decoration: const InputDecoration(
                      labelText: "ConfirmPassword",
                      hintText: "กรอกรหัสผ่านยืนยัน",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  // Checkbox ยอมรับเงื่อนไข
                  Row(
                    children: [
                      StatefulBuilder(
                        builder: (context, setState) {
                          return Checkbox(
                            value: agreeTerms,
                            onChanged: (val) {
                              setState(() {
                                agreeTerms = val ?? false;
                              });
                            },
                          );
                        },
                      ),
                      const Expanded(
                        child: Text(
                          "ฉันยอมรับข้อกำหนดและเงื่อนไข",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ปุ่ม SIGN UP
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                        Register();
                      },
                      child: const Text(
                        "SIGN UP",
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

            // ข้อความมีบัญชีอยู่แล้ว
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("มีบัญชีอยู่แล้วใช่ไหม? "),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "ลงชื่อเข้าใช้ที่นี่",
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

  void Register() {
    // var sample = {
    //   "first_name": "a",
    //   "last_name": "User",
    //   "phone_number": "0812345678",
    //   "email": "a@a",
    //   "password_hash": "123456",
    //   "wallet_balance": 1000,
    // };
    RegisterReq req = RegisterReq(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      phoneNumber: phoneController.text,
      email: emailController.text,
      passwordHash: passController.text,
      walletBalance: int.parse(moneyController.text),
    );    
    if (passController.text != conpassController.text) {
      log('Passwords do not match');
      return;
    }


    http
        .post(
          Uri.parse('$url/users/register'),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: jsonEncode(req),
        )
        .then((value) {
          log(value.body);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => loginpages(),)
          );
        })
        .catchError((error) {});
  }
}
