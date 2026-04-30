import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushbarHelper {
  FlushbarHelper._();

  static Future<void> showSuccess({
    required BuildContext context,
    required String message,
    String title = 'Success',
  }) async {
    await Flushbar(
      title: title,
      message: message,
      duration: const Duration(seconds: 3),
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      backgroundGradient: const LinearGradient(
        colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF388E3C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadows: const [
        BoxShadow(
          color: Color(0x661B5E20),
          spreadRadius: 1,
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
      icon: const Icon(Icons.check_circle_rounded, color: Colors.white, size: 28),
      leftBarIndicatorColor: Color(0xFF00E676),
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Color(0xFFE8F5E9),
          fontSize: 14,
          height: 1.4,
        ),
      ),
      animationDuration: const Duration(milliseconds: 500),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
    ).show(context);
  }

  static Future<void> showError({
    required BuildContext context,
    required String message,
    String title = 'Error',
  }) async {
    await Flushbar(
      title: title,
      message: message,
      duration: const Duration(seconds: 4),
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      backgroundGradient: const LinearGradient(
        colors: [Color(0xFFB71C1C), Color(0xFFC62828), Color(0xFFD32F2F)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadows: const [
        BoxShadow(
          color: Color(0x66B71C1C),
          spreadRadius: 1,
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
      icon: const Icon(Icons.error_rounded, color: Colors.white, size: 28),
      leftBarIndicatorColor: Color(0xFFFF5252),
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
      ),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Color(0xFFFFEBEE),
          fontSize: 14,
          height: 1.4,
        ),
      ),
      animationDuration: const Duration(milliseconds: 500),
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
    ).show(context);
  }
}
