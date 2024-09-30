import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String title;
  final Color titleColor;
  final double titleFontSize;
  final FontWeight fontWeight;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color cursorColor;
  final int maxLines;
  final double fontSize;
  final double? width;
  final bool obscureText;
  final String? Function(String?)? validator; // Added for validation

  const CustomField({
    super.key,
    this.controller,
    this.hintText,
    this.textInputAction,
    this.keyboardType,
    this.inputFormatters,
    this.borderRadius = 2,
    this.padding = const EdgeInsets.symmetric(horizontal: 14),
    this.cursorColor = Colors.blue,
    this.fontSize = 20,
    this.maxLines = 1,
    this.width,
    this.obscureText = false,
    required this.title,
    this.titleColor = Colors.black,
    this.titleFontSize = 20,
    this.fontWeight = FontWeight.w400,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: titleFontSize,
            fontWeight: fontWeight,
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: 360.w,
          child: TextFormField(
            cursorColor: cursorColor,
            controller: controller,
            textInputAction: textInputAction,
            keyboardType: keyboardType,
            obscureText: obscureText,
            maxLines: maxLines,
            inputFormatters: inputFormatters,
            style: TextStyle(
              color: Colors.black,
              fontSize: fontSize,
            ),
            decoration: InputDecoration(
              fillColor: Colors.blue.withOpacity(0.2),
              filled: true,
              enabledBorder: _outlineBorder(),
              focusedBorder: _outlineBorder(),
              border: _outlineBorder(),
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontSize: fontSize,
              ),
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _outlineBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.transparent),
    );
  }
}
