import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seek_reunite/models/user.dart';
import 'package:seek_reunite/presentation/auth/controllers/auth_controller.dart';
import 'package:seek_reunite/utils/helpers.dart';
import '../../constants/constant_fonts.dart';
import '../../constants/constant_size.dart';
import '../../constants/contant_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(AuthController());
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    Helpers helpers= Helpers();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Sign Up", style: TextStyle(fontFamily: ConstantFonts.poppinsBold, fontSize: 24, color: ConstantColors.blackColor),),
              const Text("Let's create your account!", style: TextStyle(fontFamily: ConstantFonts.poppinsRegular, fontSize: 12, color: ConstantColors.lightGreyColor),),
              SizeConstant.getHeightSpace(30),
              MyTextField(controller: nameController, hintText: "full name", obscureText: false),
              SizeConstant.getHeightSpace(10),
              MyTextField(controller: phoneController, hintText: "phone", obscureText: false, inputType: TextInputType.phone),
              SizeConstant.getHeightSpace(10),
              MyTextField(controller: emailController, hintText: "email", obscureText: false, inputType: TextInputType.emailAddress,),
              SizeConstant.getHeightSpace(10),
              MyTextField(controller: passwordController, hintText: "password", obscureText: true, inputType: TextInputType.visiblePassword,),
              SizeConstant.getHeightSpace(20),
              CustomButton(text: "Sign Up", onTap: (){
                UserAuthModel user = UserAuthModel(name: nameController.text, phone: phoneController.text, email: emailController.text, passwordHash: helpers.generatePasswordHash(passwordController.text), profileAvatar: "");
                controller.createUser(user, passwordController.text);
              },)
            ],
          ),
        ),
      ),
    );
  }
}
