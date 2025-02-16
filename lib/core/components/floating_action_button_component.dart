import '../../exports.dart';

class FloatingActionButtonComponent extends StatelessWidget {
  final String btnText;
  final VoidCallback callback;

  const FloatingActionButtonComponent({
    super.key,
    required this.btnText,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 166.w,
      height: 34.h,
      child: FloatingActionButton(
        shape: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(50.r),
        ),
        onPressed: callback,
        backgroundColor: Color(0xff00B4D8),
        isExtended: true,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Icon(Icons.add, color: Colors.white,size: 18.sp,),
              SizedBox(width: 4.w),
              Text(
                btnText.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
