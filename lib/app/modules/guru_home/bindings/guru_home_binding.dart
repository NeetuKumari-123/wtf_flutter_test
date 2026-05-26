import 'package:get/get.dart';
import '../controllers/guru_home_controller.dart';

class GuruHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GuruHomeController>(
      () => GuruHomeController(),
    );
  }
}
