import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectBrokerWidget extends StatelessWidget {
  const SelectBrokerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorsValue.blackColor,
        ),
        borderRadius: BorderRadius.circular(Dimens.twenty),
      ),
      child: TextButton.icon(
        iconAlignment: IconAlignment.end,
        onPressed: () {
          Utility.openBottomSheet(
            _BrokersWidget(),
          );
        },
        label: Text(
          'Select Any Broker',
          style: Styles.black14,
        ),
        icon: Icon(
          Icons.arrow_drop_down_outlined,
          size: Dimens.thirty,
        ),
      ),
    );
  }
}

class _BrokersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 25,
            child: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.close_rounded),
            ),
          ),
          Dimens.boxHeight10,
          Container(
            width: Dimens.percentWidth(1),
            constraints: BoxConstraints(
              maxHeight: Dimens.percentHeight(.8),
            ),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimens.twenty),
              color: ColorsValue.whiteColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Dimens.boxHeight10,
                Text(
                  'Popular Brokers for MQTT Testing',
                  style: Styles.black16,
                ),
                ListView.separated(
                  padding: Dimens.edgeInsets10,
                  shrinkWrap: true,
                  itemCount: controller.brokers.length,
                  itemBuilder: (_, index) {
                    final broker = controller.brokers[index];
                    return InkWell(
                      onTap: () async {
                        if (controller.mqttController.isMqttConnected) {
                          await Utility.showAlertDialog(
                            title: 'Info',
                            message:
                                'Your MQTT already Connected so. Do you can to disconnect mqtt connection',
                            onPress: () {
                              controller.mqttController.disconnect();
                            },
                          );
                        }
                        controller.selectedBroker = broker;
                        controller.brokerTEC.text =
                            controller.selectedBroker?.brokerName ?? '';
                        controller.portTEC.text =
                            controller.selectedBroker?.portNumber ?? '';
                        controller.topicTEC.text =
                            controller.selectedBroker?.topics.first.topic ?? '';
                        controller.update();
                        Get.back();
                      },
                      child: BrokerCard(
                        broker: broker,
                      ),
                    );
                  },
                  separatorBuilder: (_, index) => Dimens.boxHeight10,
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
