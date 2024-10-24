import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagesWidget extends StatelessWidget {
  const MessagesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Messages : ',
            style: Styles.black16,
          ),
          Dimens.boxHeight20,
          if (controller.messages.isNotEmpty) ...[
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.messages.length,
              itemBuilder: (_, index) {
                final message = controller.messages[index];
                return Align(
                  alignment: message.sendByMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Text(
                    message.message,
                    style: Styles.black16,
                  ),
                );
              },
              separatorBuilder: (_, index) => Dimens.boxHeight10,
            )
          ]
        ],
      );
    });
  }
}
