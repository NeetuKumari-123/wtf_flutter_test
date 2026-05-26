import 'package:get/get.dart';

import '../controllers/call_request_controller.dart';

class CallRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallRequestController>(
      () => CallRequestController(),
    );
  }
}
