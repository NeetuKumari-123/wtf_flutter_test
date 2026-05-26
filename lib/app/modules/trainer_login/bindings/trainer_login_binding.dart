import 'package:get/get.dart';
import '../controllers/trainer_login_controller.dart';

class TrainerLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrainerLoginController>(
      () => TrainerLoginController(),
    );
  }
}
