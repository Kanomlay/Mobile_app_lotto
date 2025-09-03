import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class registers extends StatefulWidget {
  const registers({super.key});

  @override
  State<registers> createState() => _registerState();
}

class _registerState extends State<registers> {
  void BackButton() {
    Navigator.pop(context);
  }

  void Register() {}
  void login() {}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
