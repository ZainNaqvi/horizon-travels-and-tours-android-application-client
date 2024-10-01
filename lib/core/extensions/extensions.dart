import '../../exports.dart';

extension NavigatorExtensions on BuildContext {
  void navigateWithFade(Widget page) {
    Navigator.push(this, NavigatorUtil.createRoute(page, TransitionType.fade));
  }

  void navigateWithSlideRightToLeft(Widget page) {
    Navigator.push(this, NavigatorUtil.createRoute(page, TransitionType.slideRightToLeft));
  }

  void navigateWithSlideBottomToTop(Widget page) {
    Navigator.push(this, NavigatorUtil.createRoute(page, TransitionType.slideBottomToTop));
  }

  // PushReplacement methods
  void replaceWithFade(Widget page) {
    Navigator.pushReplacement(this, NavigatorUtil.createRoute(page, TransitionType.fade));
  }

  void replaceWithSlideRightToLeft(Widget page) {
    Navigator.pushReplacement(this, NavigatorUtil.createRoute(page, TransitionType.slideRightToLeft));
  }

  void replaceWithSlideBottomToTop(Widget page) {
    Navigator.pushReplacement(this, NavigatorUtil.createRoute(page, TransitionType.slideBottomToTop));
  }
}

bool isEmailValid(String email) {
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}

SystemUiOverlayStyle systemOverlaySetting() {
  return SystemUiOverlayStyle(
    statusBarColor: AppColor.backgroundColor,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.blue.withOpacity(0.2),
    systemNavigationBarDividerColor: Colors.transparent,
  );
}
