import 'package:get/get.dart';
import '../controllers/trainer_home_controller.dart';

class TrainerHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrainerHomeController>(
      () => TrainerHomeController(),
    );
  }
}
