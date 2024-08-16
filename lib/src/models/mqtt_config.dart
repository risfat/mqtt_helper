import 'dart:convert';

import 'models.dart';

class MqttConfig {
  final ServerConfig serverConfig;
  final ProjectConfig projectConfig;
  final WebSocketConfig? webSocketConfig;

  final bool enableLogging;
  final bool secure;

  MqttConfig({
    required this.serverConfig,
    required this.projectConfig,
    this.webSocketConfig,
    this.enableLogging = true,
    this.secure = false,
  });

  MqttConfig copyWith({
    ServerConfig? serverConfig,
    ProjectConfig? projectConfig,
    WebSocketConfig? webSocketConfig,
    bool? enableLogging,
    bool? secure,
  }) {
    return MqttConfig(
      serverConfig: serverConfig ?? this.serverConfig,
      projectConfig: projectConfig ?? this.projectConfig,
      webSocketConfig: webSocketConfig ?? this.webSocketConfig,
      enableLogging: enableLogging ?? this.enableLogging,
      secure: secure ?? this.secure,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'serverConfig': serverConfig.toMap(),
      'projectConfig': projectConfig.toMap(),
      'webSocketConfig': webSocketConfig?.toMap(),
      'enableLogging': enableLogging,
      'secure': secure,
    };
  }

  factory MqttConfig.fromMap(Map<String, dynamic> map) {
    return MqttConfig(
      serverConfig: ServerConfig.fromMap(
        map['serverConfig'] as Map<String, dynamic>,
      ),
      projectConfig: ProjectConfig.fromMap(
        map['projectConfig'] as Map<String, dynamic>,
      ),
      webSocketConfig: map['webSocketConfig'] != null
          ? WebSocketConfig.fromMap(
              map['webSocketConfig'] as Map<String, dynamic>,
            )
          : null,
      enableLogging: map['enableLogging'] as bool,
      secure: map['secure'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory MqttConfig.fromJson(String source) => MqttConfig.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() {
    return 'MqttConfig(serverConfig: $serverConfig, projectConfig: $projectConfig, webSocketConfig: $webSocketConfig, enableLogging: $enableLogging, secure: $secure)';
  }

  @override
  bool operator ==(covariant MqttConfig other) {
    if (identical(this, other)) return true;

    return other.serverConfig == serverConfig &&
        other.projectConfig == projectConfig &&
        other.webSocketConfig == webSocketConfig &&
        other.enableLogging == enableLogging &&
        other.secure == secure;
  }

  @override
  int get hashCode {
    return serverConfig.hashCode ^
        projectConfig.hashCode ^
        webSocketConfig.hashCode ^
        enableLogging.hashCode ^
        secure.hashCode;
  }
}
