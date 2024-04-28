import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seek_reunite/utils/size_extension.dart';
import 'package:seek_reunite/widgets/custom_button.dart';

import '../../../constants/theme.dart';
import '../../../utils/camera_view.dart';
import '../../../utils/helpers.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Authenticate Person"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(text: "Capture Person Face", prefixIcon: Icon(Icons.camera), onTap: () async {
           XFile? file = await Helpers.capturePhoto();
          },)
        ],
      ),
    );
  }
}
