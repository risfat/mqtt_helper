// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'models.dart';

class MqttConfig {
  final ServerConfig serverConfig;
  final ProjectConfig projectConfig;
  final String userId;
  final String? username;
  final String? password;

  MqttConfig({
    required this.serverConfig,
    required this.projectConfig,
    required this.userId,
    String? username,
    String? password,
  })  : username = username ?? '2${projectConfig.accountId}${projectConfig.projectId}',
        password = password ?? '${projectConfig.licenseKey}${projectConfig.keySetId}';

  MqttConfig copyWith({
    ServerConfig? serverConfig,
    ProjectConfig? projectConfig,
    String? userId,
    String? username,
    String? password,
  }) {
    return MqttConfig(
      serverConfig: serverConfig ?? this.serverConfig,
      projectConfig: projectConfig ?? this.projectConfig,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'serverConfig': serverConfig.toMap(),
      'projectConfig': projectConfig.toMap(),
      'userId': userId,
      'username': username,
      'password': password,
    };
  }

  factory MqttConfig.fromMap(Map<String, dynamic> map) {
    return MqttConfig(
      serverConfig: ServerConfig.fromMap(map['serverConfig'] as Map<String, dynamic>),
      projectConfig: ProjectConfig.fromMap(map['projectConfig'] as Map<String, dynamic>),
      userId: map['userId'] as String,
      username: map['username'] as String?,
      password: map['password'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory MqttConfig.fromJson(String source) => MqttConfig.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MqttConfig(serverConfig: $serverConfig, projectConfig: $projectConfig, userId: $userId, username: $username, password: $password)';
  }

  @override
  bool operator ==(covariant MqttConfig other) {
    if (identical(this, other)) return true;

    return other.serverConfig == serverConfig &&
        other.projectConfig == projectConfig &&
        other.userId == userId &&
        other.username == username &&
        other.password == password;
  }

  @override
  int get hashCode {
    return serverConfig.hashCode ^ projectConfig.hashCode ^ userId.hashCode ^ username.hashCode ^ password.hashCode;
  }
}
