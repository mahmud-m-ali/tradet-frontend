import 'package:flutter/material.dart';

/// Responsive breakpoints
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

/// Returns true if screen width >= tablet breakpoint
bool isWideScreen(BuildContext context) {
  return MediaQuery.of(context).size.width >= Breakpoints.tablet;
}

/// Returns true if screen width >= desktop breakpoint
bool isDesktop(BuildContext context) {
  return MediaQuery.of(context).size.width >= Breakpoints.desktop;
}

/// Constrained content wrapper for web — centers content with max width
class WebContentWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const WebContentWrapper({
    super.key,
    required this.child,
    this.maxWidth = 1200,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padding != null
            ? Padding(padding: padding!, child: child)
            : child,
      ),
    );
  }
}
