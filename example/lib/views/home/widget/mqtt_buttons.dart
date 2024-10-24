import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MqttButtonsWidet extends StatelessWidget {
  const MqttButtonsWidet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return SizedBox(
        width: Dimens.percentWidth(1),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Button(
                  label: 'Connect',
                  onTap: () {
                    if (controller.selectedBroker == null) {
                      Utility.showInfoDialog(
                          'Please select at least one MQTT Broker ',
                          false,
                          'INFO');
                      return;
                    }
                    if (!controller.mqttController.isMqttConnected) {
                      try {
                        controller.mqttController.setup(
                          broker: controller.selectedBroker!,
                          userIdentifier: controller.userIdentifier,
                        );
                      } catch (e) {
                        Utility.showInfoDialog(
                          StringConstants.somethingWentWrong,
                        );
                      }
                    } else {
                      Utility.showInfoDialog(
                          'MQTT is already Connected', false, 'INFO');
                    }
                  },
                  width: Dimens.percentWidth(.4),
                  backgroundColor: ColorsValue.greenColor,
                ),
                Button(
                  label: 'Disconnect',
                  onTap: () {
                    if (controller.mqttController.isMqttConnected) {
                      controller.mqttController.disconnect();
                    } else {
                      Utility.showInfoDialog(
                          'MQTT is not Connected', false, 'INFO');
                    }
                  },
                  width: Dimens.percentWidth(.4),
                  backgroundColor: ColorsValue.redColor,
                ),
              ],
            ),
            Dimens.boxHeight20,
            FormFieldWidget(
              contentPadding: Dimens.edgeInsets10,
              textEditingController: controller.messageTEC,
              onChange: (value) {},
              textInputAction: TextInputAction.next,
              textInputType: TextInputType.text,
              hintText: 'Type message here',
              formBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.ten),
              ),
              suffixIcon: IconButton(
                onPressed: () async {
                  controller.sendMessage();
                },
                icon: const Icon(Icons.send_rounded),
              ),
            ),
          ],
        ),
      );
    });
  }
}
