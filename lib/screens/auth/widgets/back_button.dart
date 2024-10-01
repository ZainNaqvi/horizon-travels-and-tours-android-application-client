import '../../../exports.dart';

Widget buildBackButton(
  VoidCallback callback, {
  Color color = Colors.white,
  double topMargin = 44,
  Color? iconColor,
  IconData iconData = Icons.arrow_back_ios,
}) {
  return GestureDetector(
    onTap: () => callback(),
    child: Container(
      margin: EdgeInsets.only(top: topMargin.h),
      width: 54.w,
      height: 44.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(iconData, color: iconColor ?? Colors.grey.shade600, size: 26.r),
    ),
  );
}
