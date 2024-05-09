import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_helper/mqtt_helper.dart';

class MqttHelper {
  late MqttConfig _config;

  bool _initialized = false;

  MqttCallbacks? _callbacks;

  late MqttClient _client;

  late MqttHelperClient _helperClient;

  late String _userId;

  late String _deviceId;

  List<String>? _topics;

  bool _autoSubscribe = false;

  late StreamController<MqttHelperPayload?> _rawEventStream;

  late StreamController<EventModel> _eventStream;

  late StreamController<DynamicMap> _dataStream;

  late StreamController<bool> _connectionStream;

  StreamSubscription<DynamicMap> onData(
    Function(DynamicMap) event,
  ) =>
      _dataStream.stream.listen(event);

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
  }) async {
    if (autoSubscribe) {
      if (topics == null || topics.isEmpty) {
        throw Exception(
          'You must specify at least one topic when auto-subscribing',
        );
      }
    }

    _rawEventStream = StreamController<MqttHelperPayload>.broadcast();
    _dataStream = StreamController<DynamicMap>.broadcast();
    _eventStream = StreamController<EventModel>.broadcast();
    _connectionStream = StreamController<bool>.broadcast();

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
      throw Exception(
        'MqttConfig is not initialized. Initialize it by calling initialize(config)',
      );
    }

    _helperClient = MqttHelperClient();

    _userId = _config.userId;
    _deviceId = _config.projectConfig.deviceId;
    var identifier = '$_userId$_deviceId';

    _client = _helperClient.setup(_config);

    _client.port = _config.serverConfig.port;
    _client.keepAlivePeriod = 60;
    _client.onDisconnected = _onDisconnected;
    _client.onUnsubscribed = _onUnSubscribed;
    _client.onSubscribeFail = _onSubscribeFailed;
    _client.logging(on: _config.enableLogging);
    _client.autoReconnect = true;
    _client.pongCallback = _pong;
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
      throw Exception(
        'MqttConfig is not initialized. Initialize it by calling initialize(config)',
      );
    }

    _client.subscribe(topic, MqttQos.atMostOnce);
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
  }

  void unsubscribeTopic(String topic) {
    _client.unsubscribe(topic);
  }

  void unsubscribeTopics(List<String> topics) {
    for (var topic in topics) {
      unsubscribeTopic(topic);
    }
  }

  void disconnect() {
    _client.autoReconnect = false;
    _client.disconnect();
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
      _dataStream.add(payload);
    });
  }
}
