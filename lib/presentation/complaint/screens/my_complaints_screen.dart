import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seek_reunite/presentation/complaint/screens/view_complaint_screen.dart';
import 'package:seek_reunite/presentation/complaint/widgets/complaint_card.dart';
import '../../../constants/constant_size.dart';


class MyComplaintsScreen extends StatefulWidget {
  @override
  _MyComplaintsScreenState createState() => _MyComplaintsScreenState();
}

class _MyComplaintsScreenState extends State<MyComplaintsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Missing Complaints'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Active Cases'),
            Tab(text: 'Closed Cases'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ActiveCasesTab(uid: auth.currentUser!.uid),
          ClosedCasesTab(uid: auth.currentUser!.uid),
        ],
      ),
    );
  }
}

class ActiveCasesTab extends StatelessWidget {
  final String uid;

  const ActiveCasesTab({required this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('complaints')
          .where('lodgedBy', isEqualTo: uid)
          .where('status', isEqualTo: 'active')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final activeCases = snapshot.data!.docs.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Total Active Cases: $activeCases'),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data!.docs[index].data();
                  return ComplaintCard(
                    name: data['name'],
                    description: data['description'],
                    onTap: () {
                      // Navigate to ViewComplaintScreen and pass the complaint's data
                      Get.to(ViewComplaintScreen(data: data));
                    },
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 16),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ClosedCasesTab extends StatelessWidget {
  final String uid;

  const ClosedCasesTab({required this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('complaints')
          .where('lodgedBy', isEqualTo: uid)
          .where('status', isEqualTo: 'closed')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final closedCases = snapshot.data!.docs.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Total Closed Cases: $closedCases'),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final data = snapshot.data!.docs[index].data();
                  return ComplaintCard(
                    name: data['name'],
                    description: data['description'],
                    onTap: () {
                      // Navigate to ViewComplaintScreen and pass the complaint's data
                      Get.to(ViewComplaintScreen(data: data));
                    },
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 16),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ComplaintCard extends StatelessWidget {
  final String name;
  final String description;
  final VoidCallback onTap;

  const ComplaintCard({
    required this.name,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text(description),
        onTap: onTap,
      ),
    );
  }
}

