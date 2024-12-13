import 'dart:async';

import 'package:example/main.dart';
import 'package:get/get.dart';
import 'package:mqtt_helper/mqtt_helper.dart';

class MqttController extends GetxController {
  final _mqttHelper = MqttHelper();

  late List<String> _subscripbedTopics;

  late List<String> _topics;

  bool isMqttConnected = false;

  Future<void> setup(
      {required BrokerModel broker, required String userIdentifier}) async {
    _topics = broker.topics.map((e) => e.topic).toList();
    final deviceId = Get.find<DeviceConfig>().deviceId ?? '';
    await _mqttHelper.initialize(
      MqttConfig(
        serverConfig: ServerConfig(
            hostName: broker.brokerName,
            port: int.tryParse(broker.portNumber) ?? 0),
        projectConfig: ProjectConfig(
          deviceId: deviceId,
          userIdentifier: userIdentifier,
          username: 'username',
          password: 'password',
        ),
      ),
      callbacks: MqttCallbacks(
        onConnected: _onConnected,
        onDisconnected: _onDisconnected,
        onSubscribeFail: _onSubscribeFailed,
        onSubscribed: _onSubscribed,
        onUnsubscribed: _onUnSubscribed,
        pongCallback: _pong,
      ),
      autoSubscribe: true,
      topics: _topics,
      subscribedTopicsCallback: (topics) {
        _subscripbedTopics = topics;
      },
      unSubscribedTopicsCallback: (topics) {
        _subscripbedTopics = topics;
      },
    );

    _mqttHelper.onConnectionChange((value) {
      return isMqttConnected = value;
    });
    _mqttHelper.onEvent(_onEvent);
  }

  void unsubscribeTopics() {
    try {
      _mqttHelper.unsubscribeTopics(_subscripbedTopics);
    } catch (e, st) {
      AppLog.error('Unsubscribe Error - $e', st);
    }
  }

  void disconnect() async {
    try {
      unsubscribeTopics();
      await Future.delayed(const Duration(milliseconds: 500));
      _mqttHelper.disconnect();
    } catch (_) {}
  }

  void _pong() {
    AppLog.info('MQTT pong');
  }

  /// onDisconnected callback, it will be called when connection is breaked
  void _onDisconnected() async {
    isMqttConnected = false;
    Utility.showMessage(
      message: 'MQTT is Disconnected',
      type: MessageType.error,
    );
    AppLog.success('MQTT Disconnected');
  }

  /// onSubscribed callback, it will be called when connection successfully subscribes to certain topic
  void _onSubscribed(String topic) {
    AppLog.success('MQTT Subscribed - $topic');
  }

  /// onUnsubscribed callback, it will be called when connection successfully unsubscribes to certain topic
  void _onUnSubscribed(String? topic) {
    AppLog.success('MQTT Unsubscribed - $topic');
  }

  /// onSubscribeFailed callback, it will be called when connection fails to subscribe to certain topic
  void _onSubscribeFailed(String topic) {
    AppLog.error('MQTT Subscription failed - $topic');
  }

  /// onConnected callback, it will be called when connection is established
  void _onConnected() {
    isMqttConnected = true;
    Utility.showMessage(
      message: 'MQTT is Connected',
      type: MessageType.success,
    );
    AppLog.success('MQTT Connected');
  }

  void _onEvent(EventModel event) async {
    final payload = event.payload;
    AppLog.info('Event - $payload');
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().updateMessage(event);
    }
  }

  void publishMessage({
    required String message,
    required String pubTopic,
  }) async {
    _mqttHelper.publishMessage(
      message: message,
      pubTopic: pubTopic,
    );
  }
}
