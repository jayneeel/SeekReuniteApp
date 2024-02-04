import 'package:flutter/material.dart';

import '../../../constants/contant_colors.dart';

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
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 47, // Adjust size as needed
                  ),
                  SizedBox(height: 8),
                  Text(
                    ' Ethan Johnson',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Text(
                    'ethan.johnson@example.com',
                    style: TextStyle(color: Colors.white, fontSize: 14),
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
          TextButton(
            onPressed: () {
              // Handle logout logic here
            },
            child: const ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}
