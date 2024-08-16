import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_helper/mqtt_helper.dart';

class MqttHelper {
  late MqttConfig _config;

  bool _initialized = false;

  MqttCallbacks? _callbacks;

  MqttClient? _client;

  MqttHelperClient? _helperClient;

  List<String>? _topics;

  void Function(List<String>)? _subscribedTopicsCallback;

  List<String> subscribedTopics = [];

  bool _autoSubscribe = false;

  late StreamController<MqttHelperPayload?> _rawEventStream;

  late StreamController<EventModel> _eventStream;

  late StreamController<bool> _connectionStream;

  StreamSubscription<EventModel> onEvent(
    Function(EventModel) event,
  ) =>
      _eventStream.stream.listen(event);

  StreamSubscription<MqttHelperPayload?> onRawEvent(
    Function(MqttHelperPayload?) event,
  ) =>
      _rawEventStream.stream.listen(event);

  StreamSubscription<bool> onConnectionChange(
    Function(bool) change,
  ) =>
      _connectionStream.stream.listen(change);

  Future<void> initialize(
    MqttConfig config, {
    MqttCallbacks? callbacks,
    bool autoSubscribe = false,
    List<String>? topics,
    void Function(List<String>)? subscribedTopicsCallback,
  }) async {
    if (autoSubscribe) {
      if (topics == null || topics.isEmpty) {
        throw Exception(
          'You must specify at least one topic when auto-subscribing',
        );
      }
    }

    _rawEventStream = StreamController<MqttHelperPayload>.broadcast();
    _eventStream = StreamController<EventModel>.broadcast();
    _connectionStream = StreamController<bool>.broadcast();

    _initialized = true;
    _config = config;
    _callbacks = callbacks;
    _topics = topics;
    _autoSubscribe = autoSubscribe;
    _subscribedTopicsCallback = subscribedTopicsCallback;
    await _initializeClient();
    await _connectClient();
  }

  Future<void> _initializeClient() async {
    if (!_initialized) {
      throw Exception(
        'MqttConfig is not initialized. Initialize it by calling initialize(config)',
      );
    }

    _helperClient = MqttHelperClient();
    var userIdentifier = _config.projectConfig.userIdentifier;
    var deviceId = _config.projectConfig.deviceId;
    var identifier = '$userIdentifier$deviceId';

    _client = _helperClient?.setup(_config);

    _client?.port = _config.serverConfig.port;
    _client?.keepAlivePeriod = 60;
    _client?.onDisconnected = _onDisconnected;
    _client?.onUnsubscribed = _onUnSubscribed;
    _client?.onSubscribeFail = _onSubscribeFailed;
    _client?.logging(on: _config.enableLogging);
    _client?.autoReconnect = true;
    _client?.pongCallback = _pong;
    _client?.setProtocolV311();
    _client?.websocketProtocols =
        _config.webSocketConfig?.websocketProtocols ?? [];

    /// Add the successful connection callback
    _client?.onConnected = _onConnected;
    _client?.onSubscribed = _onSubscribed;

    _client?.connectionMessage =
        MqttConnectMessage().withClientIdentifier(identifier).startClean();
  }

  Future<void> _connectClient() async {
    try {
      var res = await _client?.connect(
        _config.projectConfig.username.isNotEmpty
            ? _config.projectConfig.username
            : null,
        _config.projectConfig.password.isNotEmpty
            ? _config.projectConfig.password
            : null,
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
      throw Exception(
        'MqttConfig is not initialized. Initialize it by calling initialize(config)',
      );
    }

    if (_client?.getSubscriptionsStatus(topic) ==
        MqttSubscriptionStatus.doesNotExist) {
      _client?.subscribe(topic, MqttQos.atMostOnce);
      subscribedTopics.add(topic);
    }
  }

  void subscribeTopics(List<String> topics) {
    if (!_initialized) {
      throw Exception(
        'MqttConfig is not initialized. Initialize it by calling initialize(config)',
      );
    }
    for (var topic in topics) {
      subscribeTopic(topic);
    }
    _subscribedTopicsCallback?.call(subscribedTopics);
  }

  void unsubscribeTopic(String topic) {
    if (_client?.getSubscriptionsStatus(topic) ==
        MqttSubscriptionStatus.active) {
      _client?.unsubscribe(topic);
    }
  }

  void unsubscribeTopics(List<String> topics) {
    for (var topic in topics) {
      unsubscribeTopic(topic);
    }
  }

  void disconnect() {
    _client?.autoReconnect = false;
    _client?.disconnect();
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
    _client?.updates
        ?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) async {
      _rawEventStream.add(c);
      final recMess = c!.first.payload as MqttPublishMessage;
      final topic = c.first.topic;

      var payload = jsonDecode(
        MqttPublishPayload.bytesToStringAsString(recMess.payload.message),
      ) as Map<String, dynamic>;

      _eventStream.add(
        EventModel(
          topic: topic,
          payload: payload,
        ),
      );
    });
  }

  int? publishMessage({required String message, bool retain = false}) {
    const pubTopic = 'test/sample';
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    if (_client?.connectionStatus?.state == MqttConnectionState.connected) {
      return _client?.publishMessage(
        pubTopic,
        MqttQos.atMostOnce,
        builder.payload!,
        retain: retain,
      );
    }
    return null;
  }
}
