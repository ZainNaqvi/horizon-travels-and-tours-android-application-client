import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CutomInputField extends StatelessWidget {
  final String? hintText;
  final String hint;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final int? maxLine;
  final Icon? icon;
  final Widget? suffixIcon;
  final VoidCallback? onTapSuffixIcon;
  final TextEditingController? controller;
  final AutovalidateMode autoValidateMode;
  final FocusNode? focusNode;
  final bool isObscure;

  const CutomInputField({
    super.key,
    this.hintText,
    this.onChanged,
    this.validator,
    this.maxLine,
    this.controller,
    this.icon,
    this.suffixIcon,
    this.onTapSuffixIcon,
    this.focusNode,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.isObscure = false,
    required this.hint,
  });

  OutlineInputBorder customOutlineInputBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(8.0),
        bottomRight: Radius.circular(8.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 100.w,
            height: 56.h,
            decoration: const BoxDecoration(
              color: Color(0xffEEF0F2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              ),
            ),
            child: Text(
              hint,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xff495A68),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              focusNode: focusNode,
              controller: controller,
              textInputAction: TextInputAction.done,
              autovalidateMode: autoValidateMode,
              cursorColor: Colors.grey,
              maxLines: maxLine ?? 1,
              obscureText: isObscure,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: icon,
                hintStyle: TextStyle(fontSize: 14.sp),
                hintText: hintText,
                suffixIcon: suffixIcon != null
                    ? GestureDetector(
                        onTap: onTapSuffixIcon,
                        child: suffixIcon,
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                focusedBorder: customOutlineInputBorder(),
                enabledBorder: customOutlineInputBorder(),
                border: customOutlineInputBorder(),
              ),
              onChanged: onChanged,
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }
}
