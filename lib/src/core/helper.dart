import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_helper/mqtt_helper.dart';

class MqttHelper {
  late MqttConfig _config;

  bool _initialized = false;

  MqttCallbacks? _callbacks;

  late MqttServerClient _client;

  late String _userId;

  late String _deviceId;

  List<String>? _topics;

  bool _autoSubscribe = false;

  final _eventStream = StreamController<Map<String, dynamic>>.broadcast();

  final _connectionStream = StreamController<bool>.broadcast();

  StreamSubscription<Map<String, dynamic>> onEvent(
    Function(Map<String, dynamic>) event,
  ) =>
      _eventStream.stream.listen(event);

  StreamSubscription<bool> onConnectionChange(
    Function(bool) change,
  ) =>
      _connectionStream.stream.listen(change);

  Future<void> initialize(
    MqttConfig config, {
    MqttCallbacks? callbacks,
    bool autoSubscribe = false,
    List<String>? topics,
  }) async {
    if (autoSubscribe) {
      if (topics == null || topics.isEmpty) {
        throw Exception('You must specify at least one topic when auto-subscribing');
      }
    }
    _initialized = true;
    _config = config;
    _callbacks = callbacks;
    _topics = topics;
    _autoSubscribe = autoSubscribe;
    await _initializeClient();
    await _connectClient();
  }

  Future<void> _initializeClient() async {
    if (!_initialized) {
      throw Exception('MqttConfig is not initialized. Initialize it by calling initialize(config)');
    }
    _userId = _config.userId;
    _deviceId = _config.projectConfig.deviceId;
    var identifier = '$_userId$_deviceId';

    _client = MqttServerClient(
      _config.serverConfig.hostName,
      identifier,
    );

    _client.port = _config.serverConfig.port;
    _client.secure = _config.secure;
    _client.keepAlivePeriod = 60;
    _client.onDisconnected = _onDisconnected;
    _client.onUnsubscribed = _onUnSubscribed;
    _client.onSubscribeFail = _onSubscribeFailed;
    _client.logging(on: _config.enableLogging);
    _client.autoReconnect = true;
    _client.pongCallback = _pong;
    _client.useWebSocket = _config.webSocketConfig?.useWebsocket ?? false;
    _client.setProtocolV311();
    _client.websocketProtocols = _config.webSocketConfig?.websocketProtocols ?? [];

    /// Add the successful connection callback
    _client.onConnected = _onConnected;
    _client.onSubscribed = _onSubscribed;

    _client.connectionMessage = MqttConnectMessage().withClientIdentifier(identifier).startClean();
  }

  Future<void> _connectClient() async {
    try {
      var res = await _client.connect(
        _config.username,
        _config.password,
      );
      if (res?.state == MqttConnectionState.connected) {
        _connectionStream.add(true);
        if (_autoSubscribe) {
          subscribeTopics(_topics!);
        }
      }
    } catch (e, st) {
      log('[MQTTHelper] - $e', stackTrace: st);
    }
  }

  void subscribeTopic(String topic) {
    if (!_initialized) {
      throw Exception('MqttConfig is not initialized. Initialize it by calling initialize(config)');
    }

    if (_client.getSubscriptionsStatus(topic) == MqttSubscriptionStatus.doesNotExist) {
      _client.subscribe(topic, MqttQos.atMostOnce);
    }
  }

  void subscribeTopics(List<String> topics) {
    if (!_initialized) {
      throw Exception('MqttConfig is not initialized. Initialize it by calling initialize(config)');
    }

    for (var topic in topics) {
      subscribeTopic(topic);
    }
  }

  void unsubscribeTopic(String topic) {
    if (_client.getSubscriptionsStatus(topic) == MqttSubscriptionStatus.active) {
      _client.unsubscribe(topic);
    }
  }

  void unsubscribeTopics(List<String> topics) {
    for (var topic in topics) {
      unsubscribeTopic(topic);
    }
  }

  void _pong() {
    _callbacks?.pongCallback?.call();
  }

  void _onDisconnected() {
    _connectionStream.add(false);
    _callbacks?.onDisconnected?.call();
  }

  void _onSubscribed(String topic) {
    _callbacks?.onSubscribed?.call(topic);
  }

  void _onUnSubscribed(String? topic) {
    _callbacks?.onUnsubscribed?.call(topic);
  }

  void _onSubscribeFailed(String topic) {
    _callbacks?.onSubscribeFail?.call(topic);
  }

  void _onConnected() {
    _callbacks?.onConnected?.call();

    _client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) async {
      final recMess = c!.first.payload as MqttPublishMessage;

      var payload = jsonDecode(
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message),
      ) as Map<String, dynamic>;

      _eventStream.add(payload);
    });
  }
}
