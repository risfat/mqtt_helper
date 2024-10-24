import 'dart:convert';

class MessageModel {
  final String message;
  final bool sendByMe;
  MessageModel({
    required this.message,
    required this.sendByMe,
  });

  MessageModel copyWith({
    String? message,
    bool? sendByMe,
  }) {
    return MessageModel(
      message: message ?? this.message,
      sendByMe: sendByMe ?? this.sendByMe,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'sendByMe': sendByMe,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      message: map['message'] as String,
      sendByMe: map['sendByMe'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MessageModel(message: $message, sendByMe: $sendByMe)';

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;

    return other.message == message && other.sendByMe == sendByMe;
  }

  @override
  int get hashCode => message.hashCode ^ sendByMe.hashCode;
}
