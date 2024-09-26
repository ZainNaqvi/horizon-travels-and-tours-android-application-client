import '../../../exports.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;
  final double width;

  const CustomButton({
    super.key,
    required this.text,
    required this.callback,
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.calistoga(
              textStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black,
                fontSize: 22.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
