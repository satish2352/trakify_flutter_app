import 'package:flutter/material.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class CustomPageRoute extends PageRouteBuilder {
  final Widget nextPage;
  final int direction;

  CustomPageRoute({required this.nextPage, required this.direction}) : super(
    pageBuilder: (context, animation, secondaryAnimation) => nextPage,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      Offset begin = Offset(direction < 0 ? -1.0 : 1.0, 0.0);
      return SlideTransition(
        position: Tween<Offset>(
          begin: begin,
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
        ),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 800),
  );
}