import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../routes/app_pages.dart';

class RoleSelectionController extends GetxController {
  final RxBool isLoading = false.obs;

  Future<void> selectGuruRole() async {
    isLoading.value = true;
    try {
      final box = Hive.box('app_state');
      final hasCompletedOnboarding = box.get('guru_onboarding_completed', defaultValue: false) as bool;
      final hasProfile = box.get('guru_profile_created', defaultValue: false) as bool;

      if (hasCompletedOnboarding && hasProfile) {
        Get.toNamed(Routes.GURU_HOME);
      } else {
        Get.toNamed(Routes.GURU_ONBOARDING);
      }
    } catch (e) {
      Get.toNamed(Routes.GURU_ONBOARDING);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectTrainerRole() async {
    isLoading.value = true;
    try {
      final box = Hive.box('app_state');
      final isTrainerLoggedIn = box.get('trainer_logged_in', defaultValue: false) as bool;

      if (isTrainerLoggedIn) {
        Get.toNamed(Routes.TRAINER_HOME);
      } else {
        Get.toNamed(Routes.TRAINER_LOGIN);
      }
    } catch (e) {
      Get.toNamed(Routes.TRAINER_LOGIN);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> clearAllData() async {
    try {
      final box = Hive.box('app_state');
      await box.clear();
      Get.snackbar(
        'App Reset',
        'All data, onboarding states, and login states have been cleared!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Could not clear data');
    }
  }
}
