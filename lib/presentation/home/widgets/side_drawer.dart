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
          ))
        ],
      ),
    );
  }
}
