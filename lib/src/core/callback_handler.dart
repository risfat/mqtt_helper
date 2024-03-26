import 'package:mqtt_client/mqtt_client.dart';

class MqttCallbacks {
  final DisconnectCallback? onDisconnected;
  final ConnectCallback? onConnected;
  final SubscribeFailCallback? onSubscribeFail;
  final SubscribeCallback? onSubscribed;
  final UnsubscribeCallback? onUnsubscribed;
  final PongCallback? pongCallback;

  MqttCallbacks({
    this.onDisconnected,
    this.onConnected,
    this.onSubscribeFail,
    this.onSubscribed,
    this.onUnsubscribed,
    this.pongCallback,
  });
}
