import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopicWidget extends StatelessWidget {
  const TopicWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Dialog(
        child: SizedBox(
          height: Dimens.percentHeight(.3),
          child: ListView(
            padding: Dimens.edgeInsets10,
            children: List.generate(
              controller.selectedBroker?.topics.length ?? 0,
              (index) {
                final topic = controller.selectedBroker?.topics[index];
                return TextButton(
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                  onPressed: () {
                    controller.topicTEC.text = topic?.topic ?? '';

                    controller.update();
                    Get.back();
                    final brokerKey =
                        '${controller.selectedBroker?.brokerName ?? ''}${controller.selectedBroker?.portNumber ?? ''}';
                    controller.getMessages(
                        topic: controller.topicTEC.text, brokerKey: brokerKey);
                  },
                  child: Text(
                    '${index + 1} : ${topic?.topic ?? ''}',
                    style: Styles.black16,
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }
}
