import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:seek_reunite/constants/constant_fonts.dart';
import 'package:seek_reunite/constants/constant_size.dart';
import 'package:seek_reunite/constants/contant_colors.dart';
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
                          placeholder: (context, url) => const CircularProgressIndicator(strokeAlign: BorderSide.strokeAlignInside,),
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
                    SizeConstant.getHeightSpace(20),
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
                              Image.asset("assets/images/demographics.png",width: 30, height: 30),
                              const Text("  Demographics",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1D1E20))),
                            ],
                          ),
                          const SizedBox(width: 10),
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
                      const SizedBox(width: 10),
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
                      const SizedBox(width: 10),
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
                const Spacer(),
                CustomButton(
                  text: "Close Complaint",
                  color: const Color(0xFF531342),
                  onTap: () => closeComplaintBottomSheet(context),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> closeComplaintBottomSheet(BuildContext context) async {
  await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [const Text("Found?"), Switch(value: true, onChanged: (v) {})],
            ),
          ));
}
