A wrapper package for mqtt_client that provides a simpler and more intuitive API for working with MQTT in Flutter.

## Features

- Wrapper class covering everything for [mqtt_client](https://pub.dev/packages/mqtt_client)
- Provides listeners on events and other callbacks for `mqtt_client`
- Simplifies the usage of `mqtt_client` with a wrapper class
  - Provides listeners for connection changes and events
  - Supports subscribing and unsubscribing to single or multiple topics
  - Allows publishing messages to MQTT topics

## Getting started

Add it to your `pubspec.yaml`

```yaml
dependencies:
  mqtt_helper: <latest-version>
```

## Usage

1. Create one instance of the helper class `MqttHelper`

```dart
var helper = MqttHelper();
```

2. Initialize and Connect to the MqttClient with the helper

```dart
var config = MqttConfig(); // You'll need to pass your creds and configs inside MqttConfig
helper.initialize(config);
```

## Additional Information

### Listeners

- Use `onConnectionChange()` listener to listen to connection changes whether Mqtt is connected or not
- Use `onEvent()` listener to listen to events that will come.

### Subscribing and Unsubscribing

- Use `subscribeTopic()` to subscribe to single topic.
- Use `subscribeTopics()` to subscribe to multiple topics at once.
- Use `unsubscribeTopic()` to unsubscribe to single topic.
- Use `unsubscribeTopics()` to unsubscribe to multiple topics at once.

### Publishing

- Use `publishMessage()` to publish a message to a topic.
