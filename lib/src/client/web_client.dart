import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_helper/mqtt_helper.dart';

class MqttHelperClient {
  late MqttBrowserClient _client;

  MqttBrowserClient get client => _client;

  MqttBrowserClient setup(MqttConfig config) {
    var userIdentifier = config.projectConfig.userIdentifier;
    var deviceId = config.projectConfig.deviceId;
    var identifier = '$userIdentifier$deviceId';

    _client = MqttBrowserClient(
      config.serverConfig.hostName,
      identifier,
    );
    return _client;
  }
}
