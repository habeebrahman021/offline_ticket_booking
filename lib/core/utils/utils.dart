import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// A utility class containing helper methods for various functionalities.
class Utils {
  /// Displays a toast message on the screen.
  ///
  /// [message]: The message to be displayed in the toast.
  ///
  /// The toast appears at the bottom of the screen with a black background
  /// and white text. It only works if the `Fluttertoast` package is set up
  /// correctly in the project.
  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
  }
}
