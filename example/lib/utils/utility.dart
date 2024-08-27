import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:example/res/res.dart';
import 'package:example/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'enums.dart';

class Utility {
  const Utility._();

  static void hideKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  /// Returns true if the internet connection is available.
  static Future<bool> get isNetworkAvailable async {
    final result = await Connectivity().checkConnectivity();
    return result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.ethernet);
  }

  static Future<T?> openBottomSheet<T>(
    Widget child, {
    Color? backgroundColor,
    bool isDismissible = true,
    ShapeBorder? shape,
  }) async =>
      await Get.bottomSheet<T>(
        child,
        barrierColor: Colors.black.withOpacity(0.7),
        backgroundColor: backgroundColor,
        isDismissible: isDismissible,
        shape: shape,
        isScrollControlled: true,
      );

  /// Show loader
  static void showLoader() async {
    await Get.dialog(
      const AppLoader(),
      barrierDismissible: false,
    );
  }

  /// Close loader
  static void closeLoader() {
    closeDialog();
  }

  /// Show error dialog from response model
  static Future<void> showInfoDialog(
    String message, [
    bool isSuccess = false,
    String? title,
  ]) async {
    await Get.dialog(
      CupertinoAlertDialog(
        title: Text(
          title ?? (isSuccess ? 'Success' : 'Error'),
        ),
        content: Text(
          message,
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: Get.back,
            isDefaultAction: true,
            child: Text(
              'Okay',
              style: Styles.black16,
            ),
          ),
        ],
      ),
    );
  }

  /// Show info dialog
  static void showDialog(
    String message,
  ) async {
    await Get.dialog(
      CupertinoAlertDialog(
        title: const Text('Info'),
        content: Text(
          message,
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: Get.back,
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  /// Show alert dialog
  static Future<void> showAlertDialog({
    String? message,
    String? title,
    Function()? onPress,
  }) async {
    await Get.dialog(
      CupertinoAlertDialog(
        title: Text('$title'),
        content: Text('$message'),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: onPress,
            child: const Text('Okay'),
          ),
          const CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: closeDialog,
            child: Text('Cancel'),
          )
        ],
      ),
    );
  }

  /// Close any open dialog.
  static void closeDialog() {
    if (Get.isDialogOpen ?? false) Get.back<void>();
  }

  /// Close any open snackbar
  static void closeSnackbar() {
    if (Get.isSnackbarOpen) Get.back<void>();
  }

  /// Show a message to the user.
  ///
  /// [message] : Message you need to show to the user.
  /// [type] : Type of the message for different background color.
  /// [onTap] : An event for onTap.
  /// [actionName] : The name for the action.

  static void showMessage({
    String? message,
    MessageType type = MessageType.information,
    Function()? onTap,
    String? actionName,
  }) {
    if (message == null || message.isEmpty) return;
    closeDialog();
    closeSnackbar();
    var backgroundColor = Colors.black;
    switch (type) {
      case MessageType.error:
        backgroundColor = Colors.red;
        break;
      case MessageType.information:
        backgroundColor = Colors.blue;
        break;
      case MessageType.success:
        backgroundColor = Colors.green;
        break;
      default:
        backgroundColor = Colors.black;
        break;
    }
    Future.delayed(
      const Duration(seconds: 0),
      () {
        Get.rawSnackbar(
          messageText: Text(
            message,
            style: Styles.white16,
          ),
          mainButton: actionName != null
              ? TextButton(
                  onPressed: onTap ?? Get.back,
                  child: Text(
                    actionName,
                    style: Styles.white16,
                  ),
                )
              : null,
          backgroundColor: backgroundColor,
          margin: Dimens.edgeInsets10,
          borderRadius: Dimens.ten + Dimens.five,
          snackStyle: SnackStyle.FLOATING,
        );
      },
    );
  }

  static void unfocusKeyboard(BuildContext context) {
    var currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  static void updateLater(VoidCallback callback, [bool addDelay = true]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(
          addDelay ? const Duration(milliseconds: 10) : Duration.zero, () {
        callback();
      });
    });
  }

  /// this is for change encoded string to decode string
  static String decodeString(String value) {
    try {
      return utf8.fuse(base64).decode(value);
    } catch (e) {
      return value;
    }
  }

  /// this is for change decode string to encode string
  static String encodeString(String value) => utf8.fuse(base64).encode(value);
}
