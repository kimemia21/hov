import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PremiumToast {
  static void show(ToastGravity gravity) {
    Fluttertoast.showToast(
      msg: "⭐️ This feature is available for Premium subscribers only",
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity,
      backgroundColor: Colors.black.withOpacity(0.9),
      textColor: Colors.white,
      fontSize: 16.0,
      timeInSecForIosWeb: 4,
    );
  }

  // With custom action button
  static void showWithAction({required VoidCallback onUpgrade}) {
    Fluttertoast.showToast(
      msg: "⭐️ Upgrade to Premium to access this feature",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black.withOpacity(0.9),
      textColor: Colors.white,
      fontSize: 16.0,
      timeInSecForIosWeb: 4,
    );
    
    // Show snackbar with action button
    final context = GlobalKey<NavigatorState>().currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Unlock all premium features'),
          action: SnackBarAction(
            label: 'Upgrade',
            textColor: Colors.amber,
            onPressed: onUpgrade,
          ),
        ),
      );
    }
  }
}