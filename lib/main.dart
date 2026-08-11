import 'package:flutter/material.dart';
import 'package:room_rental/pages/auth/login_page.dart';
import 'package:room_rental/pages/home/home_page.dart';
import 'package:room_rental/services/api_service.dart';

import 'navbar.dart';


final apiService = ApiService();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowMaterialGrid: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LoginPage(),
    );
  }
}
