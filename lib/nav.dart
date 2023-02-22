

import 'package:get/get.dart';

import 'screen/master.dart';

abstract class AppPages {
  static final pages = [
  GetPage(
    name: Routes.MASTER,page: () => MasterPage(),
  )
  ];
}

abstract class Routes {
  static const MASTER = '/';
}
