import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BorkerInfoWidget extends StatelessWidget {
  const BorkerInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Broker Name'),
          FormFieldWidget(
            contentPadding: Dimens.edgeInsets10,
            isReadOnly: true,
            textEditingController: controller.brokerTEC,
            onChange: (value) {},
            textInputAction: TextInputAction.next,
            textInputType: TextInputType.text,
            formBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimens.ten),
            ),
          ),
          Dimens.boxHeight10,
          const Text('Port Number'),
          FormFieldWidget(
            contentPadding: Dimens.edgeInsets10,
            isReadOnly: true,
            textEditingController: controller.portTEC,
            onChange: (value) {},
            textInputAction: TextInputAction.next,
            textInputType: TextInputType.number,
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
                  isReadOnly: true,
                  contentPadding: Dimens.edgeInsets10,
                  textEditingController: controller.topicTEC,
                  onChange: (value) {},
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.number,
                  formBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimens.ten),
                  ),
                ),
              ),
              Dimens.boxWidth10,
              CircleAvatar(
                radius: 25,
                child: IconButton(
                  onPressed: () async {
                    await Get.dialog(const TopicWidget());
                  },
                  icon: const Icon(Icons.expand_more_outlined),
                ),
              )
            ],
          ),
        ],
      );
    });
  }
}
