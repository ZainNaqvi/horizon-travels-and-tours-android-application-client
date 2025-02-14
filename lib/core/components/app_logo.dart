import '../../exports.dart';

class AppLogo extends StatelessWidget {
  final double width;
  final double height;
  final String asset;

  const AppLogo({
    super.key,
    required this.width,
    required this.height,
    required this.asset,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: BoxFit.cover,
      width: width.w,
      height: height.w,
    );
  }
}
