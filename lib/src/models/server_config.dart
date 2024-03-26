import 'dart:convert';

class ServerConfig {
  const ServerConfig({
    required this.hostName,
    required this.port,
  });

  final String hostName;
  final int port;

  ServerConfig copyWith({
    String? hostName,
    int? port,
  }) {
    return ServerConfig(
      hostName: hostName ?? this.hostName,
      port: port ?? this.port,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'hostName': hostName,
      'port': port,
    };
  }

  factory ServerConfig.fromMap(Map<String, dynamic> map) {
    return ServerConfig(
      hostName: map['hostName'] as String,
      port: map['port'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ServerConfig.fromJson(String source) => ServerConfig.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ServerConfig(hostName: $hostName, port: $port)';

  @override
  bool operator ==(covariant ServerConfig other) {
    if (identical(this, other)) return true;

    return other.hostName == hostName && other.port == port;
  }

  @override
  int get hashCode => hostName.hashCode ^ port.hashCode;
}
