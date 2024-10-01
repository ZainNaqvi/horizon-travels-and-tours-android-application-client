import '../../../exports.dart';

class SignInPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignInPage());

  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
          title: const Text('Sign In', style: TextStyle(color: Colors.white)),
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
                  SizedBox(height: 74.h),
                  _buildCustomField(
                    'User Email',
                    context.read<AuthCubit>().emailController,
                  ),
                  SizedBox(height: 12.h),
                  _buildCustomField(
                    'User Password',
                    context.read<AuthCubit>().passwordController,
                    obscureText: true,
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(height: 12.h),
                  _buildForgotPasswordButton(),
                  SizedBox(height: 24.h),
                  _buildCustomButton(
                    'Sign in',
                    state.isLoading,
                    callback: () => context.read<AuthCubit>().signin(context),
                    bg: AppColor.backgroundColor,
                  ),
                  SizedBox(height: 12.h),
                  _buildCustomButton(
                    'Login With Google',
                    state.loadingGoogleAccount,
                    callback: () => context.read<AuthCubit>().loginWithGoogle(context),
                    bg: Colors.pink.shade50,
                    textColor: Colors.pinkAccent,
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Align _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.topRight,
      child: TextButton(
        onPressed: () {
          context.replaceWithFade(const ForgotPasswordPage());
        },
        child: const Text('Forgot Password'),
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
