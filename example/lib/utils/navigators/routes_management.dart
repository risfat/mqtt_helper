import 'package:get/get.dart';

import 'app_pages.dart';

abstract class RouteManagement {
  /// Go to the Home Screen
  static void goToHome() {
    Get.offAllNamed<void>(
      Routes.home,
    );
  }

  /// Go to the Add Broker Screen
  static void goToAddBroker() {
    Get.toNamed<void>(
      Routes.addBroker,
    );
  }
}
