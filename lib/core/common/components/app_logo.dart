import '../../../exports.dart';

class AppLogo extends StatelessWidget {
  final double width;
  final double height;
  final double titleFontSize;
  final double subTitleFontSize;
  const AppLogo({
    super.key,
    this.width = 164,
    this.height = 84,
    this.subTitleFontSize = 16,
    this.titleFontSize = 30,
  });

  static final TextStyle _horizonTextStyle = GoogleFonts.calistoga(
    textStyle: const TextStyle(
      color: Colors.white,
      letterSpacing: 5.5,
      fontWeight: FontWeight.w600,
    ),
  );

  static final TextStyle _subTitleTextStyle = GoogleFonts.lato(
    textStyle: const TextStyle(
      color: Colors.amber,
      letterSpacing: 5.5,
      fontWeight: FontWeight.w500,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AppAsset.icon,
          height: height,
          width: width,
          fit: BoxFit.fitWidth,
        ),
        SizedBox(height: 6.h),
        Text(
          'Horizon'.toUpperCase(),
          style: _horizonTextStyle.copyWith(fontSize: titleFontSize),
        ),
        SizedBox(height: 6.h),
        Text(
          'Travel And Tours'.toUpperCase(),
          style: _subTitleTextStyle.copyWith(fontSize: subTitleFontSize),
        ),
      ],
    );
  }
}
