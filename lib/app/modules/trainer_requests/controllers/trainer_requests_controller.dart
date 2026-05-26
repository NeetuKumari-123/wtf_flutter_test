import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../models/call_request.dart';

class TrainerRequestsController extends GetxController {
  final RxList<CallRequest> pendingRequests = <CallRequest>[].obs;

  late final Box _box;

  @override
  void onInit() {
    super.onInit();
    _box = Hive.box('app_state');
    loadPendingRequests();
  }

  void loadPendingRequests() {
    try {
      final rawRequests = _box.get('call_requests', defaultValue: []);

      final List<CallRequest> requests = [];

      for (var r in rawRequests) {
        if (r is Map) {
          final request = CallRequest.fromMap(r);

          if (request.status == 'pending') {
            requests.add(request);
          }
        }
      }

      pendingRequests.value = requests;
    } catch (e) {
      pendingRequests.clear();
    }
  }

  Future<void> approveRequest(CallRequest request) async {
    try {
      final rawRequests = _box.get('call_requests', defaultValue: []);

      final List<Map<String, dynamic>> updated = [];

      for (var r in rawRequests) {
        if (r is Map) {
          final map = Map<String, dynamic>.from(r);

          if (map['id'] == request.id) {
            map['status'] = 'approved';

            // future 100ms room meta
            map['roomId'] = 'room_${DateTime.now().millisecondsSinceEpoch}';
          }

          updated.add(map);
        }
      }

      await _box.put('call_requests', updated);

      Get.snackbar(
        'Request Approved',
        'Call approved successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFECFDF5),
        colorText: const Color(0xFF065F46),
      );

      loadPendingRequests();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not approve request.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> declineRequest(CallRequest request) async {
    try {
      final rawRequests = _box.get('call_requests', defaultValue: []);

      final List<Map<String, dynamic>> updated = [];

      for (var r in rawRequests) {
        if (r is Map) {
          final map = Map<String, dynamic>.from(r);

          if (map['id'] == request.id) {
            map['status'] = 'declined';
          }

          updated.add(map);
        }
      }

      await _box.put('call_requests', updated);

      Get.snackbar(
        'Request Declined',
        'Call request declined.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFEF2F2),
        colorText: const Color(0xFF991B1B),
      );

      loadPendingRequests();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not decline request.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
