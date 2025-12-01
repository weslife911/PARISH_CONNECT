import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

// =============================================================================
// HELPERS
// =============================================================================

Route AnimatedRoute(Widget child) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween(begin: const Offset(0, 0.06), end: Offset.zero).animate(curved),
          child: child,
        ),
      );
    },
  );
}

void showToast(BuildContext context, String msg, {ToastificationType type = ToastificationType.info}) {
  try {
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.fillColored,
      title: Text(msg),
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topCenter,
      showProgressBar: true,
    );
  } catch (_) {
    // Fallback to SnackBar in unlikely case toastification fails
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}