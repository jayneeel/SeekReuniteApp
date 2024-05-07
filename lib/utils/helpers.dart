import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

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

  static Future<List<XFile>> pickImageFromGallery() async {
    final picker = ImagePicker();

    return await picker.pickMultiImage(requestFullMetadata: true);
  }

  static Future<XFile?> capturePhoto() async {
    final picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.camera);
  }

  String generatePasswordHash(String password) {
    var bytes = utf8.encode(password); // Convert the password to bytes
    var digest = sha256.convert(bytes); // Compute the SHA-256 hash
    return digest.toString(); // Convert the hash to a string
  }
}

