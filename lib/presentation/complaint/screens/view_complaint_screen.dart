import 'package:flutter/material.dart';
import 'package:seek_reunite/constants/constant_fonts.dart';

class ViewComplaintScreen extends StatelessWidget {
  const ViewComplaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset("assets/images/person.png", width: 50, height: 90,),

                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Dr. Amol Pande", style: TextStyle(fontSize: 20, fontFamily: ConstantFonts.poppinsMedium),),
                    ],
                  )
                ],
              ),
              const Text("About", style: TextStyle(fontFamily: ConstantFonts.poppinsMedium, fontSize: 20, ),),
              const Text("")
            ],
          ),
        ),
      ),
    );
  }
}
