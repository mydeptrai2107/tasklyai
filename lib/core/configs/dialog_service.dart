import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class DialogService {
  /// SUCCESS
  static void success(
    BuildContext context, {
    String title = 'Success',
    required String message,
    VoidCallback? onOk,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: title,
      desc: message,
      btnOkOnPress: onOk ?? () {},
    ).show();
  }

  /// ERROR
  static void error(
    BuildContext context, {
    String title = 'Error',
    required String message,
    VoidCallback? onOk,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: title,
      desc: message,
      btnOkOnPress: onOk ?? () {},
    ).show();
  }

  /// WARNING
  static void warning(
    BuildContext context, {
    String title = 'Warning',
    required String message,
    VoidCallback? onOk,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.topSlide,
      title: title,
      desc: message,
      btnOkOnPress: onOk ?? () {},
    ).show();
  }

  /// INFO
  static void info(
    BuildContext context, {
    String title = 'Info',
    required String message,
    VoidCallback? onOk,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.rightSlide,
      title: title,
      desc: message,
      btnOkOnPress: onOk ?? () {},
    ).show();
  }

  /// CONFIRM
  static void confirm(
    BuildContext context, {
    String title = 'Confirm',
    required String message,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String confirmText = 'Yes',
    String cancelText = 'No',
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      title: title,
      desc: message,
      btnOkText: confirmText,
      btnCancelText: cancelText,
      btnOkOnPress: onConfirm,
      btnCancelOnPress: onCancel ?? () {},
    ).show();
  }

  /// LOADING (CUSTOM)
  static AwesomeDialog loading(
    BuildContext context, {
    String message = 'Please wait...',
  }) {
    final dialog = AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.rightSlide,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message),
        ],
      ),
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
    );

    dialog.show();
    return dialog;
  }
}
