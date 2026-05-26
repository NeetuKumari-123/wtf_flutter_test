import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../routes/app_pages.dart';

class TrainerHomeController extends GetxController {
  final RxString trainerName = 'Aarav (Lead Trainer)'.obs;

  @override
  void onInit() {
    super.onInit();
    loadTrainerProfile();
  }

  Future<void> loadTrainerProfile() async {
    try {
      final box = Hive.box('app_state');
      trainerName.value = box.get('trainer_name', defaultValue: 'Aarav (Lead Trainer)') as String;
    } catch (e) {
      // Use defaults if persistence fails
    }
  }

  Future<void> logOut() async {
    try {
      final box = Hive.box('app_state');
      await box.delete('trainer_logged_in');

      Get.snackbar(
        'Logged Out',
        'Trainer session has been cleared. Login will show again on next run.',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAllNamed(Routes.ROLE_SELECTION);
    } catch (e) {
      Get.offAllNamed(Routes.ROLE_SELECTION);
    }
  }
}
