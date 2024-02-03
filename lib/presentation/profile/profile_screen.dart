import 'package:flutter/material.dart';
import 'package:seek_reunite/widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              CustomButton(text: "Logout", textStyle: TextStyle(color: Colors.red),suffixIcon: Icon(Icons.logout), color: Colors.transparent, borderColor: Colors.red,)
            ],
          ),
        ),
      ),
    );
  }
}
