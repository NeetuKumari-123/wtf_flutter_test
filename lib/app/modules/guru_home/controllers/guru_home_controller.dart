import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../routes/app_pages.dart';

class GuruHomeController extends GetxController {
  final RxString clientName = 'DK'.obs;
  final RxString assignedTrainer = 'Aarav'.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final box = Hive.box('app_state');
      clientName.value = box.get('guru_name', defaultValue: 'DK') as String;
      assignedTrainer.value = box.get('guru_trainer', defaultValue: 'Aarav') as String;
    } catch (e) {
      // Use defaults if persistence fails
    }
  }

  Future<void> logOut() async {
    try {
      final box = Hive.box('app_state');
      await box.delete('guru_onboarding_completed');
      await box.delete('guru_profile_created');
      
      Get.snackbar(
        'Logged Out',
        'Your profile session has been cleared. Onboarding will show again.',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAllNamed(Routes.ROLE_SELECTION);
    } catch (e) {
      Get.offAllNamed(Routes.ROLE_SELECTION);
    }
  }
}
