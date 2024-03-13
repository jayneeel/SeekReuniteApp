//8658EFF1C2A44F2F245476740BF667308B6E
//F7C4ED6F37CF3374F25AEFD930D90C33AE6AD8B88A55B217FCBD30060420355ADC985391BD0813D6574E90DC5B1E5BF2
//FXQY5E4LK7657CTA52SV2X2H
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/mailer.dart';

class ComplaintController extends GetxController{
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  String username = 'seekreunite@gmail.com';
  String password = 'FinalProj#2024';





  Future<void> lodgeComplaint(String name, String address, String description, DateTime lostSince, int age) async {
    DateTime now = DateTime.now();
    final Map<String, dynamic> complaintDetailsMap = {
      "name": name,
      "age": age,
      "lostSince": lostSince,
      "address": address,
      "description": description,
      "lodgeOn": now,
      "lodgedBy": auth.currentUser?.uid
    };
    await db.collection("complaints").doc(now.microsecondsSinceEpoch.toString()).set(complaintDetailsMap);
    Get.dialog(
          AlertDialog(
            title: const Text('Complaint lodged!'),
            content: Text('Your reference ID is ${now.microsecondsSinceEpoch.toString()}'),
            actions: [
              TextButton(
                child: const Text("Ok"),
                onPressed: () => Get.back(),
              ),
            ],
          ),
    );

    final gmailSmtp = gmail(username, password);

    SendMailFromGmail() async{
      final message = Message()
        ..from = Address(username, 'SeekReunite')
        ..recipients.add('${User.email}')
        ..subject = 'Registration of Complaint on SeekReunite${DateTime.now()}'
        ..text = 'Your complaint has been registered on SeekReunite app.Your reference ID is ${now.microsecondsSinceEpoch.toString()}';

      try {
        final sendReport = await send(message, gmailSmtp);
        print('Message sent: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message not sent.');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
    }




  }
    }





