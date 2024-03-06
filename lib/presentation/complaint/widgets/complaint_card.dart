import 'package:flutter/material.dart';

import '../../../constants/constant_fonts.dart';

class ComplaintCard extends StatelessWidget {
  const ComplaintCard({super.key, required this.label});
  final String label;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(color: const Color(0xFFEEEEEE))),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: ConstantFonts.poppinsMedium,
              fontWeight: FontWeight.w500,
              color: Color(0xff373737),
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.keyboard_arrow_right_rounded,
            size: 16,
            color: Color(0xFF868686),
          ),
        ],
      ),
    );
  }
}
