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
