import 'dart:convert';

class ProjectConfig {
  final String deviceId;
  final String userIdentifier;
  final String username;
  final String password;
  ProjectConfig({
    required this.deviceId,
    required this.userIdentifier,
    required this.username,
    required this.password,
  });

  ProjectConfig copyWith({
    String? deviceId,
    String? userIdentifier,
    String? username,
    String? password,
  }) {
    return ProjectConfig(
      deviceId: deviceId ?? this.deviceId,
      userIdentifier: userIdentifier ?? this.userIdentifier,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'deviceId': deviceId,
      'userIdentifier': userIdentifier,
      'username': username,
      'password': password,
    };
  }

  factory ProjectConfig.fromMap(Map<String, dynamic> map) {
    return ProjectConfig(
      deviceId: map['deviceId'] as String,
      userIdentifier: map['userIdentifier'] as String,
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectConfig.fromJson(String source) =>
      ProjectConfig.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProjectConfig(deviceId: $deviceId, userIdentifier: $userIdentifier, username: $username, password: $password)';
  }

  @override
  bool operator ==(covariant ProjectConfig other) {
    if (identical(this, other)) return true;

    return other.deviceId == deviceId &&
        other.userIdentifier == userIdentifier &&
        other.username == username &&
        other.password == password;
  }

  @override
  int get hashCode {
    return deviceId.hashCode ^
        userIdentifier.hashCode ^
        username.hashCode ^
        password.hashCode;
  }
}
