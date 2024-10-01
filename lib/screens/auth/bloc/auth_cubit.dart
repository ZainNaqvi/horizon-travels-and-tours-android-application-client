// ignore_for_file: use_build_context_synchronously

import '../../../exports.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());
  final DbHelper _dbHelper = DbHelper();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void signin(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    validator(context);
    emit(state.copyWith(isLoading: true));
    String response = await _dbHelper.userLogin(context, email: email, password: password);
    if (response == 'success') {
      context.navigateWithSlideRightToLeft(const HomeScreen());
    }
    emit(state.copyWith(isLoading: false));
  }

  void signup(BuildContext context) async {
    String username = usernameController.text;
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String name = username;
    String imageUrl = "";
    String role = "user";

    if (username.isEmpty) {
      showToast('Username is required.', context);
      return;
    }

    if (username.split(' ').length < 2) {
      showToast('Username should contain at least 2 words.', context);
      return;
    }

    validator(context);
    emit(state.copyWith(isLoading: true));
    String response = await _dbHelper.createUser(
      context,
      name: name,
      imageUrl: imageUrl,
      email: email,
      password: password,
      role: role,
    );
    if (response == 'success') {
      emit(state.copyWith(isLoading: false));
      // ignore: use_build_context_synchronously
      context.navigateWithSlideRightToLeft(const SignInPage());
    }
    emit(state.copyWith(isLoading: false));
  }

  void forgotPassword(BuildContext context) async {
    String email = emailController.text.trim();
    if (email.isNotEmpty) {
      emit(state.copyWith(isLoading: true));
      await _dbHelper.forgotPassword(context, email: email);
      emit(state.copyWith(isLoading: false));
    } else {
      showToast('Email is required.', context);
    }
  }

  void loginWithGoogle(BuildContext context) async {
    emit(state.copyWith(loadingGoogleAccount: true));
    String response = await _dbHelper.signInWithGoogle(context);
    if (response == 'success') {
      context.navigateWithSlideRightToLeft(const HomeScreen());
    }
    emit(state.copyWith(loadingGoogleAccount: false));
  }

  void signOut() {
    emit(const AuthState());
  }

  void clear() {
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  void validator(BuildContext context) {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty) {
      showToast('Email is required.', context);
      return;
    }

    if (!isEmailValid(email)) {
      showToast('Please enter a valid email address.', context);
      return;
    }

    if (password.isEmpty) {
      showToast('Password is required.', context);
      return;
    }

    if (password.length <= 6) {
      showToast('Password must be at least 7 characters.', context);
      return;
    }
  }
}
