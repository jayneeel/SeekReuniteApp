import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var name = "".obs;
  var email = "".obs;
  var phone = "".obs;

  Future<void> getUserData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('users').doc(_auth.currentUser?.uid).get();
      // Retrieve user data from the snapshot
      name.value = snapshot.data()?['name'] ?? '';
      email.value = snapshot.data()?['email'] ?? '';
      phone.value = snapshot.data()?['phone'] ?? '';
    } catch (e) {
      print("Error fetching users: $e");
    }
  }
}