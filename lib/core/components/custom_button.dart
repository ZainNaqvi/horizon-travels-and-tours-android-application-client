import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horizon_travel_and_tours_android_application/core/theme/colors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final bool isUrduText;
  final Widget? widget;
  final bool isShowdow;
  final bool isBtnDisabled;
  final double fontSize;
  final Color backgrounColor;
  final bool isPdf;

  const CustomButton({
    required this.onPressed,
    required this.buttonText,
    this.isUrduText = false,
    this.isPdf = false,
    this.widget,
    this.fontSize = 16,
    this.isShowdow = true,
    this.backgrounColor = AppColor.authButton,
    this.isBtnDisabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42.h,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: 0.1,
            offset: const Offset(0, 1),
            spreadRadius: 1,
          ),
        ],
        color: Colors.amber,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ElevatedButton(
        onPressed: isBtnDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgrounColor,
          minimumSize: Size(382.w, 48.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.zero,
          elevation: 0.0,
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            alignment: Alignment.center,
            child: widget ??
                Text(
                  buttonText.toUpperCase(),
                  style: TextStyle(
                    fontSize: fontSize.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
