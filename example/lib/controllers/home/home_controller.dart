import 'package:example/main.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mqtt_helper/mqtt_helper.dart';

class HomeController extends GetxController {
  final scrollController = ScrollController();

  var addBrokerTEC = TextEditingController();

  var addPortTEC = TextEditingController();

  var addTopicTEC = TextEditingController();

  var brokerTEC = TextEditingController();

  var portTEC = TextEditingController();

  var topicTEC = TextEditingController();

  var messageTEC = TextEditingController();

  final secureStorage = const FlutterSecureStorageManager();

  List<String> newTopics = [];

  List<MessageModel> messages = [];

  List<BrokerModel> brokers = [];

  BrokerModel? selectedBroker;

  late String userIdentifier;

  MqttController get mqttController {
    return Get.find<MqttController>();
  }

  @override
  void onInit() {
    super.onInit();
    LocalNoticeService().setup;
    startInit();
  }

  void startInit() async {
    await getUserIdentifier();
    if (!Get.isRegistered<MqttController>()) {
      MqttBinding().dependencies();
    }
    await getBrokers();
  }

  Future<void> getUserIdentifier() async {
    final secureUserIdentifier =
        await secureStorage.getSecuredValue(LocalKeys.userIdentifier);
    if (secureUserIdentifier.trim().isNotEmpty) {
      userIdentifier = secureUserIdentifier;
    } else {
      userIdentifier = 'flutter-client${DateTime.now().millisecondsSinceEpoch}';
      await secureStorage.saveValueSecurely(
          LocalKeys.userIdentifier, userIdentifier);
    }
  }

  Future<void> addBroker(BrokerModel brokerData) async {
    final allBrokers = await secureStorage.getAllSecuredValue();
    allBrokers.removeWhere((key, value) => key == LocalKeys.userIdentifier);
    final brokerDataKey = '${brokerData.brokerName}${brokerData.portNumber}';
    if (allBrokers.isEmpty) {
      secureStorage.saveValueSecurely(brokerDataKey, brokerData.toJson());
    } else {
      final allBrokersList = allBrokers.keys.toList();
      if (!allBrokersList.contains(brokerDataKey)) {
        secureStorage.saveValueSecurely(brokerDataKey, brokerData.toJson());
      } else {
        Utility.showInfoDialog(
          'This borker already exists',
        );
      }
    }
    addBrokerTEC.clear();
    addPortTEC.clear();
    addTopicTEC.clear();
    newTopics.clear();
    await getBrokers();
  }

  Future<void> getBrokers() async {
    final allBrokers = await secureStorage.getAllSecuredValue();
    allBrokers.removeWhere((key, value) => key == LocalKeys.userIdentifier);
    brokers = allBrokers.values.map((e) => BrokerModel.fromJson(e)).toList();
    update();
  }

  void removeBroker(BrokerModel brokerData) async {
    final brokerDataKey = '${brokerData.brokerName}${brokerData.portNumber}';
    await secureStorage.deleteSecuredValue(brokerDataKey);
    await getBrokers();
  }

  void sendMessage() {
    if (!mqttController.isMqttConnected) {
      Utility.showInfoDialog('MQTT is not Connected', false, 'INFO');
      return;
    }

    if (messageTEC.text.isNotEmpty) {
      final message = MqttEventModel(
        userIdentifier: userIdentifier,
        payload: messageTEC.text,
      );
      mqttController.publishMessage(
          message: message.toJson(), pubTopic: topicTEC.text);
      messageTEC.clear();
      update();
      Utility.hideKeyboard();
    } else {
      Utility.showInfoDialog('Please type message before send', false, 'INFO');
    }
  }

  void updateMessage(EventModel event) async {
    if (event.topic == topicTEC.text) {
      final messageModel = MqttEventModel.fromMap(event.payload);
      if (messageModel.userIdentifier != userIdentifier) {
        LocalNoticeService().showFlutterNotification(
          messageModel.userIdentifier,
          messageModel.payload,
        );
      }
      final message = MessageModel(
          message: messageModel.payload,
          sendByMe: messageModel.userIdentifier == userIdentifier);
      final brokerKey =
          '${selectedBroker?.brokerName ?? ''}${selectedBroker?.portNumber ?? ''}';
      final broker = await secureStorage.getSecuredValue(brokerKey);
      if (broker.isNotEmpty) {
        final currentBroker = BrokerModel.fromJson(broker);
        final topic = currentBroker.topics
            .where((e) => e.topic == event.topic)
            .toList()
            .first;
        topic.messages.add(message);
        final topicIndex =
            currentBroker.topics.indexWhere((e) => e.topic == topic.topic);
        currentBroker.topics[topicIndex] = topic;
        await secureStorage.saveValueSecurely(
            brokerKey, currentBroker.toJson());
      }
      await getMessages(topic: event.topic, brokerKey: brokerKey);
    }
  }

  Future<void> getMessages(
      {required String topic, required String brokerKey}) async {
    final broker = await secureStorage.getSecuredValue(brokerKey);
    if (broker.isNotEmpty) {
      final currentBroker = BrokerModel.fromJson(broker);
      final localTopic =
          currentBroker.topics.where((e) => e.topic == topic).toList().first;
      messages = localTopic.messages;
      update();
    }
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.bounceIn);
  }
}
