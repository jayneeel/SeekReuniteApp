import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:seek_reunite/constants/constant_fonts.dart';
import 'package:seek_reunite/screens/auth/navigation_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 4), ()=> Get.to(const NavigationScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset("assets/animations/handshake.json"),
            const SizedBox(height: 20,),
            const Text("Seek Reunite", style: TextStyle(fontFamily: ConstantFonts.poppinsBold, fontSize: 20),),
          ],
        )
      ),
    );
  }
}
