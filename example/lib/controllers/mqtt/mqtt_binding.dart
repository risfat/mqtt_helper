import 'package:example/main.dart';
import 'package:get/get.dart';

class MqttBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(MqttController());
  }
}
