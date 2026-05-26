import 'package:get/get.dart';

import '../controllers/session_logs_controller.dart';

class SessionLogsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SessionLogsController>(() => SessionLogsController());
  }
}
