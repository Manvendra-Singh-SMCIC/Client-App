// ignore_for_file: prefer_const_constructors

import 'package:client_app_amacle_studio/main.dart';
import 'package:client_app_amacle_studio/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constant.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({super.key});

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  _navigate() async {
    await Future.delayed(Duration(seconds: 4), () {});
    if (mounted) {
      Get.offAll(() => HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: white,
        child: Center(
          child: SizedBox(
            height: height(context) * 0.5,
            width: width(context) * 0.9,
            child: Image.asset("assets/amacle_banner.png"),
          ),
        ),
      ),
    );
  }
}
