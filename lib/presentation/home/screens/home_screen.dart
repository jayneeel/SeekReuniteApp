import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:get/get.dart';
import 'package:live_indicator/live_indicator.dart';
import 'package:seek_reunite/constants/constant_fonts.dart';
import 'package:seek_reunite/constants/constant_size.dart';
import 'package:seek_reunite/constants/contant_colors.dart';
import 'package:seek_reunite/presentation/complaint/screens/add_complaint_screen.dart';
import 'package:seek_reunite/presentation/complaint/screens/match_found_screen.dart';
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
    paint.shader = ui.Gradient.linear(
        const Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(Color(0xFFF3EB97)).withLightness(0.8).toColor(),
      ConstantColors.pastelBlueLight
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
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

class CustomClipPath extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    var path = Path();
    path.lineTo(0, size.height);

    var firstStart = Offset(size.width / 5, size.height);

    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);

    path.quadraticBezierTo(firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart = Offset(size.width - (size.width / 3.24), size.height -105);

    var secondEnd = Offset(size.width, size.height -10);

    path.quadraticBezierTo(secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper){
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
        title: const Text("Welcome", style: TextStyle(color: Colors.black),),
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
        // ClipPath(
        //   clipper:CustomClipPath(),
        //   child: Container(
        //     height:280,
        //     color: Colors.purple[100],
        //   ),
        // ),
        //       ClipPath(
        //         clipper: CustomClipPath(),
        //         child: Container(
        //           height: 350,
        //           color: Colors.purple[200],
        //         ),
        //       ),

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
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildStatistics(),
                      SizeConstant.getHeightSpace(35),
                      const Text(
                        "Recent Complaints",
                        style: TextStyle(fontSize: 20, fontFamily: ConstantFonts.poppinsBold),
                      ),
                      SizeConstant.getHeightSpace(20),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 65),
                        child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return RecentComplaintCard(nameList: nameList);
                                                            },
                          separatorBuilder: (context, index) =>  SizeConstant.getHeightSpace(5),
                              itemCount: nameList.length),
                      ),
                      )
                  )
                    ],
                  ),
                ),
              ),
    ]
    ),
            );

  }

  Container buildStatistics() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
       border: Border.all(color: ConstantColors.lightGreyColor),
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
                          child: Container(

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black),

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
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
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
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Image.asset(
                              "assets/images/adult.png",
                              width: 90,
                              height: 90,
                            )),
                        onTap: () {
                        },
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
                            Image.asset("assets/images/statistics2.png", width: 100, height: 100,),
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
}

class RecentComplaintCard extends StatelessWidget {
  const RecentComplaintCard({
    super.key,
    required this.nameList,
  });

  final List<String> nameList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
       child: Stack(
         children: <Widget>[
           Container(
             height: 120,
             decoration: BoxDecoration(
               border: Border.all(color: const Color(0xFFD4E0FD)),
              borderRadius: BorderRadius.circular(_borderRadius),
              // gradient: const LinearGradient(colors: [
              //   Color(0xFFC7C7C7),
              //   Color(0xFF2F2D2D),
              //   // ConstantColors.pastelBlueLight
              //    ],
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight),
               color: const Color(0xFFF3EB97)
                 ),
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
                      child: Image.asset(
                         "assets/images/adult.png"
                           ),
                         ),
                        const Expanded(
                         flex: 4,
                          child: Column(
                             mainAxisSize: MainAxisSize.min,
                             crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                 Text(
                                   "Jayneel",
                                   style: TextStyle(
                                   color: Colors.black,
                                    fontSize: 19,
                                    fontFamily: ConstantFonts.poppinsMedium,
                                    fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Jayneel",
                                       style: TextStyle(
                                        color: Colors.black,
                                          ),
                                         ),
                                    SizedBox(height: 16),
                                       Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.location_on,
                                             color: Colors.black,
                                               size: 16,
                                              ),
                                            SizedBox(
                                              width: 8,
                                              ),
                                        Flexible(
                                          child: Text(
                                            "Jayneel",
                                            style: TextStyle(
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
                               const Expanded(
                                 flex: 2,
                                 child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                        Text(
                                          "10,000",
                                          style: TextStyle(
                                           color: Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700),
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
