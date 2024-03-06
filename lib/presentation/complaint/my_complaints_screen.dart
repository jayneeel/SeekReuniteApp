import 'package:flutter/material.dart';
import 'package:seek_reunite/presentation/complaint/widgets/complaint_card.dart';

import '../../constants/constant_size.dart';

class MyComplaintsScreen extends StatelessWidget {
  const MyComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: 10,
          separatorBuilder: (context, index) => SizeConstant.getHeightSpace(16), itemBuilder: (BuildContext context, int index) { return ComplaintCard(label: "23423"); },

        ),
      )
    );
  }
}
