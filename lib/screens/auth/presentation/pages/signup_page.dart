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
                SizedBox(height: 44.h),
                _buildCustomField('User Name', nameController),
                const SizedBox(height: 15),
                _buildCustomField('User Email', emailController),
                const SizedBox(height: 15),
                _buildCustomField('Set Password', passwordController, obscureText: true),
                const SizedBox(height: 34),
                _buildCustomButton('Sign up', width: 124.w, callback: () {}),
                SizedBox(height: 12.h),
                _buildCustomButton('Login with Google', width: 244.w, callback: () {}),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Padding(
      padding: EdgeInsets.only(left: 26.0.w),
      child: const AppLogo(),
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
