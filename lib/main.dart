

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'nav.dart';

import 'screen/master.dart';
import 'init.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  Init().setupLogging();
  await GetStorage.init();
  runApp(
    GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.MASTER,
        // theme: appThemeData,
        defaultTransition: Transition.fade,
        initialBinding: MasterBinding(),
        getPages: AppPages.pages,
        home: MasterPage(),
    )
  );
}