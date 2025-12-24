import 'package:flutter/material.dart';
import 'package:quick_app/widgets/top_snack_bar.dart';

class SnackbarService {
  static void showMessage(String message, BuildContext context, {bool isError = false}) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    
    overlayEntry = OverlayEntry(
      builder: (context) => TopSnackBar(
        message: message,
        isError: isError,
        onDismiss: () => overlayEntry.remove(),
      ),
    );
    
    overlay.insert(overlayEntry);
    
    // Auto dismiss sau 3 giây
    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}