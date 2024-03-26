<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

This package was initially created for internal use only, but can be used by anyone

## Features

- Wrapper class covering everything for [mqtt_client](https://pub.dev/packages/mqtt_client)
- Provides listeners on events and other callbacks for mqtt_client

## Getting started

Add it to your `pubspec.yaml`

```yaml
mqtt_helper: 0.0.1
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

1. Use `onConnectionChange()` listener to listen to connection changes whether Mqtt is connected or not
1. Use `onEvent()` listener to listen to events that will come.
1. Use `subscribeTopic()` to subscribe to single topic.
1. Use `subscribeTopics()` to subscribe to multiple topics at once.
1. Use `unsubscribeTopic()` to unsubscribe to single topic.
1. Use `unsubscribeTopics()` to unsubscribe to multiple topics at once.
