import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seek_reunite/presentation/identify_person/controllers/authenticate_controller.dart';
import 'package:seek_reunite/utils/size_extension.dart';
import 'package:seek_reunite/widgets/custom_button.dart';

import '../../../constants/theme.dart';
import '../../../utils/camera_view.dart';
import '../../../utils/extract_face_feature.dart';
import '../../../utils/helpers.dart';

class CameraScreen extends StatelessWidget {
  CameraScreen({super.key});
  AuthenticateController controller = Get.put(AuthenticateController());

  @override
  Widget build(BuildContext context) {
    InputImage inputImage;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Authenticate Person"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(text: "Capture Person Face", prefixIcon: const Icon(Icons.camera), onTap: () async {
           final file = await Helpers.capturePhoto();
           inputImage = InputImage.fromFilePath(file!.path);

           controller.faceFeatures = await extractFaceFeatures(inputImage, controller.faceDetector);
          controller.fetchUsersAndMatchFace();
          log("*****************************************");
          },)
        ],
      ),
    );
  }
}
