import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seek_reunite/presentation/complaint/controller/complaint_controller.dart';
import 'package:seek_reunite/widgets/custom_button.dart';

import '../../../constants/constant_fonts.dart';
import '../../../constants/constant_size.dart';
import '../../../constants/contant_colors.dart';
import '../../../utils/helpers.dart';
import '../widgets/picture_item.dart';

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
        padding: const EdgeInsets.all(20),
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
              if (pictures.isEmpty)
                addPicture()
              else
                SizedBox(
                  height: 84,
                  child: ListView.builder(
                    itemCount: pictures.length + 1,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if (index < pictures.length) {
                        final p = pictures[index];
                        return PictureItem(
                            file: p,
                            onCancelled: () {
                              setState(() {
                                pictures.removeAt(index);
                              });
                            });
                      } else {
                        if (pictures.length < 4) {
                          return addPicture();
                        } else {
                          SizeConstant.getHeightSpace(0);
                        }
                      }
                      return SizeConstant.getHeightSpace(0);
                    },
                  ),
                ),
              const Spacer(),
              CustomButton(text: "Lodge Complaint", onTap: (){
                controller.lodgeComplaint(nameController.text, addressController.text, descriptionController.text, DateTime(DateTime.march), int.parse(ageController.text));
              },),
            ],
          ),
        ),
      ),
    );
  }

  Widget addPicture() => InkWell(
    onTap: () async {
      final res = await openBottomSheet("image", context);

      if ((res ?? []).isEmpty) return;

      for (final element in res) {
        setState(() {
          pictures.add(File(element.path));
        });
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ConstantColors.whiteColor,
        border: Border.all(color: ConstantColors.primaryColor),
      ),
      alignment: Alignment.center,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.camera_alt),
          Text("  Upload Photos"),
        ],
      )
    ),
  );

  Future<List<XFile>> openBottomSheet(String type, BuildContext context) async {
    final res = await showModalBottomSheet(
      enableDrag: false,
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) => Container(
        width: double.maxFinite,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizeConstant.getHeightSpace(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () async {
                    final List<XFile> t = [];
                    if (type == "image") {
                      t.addAll((await Helpers.pickImageFromGallery()).toList());
                    }
                    if (context.mounted) {
                      Navigator.pop(context, t);
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey)),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.browse_gallery_rounded,
                          size: 24,
                        ),
                      ),
                      SizeConstant.getHeightSpace(10),
                      const Text("From Gallery"),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final List<XFile> t1 = [];
                    if (type == "image") {
                      final t = await Helpers.capturePhoto();
                      if (t != null) {
                        t1.add(t);
                      }
                    }
                    if (context.mounted) {
                      Navigator.pop(context, t1);
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey)),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 24,
                        ),
                      ),
                      SizeConstant.getHeightSpace(10),
                      const Text("From Camera"),
                    ],
                  ),
                ),
              ],
            ),
            SizeConstant.getHeightSpace(40),
          ],
        ),
      ),
    );
    return res ?? [];
  }
}