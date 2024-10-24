import 'dart:convert';

import 'package:example/main.dart';
import 'package:flutter/foundation.dart';

class TopicModel {
  final String topic;
  final List<MessageModel> messages;
  TopicModel({
    required this.topic,
    required this.messages,
  });

  TopicModel copyWith({
    String? topic,
    List<MessageModel>? messages,
  }) {
    return TopicModel(
      topic: topic ?? this.topic,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'topic': topic,
      'messages': messages.map((x) => x.toMap()).toList(),
    };
  }

  factory TopicModel.fromMap(Map<String, dynamic> map) {
    return TopicModel(
      topic: map['topic'] as String,
      messages: List<MessageModel>.from(
        (map['messages'] as List).map<MessageModel>(
          (x) => MessageModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory TopicModel.fromJson(String source) =>
      TopicModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TopicModel(topic: $topic, messages: $messages)';

  @override
  bool operator ==(covariant TopicModel other) {
    if (identical(this, other)) return true;

    return other.topic == topic && listEquals(other.messages, messages);
  }

  @override
  int get hashCode => topic.hashCode ^ messages.hashCode;
}
