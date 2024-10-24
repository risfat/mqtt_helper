import 'dart:convert';

import 'models.dart';

/// Represents a configuration for an MQTT connection.
class MqttConfig {
  /// The server configuration.
  final ServerConfig serverConfig;

  /// The project configuration.
  final ProjectConfig projectConfig;

  /// The WebSocket configuration, optional.
  final WebSocketConfig? webSocketConfig;

  /// Whether to enable logging, default is `true`.
  final bool enableLogging;

  /// Whether to use a secure connection, default is `false`.
  final bool secure;

  /// Creates a new `MqttConfig` instance with the given configurations and settings.
  MqttConfig({
    required this.serverConfig,
    required this.projectConfig,
    this.webSocketConfig,
    this.enableLogging = true,
    this.secure = false,
  });

  /// Creates a copy of the current `MqttConfig` instance with optional changes.
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

  /// Converts the `MqttConfig` instance to a map.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'serverConfig': serverConfig.toMap(),
      'projectConfig': projectConfig.toMap(),
      'webSocketConfig': webSocketConfig?.toMap(),
      'enableLogging': enableLogging,
      'secure': secure,
    };
  }

  /// Creates an `MqttConfig` instance from a map.
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

  /// Converts the `MqttConfig` instance to a JSON string.
  String toJson() => json.encode(toMap());

  /// Creates an `MqttConfig` instance from a JSON string.
  factory MqttConfig.fromJson(String source) => MqttConfig.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  /// Returns a string representation of the `MqttConfig` instance.
  @override
  String toString() {
    return 'MqttConfig(serverConfig: $serverConfig, projectConfig: $projectConfig, webSocketConfig: $webSocketConfig, enableLogging: $enableLogging, secure: $secure)';
  }

  /// Compares two `MqttConfig` instances for equality.
  @override
  bool operator ==(covariant MqttConfig other) {
    if (identical(this, other)) return true;

    return other.serverConfig == serverConfig &&
        other.projectConfig == projectConfig &&
        other.webSocketConfig == webSocketConfig &&
        other.enableLogging == enableLogging &&
        other.secure == secure;
  }

  /// Returns the hash code of the `MqttConfig` instance.
  @override
  int get hashCode {
    return serverConfig.hashCode ^
        projectConfig.hashCode ^
        webSocketConfig.hashCode ^
        enableLogging.hashCode ^
        secure.hashCode;
  }
}
