import 'package:horizon_travel_and_tours_android_application/screens/home/presentation/home_screen.dart';

import '../../../../exports.dart';
import '../widgets/back_button.dart';

class SignInPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignInPage());

  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        context.replaceWithFade(const OnboardingPage());
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColor.backgroundColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildBackButton(
                  () => context.replaceWithFade(const OnboardingPage()),
                ),
                _buildAppLogo(),
                SizedBox(height: 74.h),
                _buildCustomField('Email', emailController),
                SizedBox(height: 15.h),
                _buildCustomField('Password', passwordController, obscureText: true),
                SizedBox(height: 64.h),
                _buildCustomButton('Login', width: 124.w, callback: () {
                  context.replaceWithSlideBottomToTop(const HomeScreen());
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Padding(
      padding: EdgeInsets.only(left: 12.0.w),
      child: AppLogo(
        width: 200.w,
        height: 124.h,
        titleFontSize: 44.sp,
        subTitleFontSize: 20.sp,
      ),
    );
  }

  Widget _buildCustomField(String title, TextEditingController controller, {bool obscureText = false}) {
    return CustomField(
      title: title,
      titleFontSize: 24.sp,
      width: 300.w,
      controller: controller,
      obscureText: obscureText,
    );
  }

  Widget _buildCustomButton(String text, {required double width, required VoidCallback callback}) {
    return CustomButton(
      width: width,
      text: text,
      callback: callback,
    );
  }
}
