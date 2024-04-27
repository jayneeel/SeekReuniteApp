import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seek_reunite/constants/constant_fonts.dart';
import 'package:seek_reunite/constants/constant_size.dart';
import 'package:seek_reunite/constants/contant_colors.dart';
import 'package:seek_reunite/presentation/complaint/controller/complaint_controller.dart';
import 'package:seek_reunite/widgets/custom_button.dart';

class ViewComplaintScreen extends StatelessWidget {
  const ViewComplaintScreen({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Complaint'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: ConstantColors.whiteColor,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFBCBCBC))),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: CachedNetworkImage(
                            imageUrl: data['picture'],
                            width: 200,
                            height: 250,
                            placeholder: (context, url) => const CircularProgressIndicator(
                              strokeAlign: BorderSide.strokeAlignInside,
                            ),
                          )),
                      SizeConstant.getHeightSpace(10),
                      Text(
                        data['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: ConstantFonts.poppinsMedium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizeConstant.getHeightSpace(10),
                      Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            color: const Color(0xFFF7FDE8),
                            border: Border.all(color: const Color(0xFFDFFD94)),
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset("assets/images/demographics.png", width: 30, height: 30),
                                const Text("  Demographics",
                                    style:
                                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1D1E20))),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Age",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF121515)),
                            ),
                            Text(
                              "${data['age']}",
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF070606)),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Gender",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF121515)),
                            ),
                            const Text(
                              "Male",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF070606)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: const Color(0xFFEFF3FD),
                        border: Border.all(color: const Color(0xFFD5E1FD)),
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset("assets/images/description.png", width: 30, height: 30),
                            const Text(
                              "  Description",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1D1E20)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${data['description']}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6F6F6F),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: const Color(0xFFFDF3F3),
                        border: Border.all(color: const Color(0xFFE2B3B3)),
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset("assets/images/address.png", width: 30, height: 30),
                            const Text(
                              "  Complete Address",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF1D1E20),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data['address'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6F6F6F),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Get.dialog(
                        Dialog(
                          backgroundColor: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.network(data['fir_complaint']),
                            ],
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'View FIR',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationStyle: TextDecorationStyle.dashed,
                      ),
                    ),
                  ),
                  CustomButton(
                    text: "Close Complaint",
                    color: const Color(0xFF531342),
                    onTap: () => closeComplaintBottomSheet(context, data['referenceId']),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> closeComplaintBottomSheet(BuildContext context, String refID) async {
  final ComplaintController controller = Get.put(ComplaintController());
  await showModalBottomSheet(
    context: context,
    builder: (BuildContext context) => Container(
      decoration: const BoxDecoration(
        color: Color(0xffFFEBEB),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Image.asset(
                "assets/images/cancel_complaint.png",
                height: 104,
                width: 104,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const Center(
              child: Text(
                "Are You Sure to Close Your Complaint?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff121515),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            const Text(
              "Why want you want to close the complaint?",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xff0e0e0e),
              ),
            ),
            const SizedBox(height: 24),
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: DropdownButton<String>(
                  value: controller.selectedValue.value,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.selectedValue.value = newValue;
                    }
                  },
                  items: controller.dropdownItems.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 26),
            CustomButton(
              text: "Yes, Close Complaint",
              onTap: () {
                controller.closeComplaint(refID);
              },
              color: Colors.white,
              borderColor: ConstantColors.lightGreyColor,
              textStyle: const TextStyle(
                fontSize: 14,
                color: ConstantColors.primaryColor,
                fontWeight: FontWeight.w500,
                fontFamily: ConstantFonts.poppinsMedium,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    ),
  );
}
