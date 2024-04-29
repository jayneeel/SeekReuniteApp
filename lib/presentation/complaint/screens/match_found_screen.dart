import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seek_reunite/constants/constant_fonts.dart';
import 'package:seek_reunite/constants/constant_size.dart';
import 'package:seek_reunite/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class MatchFoundScreen extends StatelessWidget {
  const MatchFoundScreen({super.key, required this.data});
  final Map<String, dynamic>? data;

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd/ MM/ yy').format(data!['lostSince'].toDate());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF38B338),
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: const Text(
          "Person Identified",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(children: [
        Container(
          height: 250.0,
          decoration: BoxDecoration(
            color: const Color(0xFF38B338),
            borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(MediaQuery.of(context).size.width, 200.0)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            "${data!['picture']}",
                            width: 300,
                            height: 200,
                          )),
                      Positioned(
                          bottom: 10,
                          right: 50,
                          child: Image.asset(
                            "assets/images/verified.png",
                            width: 100,
                            height: 30,
                          ))
                    ],
                  ),
                  SizeConstant.getHeightSpace(20),
                  const Text(
                    "Ref Id:",
                    style: TextStyle(fontFamily: ConstantFonts.poppinsBold, color: Color(0xFF0d0d0d), fontSize: 18),
                  ),
                  Text("${data!['referenceId']}"),
                  SizeConstant.getHeightSpace(20),
                  const Text(
                    "Name:",
                    style: TextStyle(fontFamily: ConstantFonts.poppinsBold, color: Color(0xFF0d0d0d), fontSize: 18),
                  ),
                  Text("${data!['name']}"),
                  SizeConstant.getHeightSpace(20),
                  const Text(
                    "Lost Since",
                    style: TextStyle(fontFamily: ConstantFonts.poppinsBold, color: Color(0xFF0d0d0d), fontSize: 18),
                  ),
                  Text(formattedDate),
                  SizeConstant.getHeightSpace(20),
                  const Text(
                    "Address",
                    style: TextStyle(fontFamily: ConstantFonts.poppinsBold, color: Color(0xFF0d0d0d), fontSize: 18),
                  ),
                  Text("${data!['address']}"),
                  SizeConstant.getHeightSpace(60),
                  const CustomButton(
                    text: "Nearby Police Station",
                    suffixIcon: Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                    ),
                    color: Colors.brown,
                  ),
                  SizeConstant.getHeightSpace(10),
                  CustomButton(
                    onTap: (){
                      _makePhoneCall(data!['contact'] ?? "");
                    },
                    text: "Contact Family",
                    suffixIcon: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                    ),
                    color: Colors.green,
                  )
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber)async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
