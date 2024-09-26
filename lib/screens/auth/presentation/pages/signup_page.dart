import '../../../../exports.dart';
import '../widgets/back_button.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUpPage());

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController nameController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: 24.h),
                _buildCustomField('User Name', nameController),
                SizedBox(height: 12.h),
                _buildCustomField('User Email', emailController),
                SizedBox(height: 12.h),
                _buildCustomField('Set Password', passwordController, obscureText: true),
                SizedBox(height: 30.h),
                _buildCustomButton('Sign up', width: 124.w, callback: () {
                  context.replaceWithSlideBottomToTop(const HomeScreen());
                }),
                SizedBox(height: 12.h),
                _buildCustomButton('Login with Google', width: 244.w, callback: () {
                  context.replaceWithSlideBottomToTop(const HomeScreen());
                }),
                SizedBox(height: 8.h),
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
        width: 180.w,
        height: 90.h,
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
