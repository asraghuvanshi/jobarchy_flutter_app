import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class AppAlerts {
  static void showError(String msg) {
    Fluttertoast.showToast(msg: msg, backgroundColor: Colors.red);
  }

  static void showSuccess(String msg) {
    Fluttertoast.showToast(msg: msg, backgroundColor: Colors.green);
  }

  static void showInfo(String msg) {
    Fluttertoast.showToast(msg: msg, backgroundColor: Colors.blue);
  }
}
