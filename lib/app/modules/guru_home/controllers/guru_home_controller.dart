import 'dart:async';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../routes/app_pages.dart';
import '../../../models/call_request.dart';

class GuruHomeController extends GetxController {
  final RxString clientName = 'DK'.obs;
  final RxString assignedTrainer = 'Aarav'.obs;
  final RxList<CallRequest> callRequests = <CallRequest>[].obs;

  late final Box _box;
  StreamSubscription? _boxSubscription;

  @override
  void onInit() {
    super.onInit();
    _box = Hive.box('app_state');
    loadProfile();
    loadCallRequests();

    // Listen to call requests changes reactively
    _boxSubscription = _box.watch(key: 'call_requests').listen((event) {
      loadCallRequests();
    });
  }

  @override
  void onClose() {
    _boxSubscription?.cancel();
    super.onClose();
  }

  Future<void> loadProfile() async {
    try {
      clientName.value = _box.get('guru_name', defaultValue: 'DK') as String;
      assignedTrainer.value = _box.get('guru_trainer', defaultValue: 'Aarav') as String;
      // Reload call requests when profile loads to make sure name filter is aligned
      loadCallRequests();
    } catch (e) {
      // Use defaults if persistence fails
    }
  }

  void loadCallRequests() {
    try {
      final rawRequests = _box.get('call_requests', defaultValue: []);
      final List<CallRequest> requests = [];
      for (var r in rawRequests) {
        if (r is Map) {
          final req = CallRequest.fromMap(r);
          // Filter requests belonging to this client
          if (req.memberId == clientName.value) {
            requests.add(req);
          }
        }
      }
      // Sort requests by slot time (soonest first)
      requests.sort((a, b) => a.slot.compareTo(b.slot));
      callRequests.value = requests;
    } catch (e) {
      callRequests.clear();
    }
  }

  Future<void> logOut() async {
    try {
      await _box.delete('guru_onboarding_completed');
      await _box.delete('guru_profile_created');
      
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
