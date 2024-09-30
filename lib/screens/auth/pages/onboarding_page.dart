import '../../../exports.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  static route() => MaterialPageRoute(builder: (context) => const OnboardingPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAsset.onboardingbg),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 84.h, bottom: 24.h),
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildTextWithStroke(),
                SizedBox(height: 300.h),
                const SizedBox(height: 15),
                _buildCustomButton(
                  'Let\'s Get Started',
                  width: 124.w,
                  callback: () => context.navigateWithSlideRightToLeft(const SignUpPage()),
                ),
                const SizedBox(height: 44),
                _buildTextAlreadyHaveAccount(context),
              ],
            ),
          ),
          Positioned(
            top: 200.h,
            left: 0,
            right: 0,
            child: _buildAppLogo(),
          )
        ],
      ),
    );
  }

  Widget _buildTextWithStroke() {
    return _buildTextWithOutline(
      'Lets Explore The Pakistan With Us'.toUpperCase(),
      GoogleFonts.lobster(
        textStyle: TextStyle(
          letterSpacing: 2.4,
          fontSize: 32.sp,
          color: Colors.amber,
        ),
      ),
      strokeColor: Colors.black,
      strokeWidth: 4.5,
    );
  }

  Widget _buildTextWithOutline(String text, TextStyle style, {required Color strokeColor, required double strokeWidth}) {
    return Stack(
      children: <Widget>[
        Text(
          text,
          textAlign: TextAlign.center,
          style: style.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
            shadows: const [
              Shadow(
                offset: Offset(0, 4),
                blurRadius: 4,
                color: Color(0x40000000),
              ),
            ],
          ),
        ),
        Text(text, textAlign: TextAlign.center, style: style),
      ],
    );
  }

  Widget _buildAppLogo() {
    return AppLogo();
  }

  Widget _buildCustomButton(String text, {required double width, required VoidCallback callback}) {
    return InkWell(
      onTap: () => callback(),
      child: Container(
        width: 244.w,
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
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
            SizedBox(
              width: 44.w,
              child: const Icon(
                Icons.arrow_right_alt_rounded,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextAlreadyHaveAccount(BuildContext context) {
    return GestureDetector(
      onTap: () => context.navigateWithSlideRightToLeft(const SignInPage()),
      child: _buildTextWithOutline(
        'Already have account? Login',
        GoogleFonts.calistoga(
          textStyle: TextStyle(
            letterSpacing: 2.4,
            fontSize: 16.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        strokeColor: Colors.black,
        strokeWidth: 2.5,
      ),
    );
  }
}
