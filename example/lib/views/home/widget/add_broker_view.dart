import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddBrokerView extends StatelessWidget {
  const AddBrokerView({super.key});

  static const String route = '/add-broker-view';

  @override
  Widget build(BuildContext context) => GetBuilder<HomeController>(
        initState: (state) async {
          final controller = Get.find<HomeController>();
          Utility.updateLater(() async {
            controller.addBrokerTEC.clear();
            controller.addPortTEC.clear();
            controller.addTopicTEC.clear();
            controller.newTopics.clear();
            await controller.getBrokers();
          });
        },
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add and Remove Broker'),
              centerTitle: true,
              elevation: Dimens.five,
            ),
            body: ListView(
              padding: Dimens.edgeInsets20,
              children: [
                const Text('Broker Name'),
                FormFieldWidget(
                  contentPadding: Dimens.edgeInsets10,
                  textEditingController: controller.addBrokerTEC,
                  onChange: (value) {},
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.text,
                  hintText: 'Add  broker name',
                  formBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimens.ten),
                  ),
                ),
                Dimens.boxHeight10,
                const Text('Port Number'),
                FormFieldWidget(
                  contentPadding: Dimens.edgeInsets10,
                  textEditingController: controller.addPortTEC,
                  onChange: (value) {},
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.number,
                  hintText: 'Add port number',
                  formBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimens.ten),
                  ),
                ),
                Dimens.boxHeight10,
                const Text('Topic Name'),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: FormFieldWidget(
                        contentPadding: Dimens.edgeInsets10,
                        textEditingController: controller.addTopicTEC,
                        onChange: (value) {},
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.text,
                        hintText: 'Add topic name',
                        formBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Dimens.ten),
                        ),
                      ),
                    ),
                    Dimens.boxWidth10,
                    CircleAvatar(
                      radius: 25,
                      child: IconButton(
                        onPressed: () {
                          controller.newTopics.add(controller.addTopicTEC.text);
                          controller.addTopicTEC.clear();
                          controller.update();
                        },
                        icon: const Icon(Icons.add),
                      ),
                    )
                  ],
                ),
                if (controller.newTopics.isNotEmpty) ...[
                  Dimens.boxHeight10,
                  ...List.generate(
                    controller.newTopics.length,
                    (index) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${index + 1} : ${controller.newTopics[index]}',
                          style: Styles.black16,
                        ),
                        IconButton(
                            onPressed: () {
                              controller.newTopics.removeAt(index);
                              controller.update();
                            },
                            icon: const Icon(Icons.delete_forever_outlined))
                      ],
                    ),
                  )
                ],
                Dimens.boxHeight20,
                Button(
                  label: 'Add Broker',
                  onTap: () {
                    if (controller.addBrokerTEC.text.isNotEmpty &&
                        controller.addPortTEC.text.isNotEmpty &&
                        (controller.newTopics.isNotEmpty ||
                            controller.addTopicTEC.text.isNotEmpty)) {
                      controller.newTopics.addAllIf(
                          controller.addTopicTEC.text.isNotEmpty,
                          [controller.addTopicTEC.text]);
                      final brokerData = BrokerModel(
                        brokerName: controller.addBrokerTEC.text,
                        portNumber: controller.addPortTEC.text,
                        topics: controller.newTopics
                            .map((e) => TopicModel(topic: e, messages: []))
                            .toList(),
                      );
                      controller.addBroker(brokerData);
                    } else {
                      Utility.showAlertDialog(
                        title: 'Info',
                        message: 'Please fill all filed',
                        onPress: Get.back,
                      );
                    }
                    Utility.hideKeyboard();
                  },
                ),
                Dimens.boxHeight32,
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.brokers.length,
                  itemBuilder: (_, index) {
                    final broker = controller.brokers[index];
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        BrokerCard(
                          broker: broker,
                        ),
                        CircleAvatar(
                          radius: 20,
                          child: IconButton(
                            onPressed: () {
                              controller.removeBroker(broker);
                            },
                            icon: const Icon(Icons.delete_forever_rounded),
                          ),
                        )
                      ],
                    );
                  },
                  separatorBuilder: (_, index) => Dimens.boxHeight10,
                )
              ],
            ),
          );
        },
      );
}
