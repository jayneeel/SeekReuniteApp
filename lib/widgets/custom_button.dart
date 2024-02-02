import "package:flutter/material.dart";
import "package:seek_reunite/constants/contant_colors.dart";
import "../constants/constant_fonts.dart";

class CustomButton extends StatelessWidget {
  final String text;
  final String subTitle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Color color;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final bool isActive;
  final bool isLoading;
  final double borderRadius;
  final double? width;
  final bool autoResize;
  final bool isUppercase;

  const CustomButton({
    Key? key,
    required this.text,
    this.subTitle = "",
    this.prefixIcon,
    this.isLoading = false,
    this.suffixIcon,
    this.color =ConstantColors.primaryColor,
    this.isActive = true,
    this.borderColor,
    this.textStyle,
    this.padding,
    this.onTap,
    this.borderRadius = 8,
    this.width,
    this.autoResize = false,
    this.isUppercase = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(borderRadius),
    child: GestureDetector(
      onTap: isActive
          ? !isLoading
          ? onTap
          : () {}
          : () {},
      child: Container(
        width: autoResize ? null : width ?? double.infinity,
        decoration: BoxDecoration(
          color: isActive ? color : const Color(0xFF784328),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
              color: isActive ? (borderColor ?? Colors.transparent) : (borderColor ?? Colors.transparent)),
        ),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 10),
        child: isLoading
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: textStyle?.color ?? Colors.white,
              ),
            ),
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefixIcon != null) ...[
              prefixIcon ?? const SizedBox(height: 0,),
              const SizedBox(height: 10),
            ],
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      isUppercase ? text.toUpperCase() : text,
                      style: TextStyle(
                        color: textStyle?.color ?? const Color(0xFFFFFFFF),
                        fontSize: (textStyle?.fontSize ?? 16),
                        fontFamily: textStyle?.fontFamily ?? ConstantFonts.poppinsMedium,
                        decoration: textStyle?.decoration ?? TextDecoration.none,
                      ),
                    ),
                  ),
                  if ((subTitle).isNotEmpty)
                    Text(
                      subTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Color(
                          0xFF707070,
                        ),
                      ),
                    )
                ],
              ),
            ),
            if (suffixIcon != null) ...[
              const SizedBox(
                width: 10,
              ),
              suffixIcon ?? const SizedBox(),
            ]
          ],
        ),
      ),
    ),
  );
}
