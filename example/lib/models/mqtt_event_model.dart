import 'dart:convert';

import 'package:example/utils/utils.dart';

class MqttEventModel {
  final String userIdentifier;
  final String payload;
  MqttEventModel({
    required this.userIdentifier,
    required this.payload,
  });

  MqttEventModel copyWith({
    String? userIdentifier,
    String? payload,
  }) {
    return MqttEventModel(
      userIdentifier: userIdentifier ?? this.userIdentifier,
      payload: payload ?? this.payload,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userIdentifier': userIdentifier,
      'payload': Utility.encodeString(payload),
    };
  }

  factory MqttEventModel.fromMap(Map<String, dynamic> map) {
    return MqttEventModel(
      userIdentifier: map['userIdentifier'] as String,
      payload: Utility.decodeString(map['payload'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory MqttEventModel.fromJson(String source) =>
      MqttEventModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'MqttEventModel(userIdentifier: $userIdentifier, payload: $payload)';

  @override
  bool operator ==(covariant MqttEventModel other) {
    if (identical(this, other)) return true;

    return other.userIdentifier == userIdentifier && other.payload == payload;
  }

  @override
  int get hashCode => userIdentifier.hashCode ^ payload.hashCode;
}
