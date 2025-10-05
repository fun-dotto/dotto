import 'package:flutter/material.dart';

Widget fromRightAnimation(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  const begin = Offset(1, 0); // 右から左
  const end = Offset.zero;
  final tween = Tween(
    begin: begin,
    end: end,
  ).chain(CurveTween(curve: Curves.easeInOut));
  final offsetAnimation = animation.drive(tween);
  return SlideTransition(position: offsetAnimation, child: child);
}
