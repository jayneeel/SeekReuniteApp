import 'package:flutter/material.dart';
import 'package:seek_reunite/constants/constant_size.dart';
import 'package:seek_reunite/constants/contant_colors.dart';
import 'package:seek_reunite/presentation/auth/sign_in_screen.dart';
import 'package:seek_reunite/presentation/auth/sign_up_screen.dart';
import 'package:seek_reunite/widgets/custom_button.dart';
import 'package:get/get.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seek Reunite"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomButton(
              text: "Sign Up",
              onTap: () => Get.to(const SignUpScreen()),
            ),
            SizeConstant.getHeightSpace(20),
            CustomButton(
              text: "Sign In",
              borderColor: ConstantColors.primaryColor,
              color: Colors.white,
              textStyle: const TextStyle(color: ConstantColors.primaryColor),
              onTap: () => Get.to(const SignInPage()),
            ),
          ],
        ),
      ),
    );
  }
}
