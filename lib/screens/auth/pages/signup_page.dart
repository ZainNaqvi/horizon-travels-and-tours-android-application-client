import '../../../exports.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUpPage());

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isPasswordVisible = true;

  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

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
        // context.replaceWithFade(const OnboardingPage());
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColor.authBackground,
        appBar: AppBar(
          backgroundColor: AppColor.authBackground,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
              return Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppLogo(
                      asset: AppAsset.icon,
                      height: 85.h,
                      width: 360.w,
                    ),
                    SizedBox(height: 18.h),
                    CutomInputField(
                      hint: "Name",
                      hintText: "Enter name",
                      controller: context.read<AuthCubit>().usernameController,
                    ),
                    SizedBox(height: 12.h),
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
                    SizedBox(height: 18.h),
                    CustomButton(
                      buttonText: 'Sign Up',
                      widget: state.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : null,
                      onPressed: () => context.read<AuthCubit>().signup(context),
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
                      buttonText: 'Sign Up with Gmail',
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
                          "Already have an account? ",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1.1,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.replaceWithFade(const SignInPage());
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 56.h),
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
