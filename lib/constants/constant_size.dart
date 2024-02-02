import "package:flutter/material.dart";

class SizeConstant {
  static final SizeConstant _singleton = SizeConstant._internal();

  factory SizeConstant() => _singleton;

  SizeConstant._internal();

  static Widget getHeightSpace(double height) => SizedBox(
    height: height,
    width: 0,
  );

  static Widget getWidthSpace(double width) => SizedBox(
    width: width,
    height: 0,
  );
}
