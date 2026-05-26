import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../models/call_request.dart';

class CallRequestController extends GetxController {
  final TextEditingController noteController = TextEditingController();
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final Rxn<DateTime> selectedSlot = Rxn<DateTime>();

  final RxList<DateTime> availableDates = <DateTime>[].obs;
  final RxList<CallRequest> existingRequests = <CallRequest>[].obs;

  late final Box _box;

  @override
  void onInit() {
    super.onInit();
    _box = Hive.box('app_state');
    _generateDates();
    loadExistingRequests();
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }

  void _generateDates() {
    final now = DateTime.now();
    // Generate today, tomorrow, and day after tomorrow
    availableDates.value = [
      DateTime(now.year, now.month, now.day),
      DateTime(now.year, now.month, now.day).add(const Duration(days: 1)),
      DateTime(now.year, now.month, now.day).add(const Duration(days: 2)),
    ];
    selectedDate.value = availableDates.first;
  }

  void loadExistingRequests() {
    try {
      final rawRequests = _box.get('call_requests', defaultValue: []);
      final List<CallRequest> requests = [];
      for (var r in rawRequests) {
        if (r is Map) {
          requests.add(CallRequest.fromMap(r));
        }
      }
      existingRequests.value = requests;
    } catch (e) {
      existingRequests.clear();
    }
  }

  List<DateTime> generateSlotsForDate(DateTime date) {
    final List<DateTime> slots = [];
    // 30-minute intervals from 9:00 AM to 9:00 PM (last slot starts at 8:30 PM)
    final startTime = DateTime(date.year, date.month, date.day, 9, 0);
    for (int i = 0; i < 24; i++) {
      slots.add(startTime.add(Duration(minutes: 30 * i)));
    }
    return slots;
  }

  bool isSlotInPast(DateTime slot) {
    return slot.isBefore(DateTime.now());
  }

  bool isSlotConflict(DateTime slot) {
    // Check if there is an approved request for the exact same slot time
    return existingRequests.any(
      (req) => req.status == 'approved' && req.slot.isAtSameMomentAs(slot),
    );
  }

  void selectSlot(DateTime slot) {
    selectedSlot.value = slot;
    update();
  }

  bool isSelectedSlot(DateTime slot) {
    return selectedSlot.value?.millisecondsSinceEpoch ==
        slot.millisecondsSinceEpoch;
  }

  Future<void> submitCallRequest() async {
    if (selectedSlot.value == null) {
      Get.snackbar(
        'Selection Required',
        'Please select a time slot for your call.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFEF2F2),
        colorText: const Color(0xFF991B1B),
      );
      return;
    }

    final slot = selectedSlot.value!;

    // Date/Time validation: cannot pick past
    if (isSlotInPast(slot)) {
      Get.snackbar(
        'Invalid Time',
        'Cannot schedule a call in the past. Please choose a future slot.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFEF2F2),
        colorText: const Color(0xFF991B1B),
      );
      return;
    }

    // Conflict check
    if (isSlotConflict(slot)) {
      Get.snackbar(
        'Slot Booked',
        'This slot has already been approved for another session. Please select another slot.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFEF2F2),
        colorText: const Color(0xFF991B1B),
      );
      return;
    }

    final note = noteController.text.trim();
    if (note.length > 140) {
      Get.snackbar(
        'Note Too Long',
        'Your note must be 140 characters or less.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFEF2F2),
        colorText: const Color(0xFF991B1B),
      );
      return;
    }

    try {
      final trainerId =
          _box.get('guru_trainer', defaultValue: 'Aarav') as String;
      final memberId = _box.get('guru_name', defaultValue: 'DK') as String;

      final newReq = CallRequest(
        id: 'req_${DateTime.now().millisecondsSinceEpoch}',
        memberId: memberId,
        trainerId: trainerId,
        slot: slot,
        note: note.isEmpty ? null : note,
        status: 'pending',
        createdAt: DateTime.now(),
      );

      final rawRequests = _box.get('call_requests', defaultValue: []);
      final List<Map<String, dynamic>> updated = [];
      for (var r in rawRequests) {
        if (r is Map) {
          updated.add(Map<String, dynamic>.from(r));
        }
      }
      updated.add(newReq.toMap());

      await _box.put('call_requests', updated);

      Get.snackbar(
        'Request Submitted',
        'Pending approval by $trainerId',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFECFDF5),
        colorText: const Color(0xFF065F46),
        duration: const Duration(seconds: 3),
      );

      // Refresh existing requests in case we return
      loadExistingRequests();

      // Go back to Home
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not submit call request. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
