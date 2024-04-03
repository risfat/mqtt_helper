import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_helper/mqtt_helper.dart';

class MqttHelperClient {
  late MqttServerClient _client;

  MqttServerClient get client => _client;

  MqttServerClient setup(MqttConfig config) {
    var userId = config.userId;
    var deviceId = config.projectConfig.deviceId;
    var identifier = '$userId$deviceId';

    _client = MqttServerClient(
      config.serverConfig.hostName,
      identifier,
    );
    _client.secure = config.secure;
    _client.useWebSocket = config.webSocketConfig?.useWebsocket ?? false;
    return _client;
  }
}
