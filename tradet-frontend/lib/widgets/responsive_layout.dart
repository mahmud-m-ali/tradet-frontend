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

/// Returns a route with no transition animation on desktop, standard slide on mobile.
Route<T> appRoute<T>(BuildContext context, Widget page) {
  if (isWideScreen(context)) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    );
  }
  return MaterialPageRoute<T>(builder: (_) => page);
}

/// Shows a bottom sheet on mobile, centered dialog on desktop.
Future<T?> showResponsiveSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext ctx, bool isDialog) builder,
  Color backgroundColor = const Color(0xFF1A3D2B),
  bool isScrollControlled = true,
}) {
  if (isWideScreen(context)) {
    return showDialog<T>(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => Dialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480, maxHeight: 700),
          child: SingleChildScrollView(child: builder(ctx, true)),
        ),
      ),
    );
  }
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: backgroundColor,
    isScrollControlled: isScrollControlled,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => builder(ctx, false),
  );
}
