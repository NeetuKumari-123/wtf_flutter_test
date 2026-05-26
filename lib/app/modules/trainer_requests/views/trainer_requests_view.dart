import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/trainer_requests_controller.dart';

class TrainerRequestsView extends GetView<TrainerRequestsController> {
  const TrainerRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Pending Requests',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.pendingRequests.isEmpty) {
          return const Center(
            child: Text(
              'No pending requests',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: controller.pendingRequests.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final request = controller.pendingRequests[index];

            return Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.memberId,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    DateFormat('EEE, MMM d • h:mm a').format(request.slot),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4F46E5),
                    ),
                  ),

                  if (request.note != null) ...[
                    const SizedBox(height: 12),

                    Text(
                      request.note!,
                      style: const TextStyle(color: Color(0xFF475569)),
                    ),
                  ],

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            controller.approveRequest(request);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Approve'),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            controller.declineRequest(request);
                          },
                          child: const Text('Decline'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
