import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seek_reunite/constants/constant_fonts.dart';
import 'package:seek_reunite/presentation/auth/navigation_screen.dart';
import 'package:seek_reunite/presentation/complaint/screens/my_complaints_screen.dart';
import 'package:seek_reunite/presentation/police/map_screen.dart';
import 'package:seek_reunite/presentation/profile/profile_screen.dart';

import '../../../constants/contant_colors.dart';

class SideNavDrawer extends StatelessWidget {
  const SideNavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                    radius: 50,
                      backgroundImage: AssetImage("assets/images/jayneel_pic.png"),
                    ),
                  ),
                  const Text(
                    "Ethan Jones",
                    style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: ConstantFonts.poppinsBold),
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser!.email ?? "",
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.person_search_rounded, color: Colors.black,),
              title: const Text('My Complaints',
              style: TextStyle(color: Colors.black),),
              onTap: () {
                Get.to(() =>  const MyComplaintsScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline_rounded, color: Colors.black),
              title: const Text('Profile',
               style: TextStyle(color: Colors.black),),
              onTap: () {
                Get.to(() =>  const ProfileScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_none_outlined, color: Colors.black),
              title: const Text('Notifications',
              style: TextStyle(color: Colors.black),),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.add_alert, color: Colors.black,),
              title: const Text('Police Stations Near me',
              style: TextStyle(color: Colors.black),),
              onTap: () {
                Get.to(const MapScreen());
              },
            ),
            const Divider(color: Colors.black),
            ListTile(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sign Out Successfully")));
                Get.to(() =>  const NavigationScreen());
              },
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.black)),
            ),
        ],
        ),
      ),
    );
  }
}
