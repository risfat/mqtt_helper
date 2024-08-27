import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const String route = '/home';

  @override
  Widget build(BuildContext context) =>
      GetBuilder<HomeController>(builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(AppConstants.appName),
            centerTitle: true,
            elevation: Dimens.five,
            actions: const [
              IconButton(
                onPressed: RouteManagement.goToAddBroker,
                icon: Icon(Icons.add),
              )
            ],
          ),
          body: controller.brokers.isEmpty
              ? emptyBrokerWidget()
              : ListView(
                  controller: controller.scrollController,
                  padding: Dimens.edgeInsets20,
                  children: [
                    const SelectBrokerWidget(),
                    Dimens.boxHeight24,
                    const BorkerInfoWidget(),
                    Dimens.boxHeight20,
                    const MqttButtonsWidet(),
                    Dimens.boxHeight20,
                    const MessagesWidget()
                  ],
                ),
        );
      });

  Widget emptyBrokerWidget() {
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimens.ten),
          color: ColorsValue.primaryColorLight.withOpacity(.4),
        ),
        child: TextButton(
          onPressed: RouteManagement.goToAddBroker,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add,
                color: ColorsValue.blackColor,
                size: Dimens.thirty,
              ),
              Text(
                'Please add your MQTT broker',
                style: Styles.black16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
