import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seek_reunite/constants/constant_fonts.dart';
import 'package:seek_reunite/constants/constant_size.dart';
import 'package:seek_reunite/constants/contant_colors.dart';
import 'package:seek_reunite/utils/shared_prefs_helper.dart';
import 'package:seek_reunite/widgets/custom_button.dart';
import 'package:seek_reunite/widgets/custom_text_field.dart';

import '../home/screens/home_screen.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Sign In", style: TextStyle(fontFamily: ConstantFonts.poppinsBold, fontSize: 24, color: ConstantColors.blackColor),),
              const Text("Enter your email and password.", style: TextStyle(fontFamily: ConstantFonts.poppinsRegular, fontSize: 12, color: ConstantColors.lightGreyColor),),
              SizeConstant.getHeightSpace(30),
              MyTextField(controller: emailController, hintText: "email", obscureText: false, inputType: TextInputType.emailAddress,),
              SizeConstant.getHeightSpace(10),
              MyTextField(controller: passwordController, hintText: "password", obscureText: true, inputType: TextInputType.visiblePassword,),
              SizeConstant.getHeightSpace(20),
              CustomButton(text: "Sign In", onTap: (){
                signInUser(emailController, passwordController, context);

              })
            ],
          ),
        ),
      ),
    );
  }

  void signInUser(TextEditingController emailController, TextEditingController passwordController, BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sign In Successful!")));
    Helper().updateSharedPrefs(email: FirebaseAuth.instance.currentUser!.email, uid: FirebaseAuth.instance.currentUser!.uid, loggedInStatus: true);
    Get.to(const HomeScreen());
  }
}
