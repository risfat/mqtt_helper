import 'dart:convert';

import 'package:flutter/foundation.dart';

class EventModel {
  final String topic;
  final Map<String, dynamic> payload;
  EventModel({
    required this.topic,
    required this.payload,
  });

  EventModel copyWith({
    String? topic,
    Map<String, dynamic>? payload,
  }) {
    return EventModel(
      topic: topic ?? this.topic,
      payload: payload ?? this.payload,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'topic': topic,
      'payload': payload,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      topic: map['topic'] as String,
      payload: (map['payload'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(
    String source,
  ) =>
      EventModel.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() => 'EventModel(topic: $topic, payload: $payload)';

  @override
  bool operator ==(covariant EventModel other) {
    if (identical(this, other)) return true;

    return other.topic == topic && mapEquals(other.payload, payload);
  }

  @override
  int get hashCode => topic.hashCode ^ payload.hashCode;
}
