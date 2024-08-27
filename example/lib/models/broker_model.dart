import 'dart:convert';

import 'package:example/main.dart';
import 'package:flutter/foundation.dart';

class BrokerModel {
  final String brokerName;
  final String portNumber;
  final List<TopicModel> topics;
  BrokerModel({
    required this.brokerName,
    required this.portNumber,
    required this.topics,
  });

  BrokerModel copyWith({
    String? brokerName,
    String? portNumber,
    List<TopicModel>? topics,
  }) {
    return BrokerModel(
      brokerName: brokerName ?? this.brokerName,
      portNumber: portNumber ?? this.portNumber,
      topics: topics ?? this.topics,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'brokerName': brokerName,
      'portNumber': portNumber,
      'topics': topics.map((x) => x.toMap()).toList(),
    };
  }

  factory BrokerModel.fromMap(Map<String, dynamic> map) {
    return BrokerModel(
      brokerName: map['brokerName'] as String,
      portNumber: map['portNumber'] as String,
      topics: List<TopicModel>.from(
        (map['topics'] as List).map<TopicModel>(
          (x) => TopicModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BrokerModel.fromJson(String source) =>
      BrokerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'BrokerModel(brokerName: $brokerName, portNumber: $portNumber, topics: $topics)';

  @override
  bool operator ==(covariant BrokerModel other) {
    if (identical(this, other)) return true;

    return other.brokerName == brokerName &&
        other.portNumber == portNumber &&
        listEquals(other.topics, topics);
  }

  @override
  int get hashCode =>
      brokerName.hashCode ^ portNumber.hashCode ^ topics.hashCode;
}
