
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:live_indicator/live_indicator.dart';
import 'package:seek_reunite/constants/constant_fonts.dart';
import 'package:seek_reunite/constants/constant_size.dart';
import 'package:seek_reunite/constants/contant_colors.dart';
import 'package:seek_reunite/presentation/complaint/screens/add_complaint_screen.dart';
import 'package:seek_reunite/presentation/complaint/screens/view_complaint_screen.dart';
import 'package:seek_reunite/presentation/home/widgets/bottom_nav.dart';
import 'package:seek_reunite/presentation/home/widgets/side_drawer.dart';

import '../controllers/home_controllers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

const double _borderRadius = 24;

class CustomCardShapePainter extends CustomPainter {
  final double radius;

  CustomCardShapePainter(this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(const Offset(0, 0), Offset(size.width, size.height),
        [HSLColor.fromColor(const Color(0xFFF3EB97)).withLightness(0.8).toColor(), ConstantColors.pastelBlueLight]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);

    var firstStart = Offset(size.width / 5, size.height);

    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);

    path.quadraticBezierTo(firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset(size.width - (size.width / 3.24), size.height - 105);

    var secondEnd = Offset(size.width, size.height - 10);

    path.quadraticBezierTo(secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());
  var nameList = [
    "Amogh",
    "Aditya",
    "Jayneel",
    "Amol",
    "Anurag",
    "Vikas",
    "Deepinder",
  ];
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStatsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const SideNavDrawer(),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        isExtended: true,
        onPressed: () {
          Get.to(() => const AddComplaintScreen());
        },
        tooltip: "Complaint",
        child: const Icon(Icons.receipt_rounded),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD4E0FD),
        title: const Text(
          "Welcome",
          style: TextStyle(color: Colors.black),
        ),
        leading: Builder(builder: (context) {
          return GestureDetector(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
          );
        }),
      ),
      body: Stack(children: [
        ClipPath(
          clipper: CustomClipPath(),
          child: Container(
            height: 220,
            color: const Color(0xFFD4E0FD),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildStatistics(),
                SizeConstant.getHeightSpace(35),
                const Text(
                  "Recent Complaints",
                  style: TextStyle(fontSize: 20, fontFamily: ConstantFonts.poppinsBold),
                ),
                SizeConstant.getHeightSpace(15),
                buildRecentComplaints(),
                SizeConstant.getHeightSpace(50),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Container buildStatistics() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FD),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD5E1FD)),
      ),
      child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Today's Statistics",
                          style: TextStyle(
                              fontSize: 18, color: ConstantColors.blackColor, fontFamily: ConstantFonts.poppinsBold),
                        ),
                        SizeConstant.getWidthSpace(6),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ConstantColors.whiteColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                LiveIndicator(
                                    color: Colors.red.shade700,
                                    radius: 2.5,
                                    spreadRadius: 5,
                                    spreadDuration: const Duration(seconds: 1),
                                    waitDuration: const Duration(seconds: 1)),
                                const Text(
                                  "LIVE",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: ConstantFonts.poppinsBold,
                                      color: ConstantColors.lightGreyColor),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.isExpanded.value = !controller.isExpanded.value;
                      },
                      child: Icon(
                        (controller.isExpanded.value)
                            ? Icons.keyboard_arrow_up_outlined
                            : Icons.keyboard_arrow_down_rounded,
                        color: ConstantColors.lightGreyColor,
                        size: 25,
                      ),
                    )
                  ],
                ),
              ),
              SizeConstant.getHeightSpace(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        child: Container(
                            padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                            child: Image.asset(
                              "assets/images/kid.png",
                              width: 90,
                              height: 90,
                            )),
                        onTap: () {},
                      ),
                      const Text("Kids"),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        child: Container(
                            padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                            child: Image.asset(
                              "assets/images/adult.png",
                              width: 90,
                              height: 90,
                            )),
                        onTap: () {},
                      ),
                      const Text("Adults"),
                    ],
                  ),
                ],
              ),
              if (controller.isExpanded.value) ...[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/statistics2.png",
                              width: 100,
                              height: 100,
                            ),
                            const Text("Lost People Count: 54"),
                          ],
                        )
                      ],
                    )
                  ],
                )
              ]
            ],
          )),
    );
  }

  Future<void> getStatsData() async {
    controller.lostPeopleCount.value = await db.collection("complaints").snapshots().length;
  }

  buildRecentComplaints() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('complaints').where('active', isEqualTo: true).snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasError) return Text('Error = ${snapshot.error}');
          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            return ListView.separated(
              shrinkWrap: true,
              itemCount: docs.length,
              itemBuilder: (_, i) {
                final data = docs[i].data();
                String formattedDate = DateFormat('dd/ MM/ yy').format(data['lostSince'].toDate());
                return RecentComplaintCard(
                  name: data['name'],
                  picture: data['picture'],
                  lostSince: formattedDate,
                  reward: data['reward'].toString(),
                  city: data['city'], data: data,
                );
              },
              separatorBuilder: (context, index) => SizeConstant.getHeightSpace(16),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class RecentComplaintCard extends StatelessWidget {
  const RecentComplaintCard({
    super.key,
    required this.name,
    required this.reward,
    required this.city,
    required this.lostSince,
    required this.picture, required this.data,
  });
  final Map<String, dynamic> data;
  final String name;
  final String reward;
  final String city;
  final String lostSince;
  final String picture;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(ViewComplaintScreen(data: data, owned: false,));
      },
      child: Stack(
        children: <Widget>[
          Container(
            width: double.maxFinite,
            height: 120,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD4E0FD)),
                borderRadius: BorderRadius.circular(_borderRadius),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    offset: Offset(0, 2),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
                color: const Color(0xFFEDFDEB)),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: CustomPaint(
              size: const Size(100, 150),
              painter: CustomCardShapePainter(_borderRadius),
            ),
          ),
          Positioned.fill(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Image.network(
                    picture,
                    width: 100,
                    height: 100,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: ConstantFonts.poppinsMedium,
                            fontWeight: FontWeight.bold),
                      ),
                      SizeConstant.getHeightSpace(5),
                      Text(
                        "Lost Since : $lostSince",
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.location_on,
                            color: Colors.black,
                            size: 16,
                          ),
                          SizeConstant.getWidthSpace(2),
                          Flexible(
                            child: Text(
                              city,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "₹ $reward",
                        style: const TextStyle(color: Color(0xFF07B963), fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
