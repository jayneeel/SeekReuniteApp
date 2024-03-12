import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_indicator/live_indicator.dart';
import 'package:seek_reunite/constants/constant_fonts.dart';
import 'package:seek_reunite/constants/constant_size.dart';
import 'package:seek_reunite/constants/contant_colors.dart';
import 'package:seek_reunite/presentation/complaint/screens/add_complaint_screen.dart';
import 'package:seek_reunite/presentation/home/widgets/bottom_nav.dart';
import 'package:seek_reunite/presentation/home/widgets/side_drawer.dart';

import '../controllers/home_controllers.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());
  var nameList = [ "Amogh", "Aditya", "Jayneel", "Amol", "Anurag", "Vikas", "Deepinder",];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideNavDrawer(),
      bottomNavigationBar: const BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        isExtended: true, onPressed: () {
          Get.to(const AddComplaintScreen());
      },
        tooltip: "Complaint",
        child: const Icon(Icons.receipt_rounded),
      ),
      appBar: AppBar(
        title: const Text("Welcome"),
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: (){
                Scaffold.of(context).openDrawer();
              },
              child: const Icon(
                Icons.menu,
              ),
            );
          }
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildStatistics(),
              SizeConstant.getHeightSpace(20),
              const Text(
                "Recent Complaints",
                style: TextStyle(fontSize: 20, fontFamily: ConstantFonts.poppinsBold),
              ),
              SizeConstant.getHeightSpace(20),
              ListView.separated(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,itemBuilder: (context, index){

                return ListTile(
                  leading: Image.asset("assets/images/kid.png",width: 30,
                    height: 30,),
                  title: Text(nameList[index], style: const TextStyle(fontFamily: ConstantFonts.poppinsBold, fontSize: 16, color: ConstantColors.blackColor),),
                  subtitle: const Text("Bhatinda", style: TextStyle(fontFamily: ConstantFonts.poppinsRegular, fontSize: 14, color: ConstantColors.lightGreyColor),),
                );
              }, separatorBuilder: (context, index) => const Divider(), itemCount: nameList.length)
            ],
          ),
        ),
      ),
    );
  }

  Container buildStatistics() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ConstantColors.lightGreyColor),
      ),
      child: Obx(()=> Column(
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
                      style:
                      TextStyle(fontSize: 18, color: ConstantColors.blackColor, fontFamily: ConstantFonts.poppinsBold),
                    ),
                    SizeConstant.getWidthSpace(6),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ConstantColors.whiteColor,
                      ),
                      child: Row(
                        children: [
                          LiveIndicator(color: Colors.red.shade700,
                              radius: 2.5,
                              spreadRadius: 5,
                              spreadDuration: const Duration(seconds: 1),
                              waitDuration: const Duration(seconds: 1)),
                          const Text("LIVE", style: TextStyle(fontSize: 14, fontFamily: ConstantFonts.poppinsBold, color: ConstantColors.lightGreyColor),)
                        ],
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: (){
                    controller.isExpanded.value = !controller.isExpanded.value;
                  },
                  child: Icon(
                    (controller.isExpanded.value) ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down_rounded,
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
                            color: const Color(0xFFFFF8F5),
                            border: Border.all(color: const Color(0xFFD7E3FF)),
                            borderRadius: BorderRadius.circular(10)),
                        child: Image.asset(
                          "assets/images/kid.png",
                          width: 60,
                          height: 60,
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
                            color: const Color(0xFFFFF8F5),
                            border: Border.all(color: const Color(0xFFD7E3FF)),
                            borderRadius: BorderRadius.circular(10)),
                        child: Image.asset(
                          "assets/images/adult.png",
                          width: 60,
                          height: 60,
                        )),
                    onTap: () {},
                  ),
                  const Text("Adults"),
                ],
              ),
            ],
          ),
          if (controller.isExpanded.value)...[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                      ],
                    )
                  ],
                )
              ],)
          ]
        ],
      )),
    );
  }
}
