import 'dart:convert';

import 'models.dart';

class MqttConfig {
  final ServerConfig serverConfig;
  final ProjectConfig projectConfig;
  final WebSocketConfig? webSocketConfig;
  final String userId;
  final String? username;
  final String? password;
  final bool enableLogging;
  final bool secure;

  MqttConfig({
    required this.serverConfig,
    required this.projectConfig,
    this.webSocketConfig,
    required this.userId,
    this.enableLogging = true,
    this.secure = false,
    String? username,
    String? password,
  })  : username = username ?? '2${projectConfig.accountId}${projectConfig.projectId}',
        password = password ?? '${projectConfig.licenseKey}${projectConfig.keySetId}';

  MqttConfig copyWith({
    ServerConfig? serverConfig,
    ProjectConfig? projectConfig,
    WebSocketConfig? webSocketConfig,
    String? userId,
    bool? enableLogging,
    bool? secure,
    String? username,
    String? password,
  }) {
    return MqttConfig(
      serverConfig: serverConfig ?? this.serverConfig,
      projectConfig: projectConfig ?? this.projectConfig,
      webSocketConfig: webSocketConfig ?? this.webSocketConfig,
      userId: userId ?? this.userId,
      enableLogging: enableLogging ?? this.enableLogging,
      secure: secure ?? this.secure,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'serverConfig': serverConfig.toMap(),
      'projectConfig': projectConfig.toMap(),
      'webSocketConfig': webSocketConfig?.toMap(),
      'userId': userId,
      'enableLogging': enableLogging,
      'secure': secure,
      'username': username,
      'password': password,
    };
  }

  factory MqttConfig.fromMap(Map<String, dynamic> map) {
    return MqttConfig(
      serverConfig: ServerConfig.fromMap(map['serverConfig'] as Map<String, dynamic>),
      projectConfig: ProjectConfig.fromMap(map['projectConfig'] as Map<String, dynamic>),
      webSocketConfig: map['webSocketConfig'] != null ? WebSocketConfig.fromMap(map['webSocketConfig'] as Map<String, dynamic>) : null,
      userId: map['userId'] as String,
      enableLogging: map['enableLogging'] as bool,
      secure: map['secure'] as bool,
      username: map['username'] as String?,
      password: map['password'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory MqttConfig.fromJson(String source) => MqttConfig.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MqttConfig(serverConfig: $serverConfig, projectConfig: $projectConfig, webSocketConfig: $webSocketConfig, userId: $userId, username: $username, password: $password, enableLogging: $enableLogging, secure: $secure)';
  }

  @override
  bool operator ==(covariant MqttConfig other) {
    if (identical(this, other)) return true;

    return other.serverConfig == serverConfig &&
        other.projectConfig == projectConfig &&
        other.webSocketConfig == webSocketConfig &&
        other.userId == userId &&
        other.username == username &&
        other.password == password &&
        other.enableLogging == enableLogging &&
        other.secure == secure;
  }

  @override
  int get hashCode {
    return serverConfig.hashCode ^
        projectConfig.hashCode ^
        webSocketConfig.hashCode ^
        userId.hashCode ^
        username.hashCode ^
        password.hashCode ^
        enableLogging.hashCode ^
        secure.hashCode;
  }
}
