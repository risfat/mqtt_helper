import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'utils/utils.dart';

export 'controllers/controllers.dart';
export 'data/data.dart';
export 'models/models.dart';
export 'res/res.dart';
export 'utils/utils.dart';
export 'views/views.dart';
export 'widgets/widgets.dart';

void main() async {
  await _setup();
  runApp(const MyApp());
}

Future<void> _setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(DeviceConfig()).init();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) => child!,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: Utility.hideKeyboard,
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.dark,
            theme: ThemeData(primaryColor: Colors.purple),
            initialRoute: AppPages.initial,
            getPages: AppPages.pages,
          ),
        ),
      );
}
