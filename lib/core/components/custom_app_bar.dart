import '../../../exports.dart'; // Assuming necessary imports here.

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? leadingCallback;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final VoidCallback? trailingCallback;
  final TextStyle? titleStyle;

  const CustomAppBar({
    super.key,
    this.title = '',
    this.leadingCallback,
    this.leadingIcon,
    this.trailingIcon,
    this.trailingCallback,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(360.w, 200.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leadingIcon != null)
              buildBackButton(
                () {
                  Navigator.pop(context);
                },
                color: AppColor.appGrey.withOpacity(0.2),
                topMargin: 32,
                iconData: Icons.arrow_back,
              )
            else
              SizedBox(width: 48.w),
            Padding(
              padding: EdgeInsets.only(top: 32.0.h),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: titleStyle ??
                    GoogleFonts.calistoga(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColor.textColor,
                        fontSize: 32.sp,
                      ),
                    ),
              ),
            ),
            if (trailingIcon != null)
              buildBackButton(
                trailingCallback ?? () {},
                iconData: trailingIcon!,
                iconColor: Colors.black,
                color: AppColor.appGrey.withOpacity(0.2),
                topMargin: 32,
              )
            else
              SizedBox(width: 48.w),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(200.h);
}
