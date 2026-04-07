import 'package:azkar/App/home/page/home.dart';
import 'package:azkar/core/colors/colors.dart';
import 'package:azkar/core/function/app_icon.dart';
import 'package:azkar/core/function/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Splach extends StatefulWidget {
  const Splach({super.key});

  @override
  State<Splach> createState() => _SplachState();
}

class _SplachState extends State<Splach> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      pushto(context, HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: SvgPicture.asset(AppIcon.icon)),
          Text("الاذكار", style: TextStyle(color: Colors.white, fontSize: 50)),
        ],
      ),
    );
  }
}
