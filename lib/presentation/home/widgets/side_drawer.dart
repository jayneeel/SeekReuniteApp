import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seek_reunite/constants/constant_fonts.dart';
import 'package:seek_reunite/presentation/auth/navigation_screen.dart';

import '../../../constants/contant_colors.dart';
import '../../../utils/shared_prefs_helper.dart';

class SideNavDrawer extends StatelessWidget {
  const SideNavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Container(
              color: ConstantColors.primaryColor,
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                    radius: 50,
                      backgroundImage: AssetImage("assets/images/navdrawerimg.png"),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ethan Johnson',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: ConstantFonts.poppinsBold),
                  ),
                  const Text(
                    'ethan.johnson@example.com',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: ConstantFonts.poppinsRegular),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.person_outline_rounded),
            title: const Text('Profile'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.person_search_rounded),
            title: const Text('My Complaints'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications_none_outlined),
            title: const Text('Notifications'),
            onTap: () {},
          ),
          const Divider(color: ConstantColors.lightGreyColor),
          ListTile(
            onTap: (){
              FirebaseAuth.instance.signOut();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sign Out Successfully")));
              Helper().updateSharedPrefs(email: null, uid: null, loggedInStatus: false);
              Get.to(() =>  const NavigationScreen());
            },
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
