import '../../../../exports.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColor.backgroundColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              _buildAppLogo(),
              _buildCustomButton('Find a tour', callback: () {
                context.navigateWithSlideRightToLeft(FindTourPage());
              }),
              SizedBox(height: 42.h),
              _buildCustomButton('Customize tour', callback: () {}),
              SizedBox(height: 42.h),
              _buildCustomButton('Create a memory', callback: () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Image.asset(AppAsset.icon);
  }

  Widget _buildCustomButton(String text, {required VoidCallback callback}) {
    return CustomButton(
      fontWeight: FontWeight.w500,
      color: AppColor.textColor,
      text: text,
      callback: callback,
    );
  }
}
