import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seek_reunite/presentation/identify_person/screens/authenticate_face_view.dart';

import '../../profile/profile_screen.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) async {
        if(index == 0){
        }else if(index == 1){
          Get.to(const AuthenticateFaceView());
        }else{
          Get.to(const ProfileScreen());
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera),
          label: "Found",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}
