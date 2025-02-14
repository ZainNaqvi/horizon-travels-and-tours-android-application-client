import '../../exports.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const _splashDisplayDuration = Duration(seconds: 2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _buildBackgroundDecoration(),
        child: FutureBuilder<User?>(
          future: _checkLoginStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            _handlePostAuthNavigation(context, isUserLoggedIn: snapshot.data != null);

            return _buildAppLogo();
          },
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      color: AppColor.authBackground,
    );
  }

  Widget _buildAppLogo() {
    return Center(
      child: Image.asset(AppAsset.icon),
    );
  }

  void _handlePostAuthNavigation(BuildContext context, {required bool isUserLoggedIn}) {
    Future.delayed(_splashDisplayDuration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => isUserLoggedIn ? const HomeScreen() : const SignInPage(),
        ),
      );
    });
  }

  Future<User?> _checkLoginStatus() async {
    return FirebaseAuth.instance.currentUser;
  }
}
