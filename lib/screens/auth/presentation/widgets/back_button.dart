import '../../../../exports.dart';

Widget buildBackButton(
  VoidCallback callback, {
  Color color = Colors.white,
  Color? iconColor,
  IconData iconData = Icons.arrow_back_ios,
}) {
  return GestureDetector(
    onTap: () => callback(),
    child: Container(
      padding: EdgeInsets.only(left: 8.w),
      margin: EdgeInsets.only(top: 44.h),
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
