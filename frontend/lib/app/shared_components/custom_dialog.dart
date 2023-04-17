import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sustainable_city_management/app/config/routes/app_pages.dart';

class CustomShowDialog {
  static void showErrorDialog(context, String title, String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      headerAnimationLoop: false,
      title: title,
      desc: message,
      btnOkOnPress: () {},
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.red,
      onDismissCallback: (type) {
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();
  }

  static void showSuccessDialog(
      context, String title, String message, VoidCallback callback) {
    AwesomeDialog(
      context: context,
      animType: AnimType.bottomSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon: true,
      title: title,
      desc: message,
      autoHide: const Duration(seconds: 2),
      onDismissCallback: (type) {
        callback();
        debugPrint('Dialog Dissmiss from callback $type');
      },
    ).show();
  }
}
