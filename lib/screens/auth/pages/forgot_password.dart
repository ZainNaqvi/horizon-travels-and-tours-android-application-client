import '../../../exports.dart';

class ForgotPasswordPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const ForgotPasswordPage());

  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().clear();
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
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
                  SizedBox(height: 18.h),
                  CustomButton(
                    buttonText: 'Send Reset Link',
                    widget: state.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : null,
                    onPressed: () => context.read<AuthCubit>().forgotPassword(context),
                  ),
                  SizedBox(height: 28.h),
                  SizedBox(
                    width: 244.w,
                    child: Text(
                      'To recover your password, you need to enter your registerd email address we will send the recovery code to your email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        height: 1.8,
                      ),
                    ),
                  ),
                  SizedBox(height: 56.h),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
