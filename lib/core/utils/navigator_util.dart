import 'package:flutter/material.dart';

class NavigatorUtil {
  static Route createRoute(Widget page, TransitionType type) {
    switch (type) {
      case TransitionType.fade:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      case TransitionType.slideRightToLeft:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(position: animation.drive(tween), child: child);
          },
        );
      case TransitionType.slideBottomToTop:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(position: animation.drive(tween), child: child);
          },
        );
      default:
        return MaterialPageRoute(builder: (_) => page);
    }
  }
}

enum TransitionType {
  fade,
  slideRightToLeft,
  slideBottomToTop,
}
