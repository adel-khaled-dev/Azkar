import 'package:azkar/App/splach/splach.dart';
import 'package:azkar/core/colors/colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Splach(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'serif',
        scaffoldBackgroundColor: AppColor.background,
        useMaterial3: true,
      ),
    );
  }
}
