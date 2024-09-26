import '../../../exports.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;
  final double width;
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
    this.radius = 12,
    this.fontWeight = FontWeight.w400,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: callback,
        child: Ink(
          width: width,
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(radius.r),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.calistoga(
              textStyle: TextStyle(
                fontWeight: fontWeight,
                color: color,
                fontSize: 22.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
