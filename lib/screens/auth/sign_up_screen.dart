import 'package:flutter/material.dart';

import '../../constants/constant_fonts.dart';
import '../../constants/constant_size.dart';
import '../../constants/contant_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var phnoController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Sign Up", style: TextStyle(fontFamily: ConstantFonts.poppinsBold, fontSize: 24, color: ConstantColors.blackColor),),
              const Text("Let's create your account!", style: TextStyle(fontFamily: ConstantFonts.poppinsRegular, fontSize: 12, color: ConstantColors.lighGreyColor),),
              SizeConstant.getHeightSpace(30),
              MyTextField(controller: nameController, hintText: "full name", obscureText: false),
              SizeConstant.getHeightSpace(10),
              MyTextField(controller: phnoController, hintText: "phone", obscureText: false, inputType: TextInputType.phone,),
              SizeConstant.getHeightSpace(10),
              MyTextField(controller: emailController, hintText: "email", obscureText: false, inputType: TextInputType.emailAddress,),
              SizeConstant.getHeightSpace(10),
              MyTextField(controller: passwordController, hintText: "password", obscureText: true, inputType: TextInputType.visiblePassword,),
              SizeConstant.getHeightSpace(20),
              const CustomButton(text: "Sign Up")
            ],
          ),
        ),
      ),
    );
  }
}
