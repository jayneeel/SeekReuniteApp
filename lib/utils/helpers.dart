

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  static Future<DateTime?> selectDate(BuildContext context,
      {DateTime? initialDate, DateTime? firstDate, DateTime? lastDate}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      builder: (BuildContext context, Widget? child) => Theme(
        data: ThemeData.light().copyWith(
          primaryColor: Color(0xff0A1A54),
          colorScheme:
          const ColorScheme.light(primary: Color(0xff60123F)),
          buttonTheme:
          const ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        child: child!,
      ),
      initialDate: initialDate ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      firstDate: firstDate ?? DateTime(1947),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    return pickedDate;
  }


  static String formatDate(
      String? date, {
        String format = "dd MMM, yyyy",
      }) =>
      DateFormat(format)
          .format((DateTime.tryParse(date ?? "") ?? DateTime.now()).toLocal());
}

