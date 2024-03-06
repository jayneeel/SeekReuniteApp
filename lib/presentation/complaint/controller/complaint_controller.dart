import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComplaintController extends GetxController{
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;


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
  }

}