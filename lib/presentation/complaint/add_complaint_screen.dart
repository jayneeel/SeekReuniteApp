import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:seek_reunite/presentation/complaint/controller/complaint_controller.dart';
import 'package:seek_reunite/widgets/custom_button.dart';

import '../../constants/constant_fonts.dart';
import '../../constants/constant_size.dart';
import '../../constants/contant_colors.dart';
import '../../utils/helpers.dart';

class AddComplaintScreen extends StatefulWidget {
  const AddComplaintScreen({super.key});

  @override
  State<AddComplaintScreen> createState() => _AddComplaintScreenState();
}

class _AddComplaintScreenState extends State<AddComplaintScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController lostSinceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final List<File> pictures = List<File>.empty(growable: true);
  ComplaintController controller = Get.put(ComplaintController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizeConstant.getHeightSpace(30),
              Image.asset("assets/images/complaint.png", width: 54, height: 54),
              SizeConstant.getHeightSpace(20),
              const Text(
                "Add your Complaint",
                style: TextStyle(fontFamily: ConstantFonts.poppinsMedium, color: Color(0xFF181818), fontSize: 25),
              ),
              SizeConstant.getHeightSpace(2),
              const Text(
                "Please fill the details of lost/missing/abscond.",
                style: TextStyle(fontFamily: ConstantFonts.poppinsMedium, color: Color(0xff9a9a9a), fontSize: 12),
              ),
              SizeConstant.getHeightSpace(18),
              TextField(
                maxLines: 1,
                controller: nameController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(12),
                  filled: true,
                  fillColor: ConstantColors.whiteColor,
                  labelText: "Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    fontFamily: ConstantFonts.poppinsRegular,
                    color: Color(0xFFA1A1A1),
                  ),
                ),
              ),
              SizeConstant.getHeightSpace(8),
              TextField(
                maxLines: 1,
                controller: ageController,
                keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                maxLength: 2,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  counterText: "",
                  contentPadding: const EdgeInsets.all(12),
                  filled: true,
                  fillColor: ConstantColors.whiteColor,
                  labelText: "Age",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    fontFamily: ConstantFonts.poppinsRegular,
                    color: Color(0xFFA1A1A1),
                  ),
                ),
              ),
              SizeConstant.getHeightSpace(8),
              TextField(
                onTap: () async {
                  DateTime? pickedDate = await Helpers.selectDate(
                    context,
                    // initialDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1),
                    // firstDate: DateTime(DateTime.now().year - 100),
                    // lastDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1),
                  );
                  if (pickedDate != null) {
                    lostSinceController.text = Helpers.formatDate(pickedDate.toString(), format: "dd/MM/yyyy");
                  }
                },
                maxLines: 1,
                controller: lostSinceController,
                decoration: InputDecoration(
                  counterText: "",
                  contentPadding: const EdgeInsets.all(12),
                  filled: true,
                  fillColor: ConstantColors.whiteColor,
                  labelText: "Lost Since",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    fontFamily: ConstantFonts.poppinsRegular,
                    color: Color(0xFFA1A1A1),
                  ),
                ),
              ),
              SizeConstant.getHeightSpace(8),
              TextField(
                controller: cityController,
                maxLines: 1,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(12),
                  filled: true,
                  fillColor: ConstantColors.whiteColor,
                  labelText: "City",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    fontFamily: ConstantFonts.poppinsRegular,
                    color: Color(0xFFA1A1A1),
                  ),
                ),
              ),
              SizeConstant.getHeightSpace(8),
              TextField(
                controller: addressController,
                maxLines: 3,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(12),
                  filled: true,
                  fillColor: ConstantColors.whiteColor,
                  labelText: "Complete Address",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    fontFamily: ConstantFonts.poppinsRegular,
                    color: Color(0xFFA1A1A1),
                  ),
                ),
              ),
              SizeConstant.getHeightSpace(8),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(12),
                  filled: true,
                  fillColor: ConstantColors.whiteColor,
                  labelText: "Description",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    fontFamily: ConstantFonts.poppinsRegular,
                    color: Color(0xFFA1A1A1),
                  ),
                ),
              ),
              SizeConstant.getHeightSpace(12),
              const Spacer(),
              CustomButton(text: "Lodge Complaint", onTap: (){
                controller.lodgeComplaint(nameController.text, addressController.text, descriptionController.text, DateTime(DateTime.march), int.parse(ageController.text));
              },),
              SizeConstant.getHeightSpace(12),
            ],
          ),
        ),
      ),
    );
  }
}