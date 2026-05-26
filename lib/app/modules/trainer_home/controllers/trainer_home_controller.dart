import 'dart:async';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../routes/app_pages.dart';

class TrainerHomeController extends GetxController {
  final RxString trainerName = 'Aarav (Lead Trainer)'.obs;
  final RxInt unreadChats = 0.obs;
  
  StreamSubscription? _boxSubscription;

  @override
  void onInit() {
    super.onInit();
    loadTrainerProfile();
    calculateUnreadChats();
    
    // Listen to messages change reactively
    final box = Hive.box('app_state');
    _boxSubscription = box.watch(key: 'messages').listen((event) {
      calculateUnreadChats();
    });
  }

  @override
  void onClose() {
    _boxSubscription?.cancel();
    super.onClose();
  }

  Future<void> loadTrainerProfile() async {
    try {
      final box = Hive.box('app_state');
      trainerName.value = box.get('trainer_name', defaultValue: 'Aarav (Lead Trainer)') as String;
    } catch (e) {
      // Use defaults if persistence fails
    }
  }

  void calculateUnreadChats() {
    try {
      final box = Hive.box('app_state');
      final rawMsgs = box.get('messages', defaultValue: []);
      int count = 0;
      for (var m in rawMsgs) {
        if (m is Map && m['sender'] == 'member' && m['status'] == 'sent') {
          count++;
        }
      }
      unreadChats.value = count;
    } catch (e) {
      unreadChats.value = 0;
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
