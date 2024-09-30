import '../../exports.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;
  final double width;
  final bool isloading;
  final Color color;
  final FontWeight fontWeight;
  final Color bgColor;
  final double radius;
  const CustomButton({
    super.key,
    required this.text,
    required this.callback,
    this.color = Colors.black,
    this.bgColor = Colors.white,
    this.isloading = false,
    this.radius = 12,
    this.fontWeight = FontWeight.w500,
    this.width = 360,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: callback,
        child: Ink(
          width: width.w,
          height: 50.h,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(radius.r),
          ),
          child: Center(
            child: isloading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: fontWeight,
                      color: color,
                      fontSize: 18.sp,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
