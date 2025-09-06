import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/admin.dart';
import 'package:flutter_application_1/pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lotto CS',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const AdminPage(), // เริ่มที่หน้า Admin
    );
  }
}
