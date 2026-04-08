import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/main_nav/main_navigation.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins', // Opsional: Tambahkan font Poppins di pubspec.yaml agar lebih mirip
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home:  MainNavigation(),
    );
  }
}