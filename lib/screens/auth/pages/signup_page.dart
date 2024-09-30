import '../../../exports.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUpPage());

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().clear();
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.replaceWithFade(const OnboardingPage());
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text('Sign Up', style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.replaceWithFade(const OnboardingPage()),
          ),
          backgroundColor: AppColor.backgroundColor,
          iconTheme: const IconThemeData(color: Colors.white),
          systemOverlayStyle: systemOverlaySetting(),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
            return Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 24.h),
                  _buildAppLogo(),
                  SizedBox(height: 34.h),
                  _buildCustomField(
                    'User Name',
                    context.read<AuthCubit>().usernameController,
                  ),
                  SizedBox(height: 12.h),
                  _buildCustomField(
                    'User Email',
                    context.read<AuthCubit>().emailController,
                  ),
                  SizedBox(height: 12.h),
                  _buildCustomField(
                    'Set Password',
                    context.read<AuthCubit>().passwordController,
                    obscureText: true,
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(height: 32.h),
                  _buildCustomButton(
                    'Sign up',
                    state.isLoading,
                    callback: () => context.read<AuthCubit>().signup(context),
                    bg: AppColor.backgroundColor,
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return AppLogo(height: 124.h, width: 124.w);
  }

  Widget _buildCustomField(
    String title,
    TextEditingController controller, {
    bool obscureText = false,
    TextInputType textInputType = TextInputType.emailAddress,
  }) {
    return CustomField(
      title: title,
      keyboardType: textInputType,
      width: 300.w,
      controller: controller,
      obscureText: obscureText,
    );
  }

  Widget _buildCustomButton(
    String text,
    bool isloading, {
    required VoidCallback callback,
    Color bg = Colors.white,
    Color textColor = Colors.white,
  }) {
    return CustomButton(
      text: text,
      isloading: isloading,
      callback: callback,
      bgColor: bg,
      color: textColor,
    );
  }
}
