import 'package:get/get.dart';
import '../controllers/guru_onboarding_controller.dart';

class GuruOnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GuruOnboardingController>(
      () => GuruOnboardingController(),
    );
  }
}
