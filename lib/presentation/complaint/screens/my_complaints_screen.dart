import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seek_reunite/presentation/complaint/screens/view_complaint_screen.dart';
import 'package:seek_reunite/presentation/complaint/widgets/complaint_card.dart';
import '../../../constants/constant_size.dart';

class MyComplaintsScreen extends StatelessWidget {
  const MyComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('complaints').snapshots(),
            builder: (_, snapshot) {
              if (snapshot.hasError) return Text('Error = ${snapshot.error}');

              if (snapshot.hasData) {
                final docs = snapshot.data!.docs;
                return ListView.separated(
                  itemCount: docs.length,
                  itemBuilder: (_, i) {
                    final data = docs[i].data();
                    return ComplaintCard(label: data['name'], onTap: (){
                      Get.to(const ViewComplaintScreen());
                    },);
                  }, separatorBuilder: (context, index) => SizeConstant.getHeightSpace(16),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        )
      )
    );
  }
}
