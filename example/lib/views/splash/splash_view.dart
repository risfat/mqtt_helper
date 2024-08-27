import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  static const String route = '/splash';

  @override
  Widget build(BuildContext context) =>
      GetBuilder<SplashController>(builder: (context) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlutterLogo(
                  size: Dimens.fifty,
                ),
                Dimens.boxHeight32,
                Text(
                  'Flutter MQTT',
                  style: Styles.white16,
                ),
              ],
            ),
          ),
        );
      });
}
