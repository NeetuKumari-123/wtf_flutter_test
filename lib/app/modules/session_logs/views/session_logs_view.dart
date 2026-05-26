import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/session_logs_controller.dart';

import '../model/session_log.dart';

class SessionLogsView extends GetView<SessionLogsController> {
  const SessionLogsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(title: const Text("Session Logs")),

      body: Obx(() {
        final logs = controller.filteredLogs;

        if (logs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.history, size: 70, color: Colors.grey),

                const SizedBox(height: 20),

                const Text(
                  "No session logs yet",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text("Schedule your first call"),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            const SizedBox(height: 16),

            _buildFilters(),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: logs.length,
                itemBuilder: (_, index) {
                  final log = logs[index];

                  return _buildLogCard(log);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFilters() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _chip(title: "All", value: "all"),

          const SizedBox(width: 10),

          _chip(title: "Last 7 Days", value: "7days"),

          const SizedBox(width: 10),

          _chip(title: "This Month", value: "month"),
        ],
      ),
    );
  }

  Widget _chip({required String title, required String value}) {
    final selected = controller.selectedFilter.value == value;

    return ChoiceChip(
      label: Text(title),
      selected: selected,
      onSelected: (_) {
        controller.setFilter(value);
      },
    );
  }

  Widget _buildLogCard(SessionLog log) {
    final mins = (log.durationSec / 60).round();

    return GestureDetector(
      onTap: () {
        Get.dialog(
          AlertDialog(
            title: const Text("Session Details"),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Trainer Notes:"),

                const SizedBox(height: 6),

                Text(log.trainerNotes ?? "No notes"),

                const SizedBox(height: 20),

                Text("Member Notes:"),

                const SizedBox(height: 6),

                Text(log.memberNotes ?? "No notes"),
              ],
            ),
          ),
        );
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 14),

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEE, MMM d').format(log.startedAt),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 6),

                Text("$mins mins"),
              ],
            ),

            Column(
              children: [
                const Icon(Icons.star, color: Colors.amber),

                Text(log.rating?.toString() ?? "-"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
