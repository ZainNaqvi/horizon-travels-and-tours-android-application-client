import '../../../exports.dart';

class SignInPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignInPage());
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final formKey = GlobalKey<FormState>();
  bool isPasswordVisible = true;

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    const SystemUiOverlayStyle(
      statusBarColor: AppColor.authBackground,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColor.authBackground,
      systemNavigationBarDividerColor: Colors.transparent,
    );
    context.read<AuthCubit>().clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // context.replaceWithFade(const OnboardingPage());
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColor.authBackground,
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
              return Form(
                key: formKey,
                child: Column(
                  children: [
                    AppLogo(
                      asset: AppAsset.icon,
                      height: 85.h,
                      width: 360.w,
                    ),
                    SizedBox(height: 18.h),
                    CutomInputField(
                      hint: "Email",
                      hintText: "Enter email",
                      controller: context.read<AuthCubit>().emailController,
                    ),
                    SizedBox(height: 12.h),
                    CutomInputField(
                      hint: "Password",
                      controller: context.read<AuthCubit>().passwordController,
                      hintText: "Enter password",
                      isObscure: isPasswordVisible,
                      suffixIcon: IconButton(
                        icon: SvgPicture.asset(
                          isPasswordVisible ? AppAsset.eyeVisibilityOnn : AppAsset.eyeVisibilityOff,
                        ),
                        onPressed: () => togglePasswordVisibility(),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          context.navigateWithSlideRightToLeft(const ForgotPasswordPage());
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    CustomButton(
                      buttonText: 'Login',
                      widget: state.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : null,
                      onPressed: () => context.read<AuthCubit>().signin(context),
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: Divider(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          alignment: Alignment.center,
                          height: 44.h,
                          width: 44.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Text(
                            "OR",
                            style: TextStyle(fontSize: 16.sp, color: Colors.black),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        const Flexible(
                          child: Divider(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    SocialMediaButton(
                      buttonText: 'Login with Gmail',
                      imagePath: AppAsset.google,
                      onPressed: () => context.read<AuthCubit>().loginWithGoogle(context),
                      fontSize: 12.sp,
                      widget: state.loadingGoogleAccount
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                    SizedBox(height: 28.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "New member? ",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1.1,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.navigateWithSlideBottomToTop(const SignUpPage());
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
