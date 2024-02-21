import 'package:flutter/material.dart';
import 'package:frontend/screen/Home_screen.dart';
import 'package:frontend/screen/signIn_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Server Task",
      home: LoginScreen(),
    );
  }
}
