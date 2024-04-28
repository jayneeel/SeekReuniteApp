import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seek_reunite/presentation/complaint/screens/view_complaint_screen.dart';
import 'package:seek_reunite/presentation/complaint/widgets/complaint_card.dart';
import '../../../constants/constant_size.dart';

class MyComplaintsScreen extends StatelessWidget {
  const MyComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
        appBar: AppBar(
          title: const Text("My Complaints"),
          automaticallyImplyLeading: true,
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('complaints')
                .where('lodgedBy', isEqualTo: auth.currentUser!.uid)
                .where('active', isEqualTo: true)
                .snapshots(),
            builder: (_, snapshot) {
              if (snapshot.hasError) return Text('Error = ${snapshot.error}');

              if (snapshot.hasData) {
                final docs = snapshot.data!.docs;
                return ListView.separated(
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final data = docs[i].data();
                    return ComplaintCard(
                      label: data['name'],
                      onTap: () {
                        Get.to(ViewComplaintScreen(
                          data: data,
                        ));
                      },
                    );
                  },
                  separatorBuilder: (context, index) => SizeConstant.getHeightSpace(16),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        )));
  }
}
