import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:firebase_core/firebase_core.dart';

class ComplaintController extends GetxController {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Reference reference = FirebaseStorage.instance.ref().child('complaints');

  String username = 'seekreunite@gmail.com';
  String password = 'bqcl qyjr ppgg gzub';
  final metadata = SettableMetadata(
    contentType: 'image/jpeg',
  );

  Future<void> lodgeComplaint(
      String name, String address, String description, DateTime lostSince, int age, File picture) async {
    DateTime now = DateTime.now();
    String url = "";
    UploadTask uploadTask = reference.child(name + now.microsecondsSinceEpoch.toString()).putFile(picture, metadata);
    uploadTask.then((res) async {
      url = await res.ref.getDownloadURL();
      final Map<String, dynamic> complaintDetailsMap = {
        "name": name,
        "age": age,
        "lostSince": lostSince,
        "address": address,
        "description": description,
        "lodgeOn": now,
        "lodgedBy": auth.currentUser?.uid,
        "referenceId": now.microsecondsSinceEpoch.toString(),
        "picture": url
      };

      await db.collection("complaints").doc(complaintDetailsMap['referenceId']).set(complaintDetailsMap);
      Get.dialog(
        AlertDialog(
          title: const Text('Complaint lodged!'),
          content: Text('Your reference ID is ${complaintDetailsMap['referenceId']}'),
          actions: [
            TextButton(
              child: const Text("Ok"),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      );
      sendComplaintConfirmationMail(complaintDetailsMap);
    });
  }

  Future<void> sendComplaintConfirmationMail(Map<String, dynamic> details) async {
    final smtpServer = gmail(ComplaintController().username, ComplaintController().password);
    final message = Message()
      ..from = Address(username, 'SeekReunite')
      ..recipients.add(auth.currentUser!.email)
      ..subject = 'Registration of Complaint on SeekReunite ${details['referenceId']}'
      ..text = 'Your complaint has been registered on SeekReunite app. Your reference ID is ${details['referenceId']}';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
    } on MailerException catch (e) {
      print(e.message);
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
