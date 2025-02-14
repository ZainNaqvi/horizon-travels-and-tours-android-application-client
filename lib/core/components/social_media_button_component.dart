import '../../exports.dart';

class SocialMediaButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String buttonText;
  final String imagePath;
  final double imageSize;
  final double fontSize;
  final bool isBtnDisabled;
  final Color backgrounColor;
  final Widget? widget;
  const SocialMediaButton({
    required this.onPressed,
    required this.buttonText,
    required this.imagePath,
    this.widget,
    this.imageSize = 44.0,
    this.fontSize = 16.0,
    this.isBtnDisabled = false,
    this.backgrounColor = AppColor.white,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42.h,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
            spreadRadius: 1,
          ),
        ],
        borderRadius: BorderRadius.circular(54.0),
      ),
      child: ElevatedButton(
        onPressed: isBtnDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgrounColor,
          minimumSize: Size(382.w, 48.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(54.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          elevation: 2.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: imageSize.w,
              height: imageSize.h,
              fit: BoxFit.contain,
            ),
            if (widget != null)
              widget!
            else
              Text(
                buttonText,
                style: TextStyle(
                  fontSize: fontSize.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
