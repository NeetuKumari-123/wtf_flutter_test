import 'package:get/get.dart';

import '../controllers/trainer_requests_controller.dart';

class TrainerRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrainerRequestsController>(
      () => TrainerRequestsController(),
    );
  }
}
