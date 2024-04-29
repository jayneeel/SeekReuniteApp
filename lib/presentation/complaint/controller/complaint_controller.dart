import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:seek_reunite/presentation/home/screens/home_screen.dart';
import 'package:seek_reunite/utils/extract_face_feature.dart';
import 'package:uuid/uuid.dart';

import '../../../models/user_model.dart';

class ComplaintController extends GetxController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Reference complaintReference = FirebaseStorage.instance.ref().child('complaints');
  Reference firReference = FirebaseStorage.instance.ref().child('firs');

  String username = 'seekreunite@gmail.com';
  String password = 'bqcl qyjr ppgg gzub';
  final metadata = SettableMetadata(
    contentType: 'image/jpeg',
  );
  final selectedValue = 'Person Returned'.obs;
  final dropdownItems = [
    'Person Returned',
    'Person Found',
    'Police got the Lead',
  ];
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      performanceMode: FaceDetectorMode.accurate,
    ),
  );
  FaceFeatures? _faceFeatures;

  Future<void> closeComplaint(String refId) async {
    await db.collection("complaints").doc(refId).update({"active": false});
    Get.dialog(
      AlertDialog(
        title: const Text('Complaint lodged!'),
        content: Text('Your complaint with $refId is closed successfully!'),
        actions: [
          TextButton(
            child: const Text("Ok"),
            onPressed: () => Get.to(const HomeScreen()),
          ),
        ],
      ),
    );
  }

  Future<void> lodgeComplaint(String name, String address, String city,String description, DateTime lostSince, int age, int reward, String contact,
      File picture, File fir) async {
    DateTime now = DateTime.now();

    log("UPLOADINGGGGGGGGG...............");
    TaskSnapshot photoTask = await complaintReference
        .child(name + now.microsecondsSinceEpoch.toString())
        .putFile(picture, metadata);
    TaskSnapshot firTask = await firReference
        .child(name + now.microsecondsSinceEpoch.toString())
        .putFile(fir, metadata);

    String photoUrl = await photoTask.ref.getDownloadURL();
    String firUrl = await firTask.ref.getDownloadURL();

    log("UPLOADED...............");

    final Map<String, dynamic> complaintDetailsMap = {
      "name": name,
      "age": age,
      "lostSince": lostSince,
      "address": address,
      "description": description,
      "lodgeOn": now,
      "lodgedBy": auth.currentUser?.uid,
      "referenceId": now.microsecondsSinceEpoch.toString(),
      "picture": photoUrl,
      "active": true,
      "fir_complaint": firUrl,
      "city": city,
      "reward": reward,
      "contact": contact
    };


    log("SETTINGG............");
    await db.collection("complaints").doc(complaintDetailsMap['referenceId']).set(complaintDetailsMap);
    sendComplaintConfirmationMail(complaintDetailsMap);
    log("COMPLETED.................");
    registerFace(picture, complaintDetailsMap);
    Get.dialog(
      AlertDialog(
        title: const Text('Complaint lodged!'),
        content: Text('Your reference ID is ${complaintDetailsMap['referenceId']}'),
        actions: [
          TextButton(
            child: const Text("Ok"),
            onPressed: () => Get.to(const HomeScreen()),
          ),
        ],
      ),
    );
    // });
  }
  Future <void> registerFace(File image, complaintDetailsMap) async {
    final InputImage inputImage = InputImage.fromFilePath(image.path);
    _faceFeatures = await extractFaceFeatures(inputImage, _faceDetector);
    final Uint8List imageBytes = image.readAsBytesSync();
    final String base64Image = base64Encode(imageBytes);

    String userId = const Uuid().v1();
    UserModel user = UserModel(
      id: userId,
      name: complaintDetailsMap['name'],
      image: base64Image,
      registeredOn: int.parse(complaintDetailsMap['referenceId']),
      faceFeatures: _faceFeatures,
    );

    FirebaseFirestore.instance
        .collection("faces")
        .doc(userId)
        .set(user.toJson())
        .catchError((e) {
      log("Registration Error: $e");
    }).whenComplete(() {
      log("COMPLETEDDDDDDDDD!!!!!!!!");
    });
  }

  Future<void> sendComplaintConfirmationMail(Map<String, dynamic> details) async {
    final smtpServer = gmail(ComplaintController().username, ComplaintController().password);
    final message = Message()
      ..from = Address(username, 'SeekReunite')
      ..recipients.add(auth.currentUser!.email)
      ..subject = 'Registration of Complaint on SeekReunite ${details['referenceId']}'
      ..text = 'Your complaint has been registered on SeekReunite app. Your reference ID is ${details['referenceId']}'
      ..html = "<table><tr><p style='font-size=16px'>We hope this email finds you well. We understand how concerning it can be when a loved one goes missing, and we're here to support you through this difficult time.Firstly, we want to express our deepest sympathies for the situation you're facing. Your courage in reaching out and filing a missing person report through our app is commendable, and we're committed to assisting you in every possible way.We wanted to provide you with an update on the progress of your missing person report. Since you submitted the report, our team has been actively working to spread the word and gather information to aid in the search efforts. </p></tr><tr><td><p style='font-size:18px' >Your complaint has been registered on SeekReunite app. Your reference ID is ${details['referenceId']}.&emsp;Name : <b>${details['name']} &emsp;</b> Age : <b>${details['age']}</b></p></td></tr><tr><p style='font-size=16px'>Thank you once again for entrusting us with your missing person report. We remain hopeful for a positive outcome and will continue to work tirelessly until your loved one is safely reunited with you.</p></tr><tr><p style='font-size=16px'>Warm regards,</p></tr><tr><p style='font-size=16px'>Admin</p></tr><tr><p style='font-size=18px'><b>SeekReunite Team</b></p></tr></table>";


    try {
      final sendReport = await send(message, smtpServer);
      log('Message sent: $sendReport');
    } on MailerException catch (e) {
      log(e.message);
      for (var p in e.problems) {
        log('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

}