import 'package:horizon_travel_and_tours_android_application/screens/find_tour/pages/tour_list_page.dart';

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
              SizedBox(height: 94.h),
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
    return Padding(
      padding: EdgeInsets.only(left: 12.w),
      child: AppLogo(
        width: 200.w,
        height: 124.h,
      ),
    );
  }

  Widget _buildCustomButton(String text, {required VoidCallback callback}) {
    return CustomButton(
      width: 300.w,
      fontWeight: FontWeight.w200,
      color: AppColor.textColor,
      text: text,
      callback: callback,
    );
  }
}
