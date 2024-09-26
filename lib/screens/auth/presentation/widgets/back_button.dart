import '../../../../exports.dart';

Widget buildBackButton(VoidCallback callback) {
  return GestureDetector(
    onTap: () => callback(),
    child: Container(
      padding: EdgeInsets.only(left: 8.w),
      margin: EdgeInsets.only(top: 44.h),
      width: 54.w,
      height: 44.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(Icons.arrow_back_ios, color: Colors.grey.shade600, size: 26.r),
    ),
  );
}
