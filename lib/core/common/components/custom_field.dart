import '../../../exports.dart';

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
  final List<BoxShadow>? boxShadow;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color cursorColor;
  final int maxLines;
  final double fontSize;
  final double? width;
  final bool obscureText;
  const CustomField({
    super.key,
    this.controller,
    this.hintText,
    this.textInputAction,
    this.keyboardType,
    this.inputFormatters,
    this.borderRadius = 2,
    this.padding = const EdgeInsets.symmetric(horizontal: 14),
    this.boxShadow,
    this.textStyle,
    this.hintStyle,
    this.cursorColor = AppColor.blue,
    this.fontSize = 20,
    this.maxLines = 1,
    this.width,
    this.obscureText = false,
    required this.title,
    this.titleColor = Colors.white,
    this.titleFontSize = 18,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.caladea(
            textStyle: TextStyle(
              color: titleColor,
              fontSize: titleFontSize,
              fontWeight: fontWeight,
              letterSpacing: 2,
            ),
          ),
        ),
        Container(
          width: width ?? 0.75.sw,
          padding: padding,
          margin: EdgeInsets.only(top: 4.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: AppColor.white,
            boxShadow: boxShadow ??
                [
                  BoxShadow(
                    color: AppColor.grey.withOpacity(0.2),
                    blurRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
          ),
          child: TextField(
            controller: controller,
            textInputAction: textInputAction,
            keyboardType: keyboardType,
            obscureText: obscureText,
            maxLines: maxLines,
            inputFormatters: inputFormatters,
            style: textStyle ??
                TextStyle(
                  color: AppColor.black,
                  fontSize: fontSize,
                ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: hintStyle ??
                  TextStyle(
                    color: AppColor.appGrey,
                    fontSize: fontSize,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
