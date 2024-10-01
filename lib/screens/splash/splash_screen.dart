import '../../exports.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: FutureBuilder<User?>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Future.delayed(const Duration(seconds: 2), () {
              if (snapshot.data != null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const OnboardingPage()),
                );
              }
            });
          }

          return Center(
            child: Image.asset(AppAsset.icon),
          );
        },
      ),
    );
  }

  Future<User?> _checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }
}
