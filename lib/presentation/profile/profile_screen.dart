import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:seek_reunite/constants/constant_size.dart';
import 'package:seek_reunite/presentation/profile/controllers/profile_controller.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController controller = Get.put(ProfileController());
    controller.getUserData();
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(()=> Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizeConstant.getHeightSpace(40),
            const CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage('assets/images/adult.png'),
            ),
            SizeConstant.getHeightSpace(20),
            itemProfile('Name', controller.name.value ?? 'Jayneel Kanungo', CupertinoIcons.person),
            SizeConstant.getHeightSpace(10),
            itemProfile('Phone', controller.phone.value ?? '9082642479', CupertinoIcons.phone),
            SizeConstant.getHeightSpace(10),
            itemProfile('Address', 'Airoli', CupertinoIcons.location),
            SizeConstant.getHeightSpace(10),
            itemProfile('Email', controller.email.value ??  "", CupertinoIcons.mail),
            SizeConstant.getHeightSpace(20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                  ),
                  child: const Text('Edit Profile')
              ),
            )
          ],
        )),
      ),
    );
  }

  itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xFFE8E8E8),
          borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
        trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
        tileColor: Colors.white,
      ),
    );
  }
}
