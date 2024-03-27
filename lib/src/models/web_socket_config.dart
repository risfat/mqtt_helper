import 'dart:convert';

import 'package:flutter/foundation.dart';

class WebSocketConfig {
  final bool useWebsocket;
  final List<String> websocketProtocols;

  const WebSocketConfig({
    required this.useWebsocket,
    required this.websocketProtocols,
  }) : assert(!useWebsocket || (useWebsocket && websocketProtocols.length != 0),
            'if useWebsocket is set to true, the websocket protocols must be specified');

  WebSocketConfig copyWith({
    bool? useWebsocket,
    List<String>? websocketProtocols,
  }) {
    return WebSocketConfig(
      useWebsocket: useWebsocket ?? this.useWebsocket,
      websocketProtocols: websocketProtocols ?? this.websocketProtocols,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'useWebsocket': useWebsocket,
      'websocketProtocols': websocketProtocols,
    };
  }

  factory WebSocketConfig.fromMap(Map<String, dynamic> map) {
    return WebSocketConfig(
      useWebsocket: map['useWebsocket'] as bool,
      websocketProtocols: (map['websocketProtocols'] as List).cast(),
    );
  }

  String toJson() => json.encode(toMap());

  factory WebSocketConfig.fromJson(String source) => WebSocketConfig.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'WebSocketConfig(useWebsocket: $useWebsocket, websocketProtocols: $websocketProtocols)';

  @override
  bool operator ==(covariant WebSocketConfig other) {
    if (identical(this, other)) return true;

    return other.useWebsocket == useWebsocket && listEquals(other.websocketProtocols, websocketProtocols);
  }

  @override
  int get hashCode => useWebsocket.hashCode ^ websocketProtocols.hashCode;
}
