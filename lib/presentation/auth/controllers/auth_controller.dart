import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:seek_reunite/models/user.dart';
import 'package:flutter/material.dart';
import 'package:seek_reunite/presentation/home/screens/home_screen.dart';

class AuthController extends GetxController {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> createUser(UserAuthModel user, String password) async {
    auth
        .createUserWithEmailAndPassword(email: user.email ?? "", password: password)
        .then((cred) => db.collection("users").doc(cred.user?.uid).set(user.toJson()).then((value) => Get.snackbar(
              "Account Created",
              "Congratulations!",
              colorText: Colors.white,
              backgroundColor: Colors.lightBlue,
              icon: const Icon(Icons.add_alert_rounded, color: Colors.white,),
            )));
    Get.to(const HomeScreen());
  }

  Future<void> loginUser(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.to(const HomeScreen());
      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar(
          "Invalid Credentials",
          "Please check email and password!",
          colorText: Colors.white,
          backgroundColor: Colors.lightBlue,
          icon: const Icon(Icons.add_alert_rounded, color: Colors.white));
        return;
      } else if (e.code == 'invalid-credential') {
        Get.snackbar(
          "Incorrect Password",
          "Please enter correct password!",
          colorText: Colors.white,
          backgroundColor: Colors.lightBlue,
          icon: const Icon(Icons.add_alert_rounded, color: Colors.white));
        return;
      } else {
        Get.snackbar(
            e.toString(),
            "Please enter correct password!",
            colorText: Colors.white,
            backgroundColor: Colors.lightBlue,
            icon: const Icon(Icons.add_alert_rounded, color: Colors.white));
      }
    } catch (e) {
      log(e.toString(),name: "exception");
    }
  }
}
