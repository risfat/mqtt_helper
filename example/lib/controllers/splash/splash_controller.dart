import 'package:example/main.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    startOnInit();
  }

  var isLoggedIn = false;

  void startOnInit() async {
    await Future.delayed(const Duration(seconds: 2));
    RouteManagement.goToHome();
  }
}
