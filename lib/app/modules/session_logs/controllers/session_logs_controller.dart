import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../model/session_log.dart';

class SessionLogsController extends GetxController {
  final RxList<SessionLog> logs = <SessionLog>[].obs;

  final RxString selectedFilter = "all".obs;

  late final Box _box;

  @override
  void onInit() {
    super.onInit();

    _box = Hive.box("app_state");

    loadLogs();
  }

  void loadLogs() {
    final raw = _box.get("session_logs", defaultValue: []);

    final List<SessionLog> loaded = [];

    for (var item in raw) {
      if (item is Map) {
        loaded.add(SessionLog.fromMap(item));
      }
    }

    loaded.sort((a, b) => b.startedAt.compareTo(a.startedAt));

    logs.value = loaded;
  }

  List<SessionLog> get filteredLogs {
    final now = DateTime.now();

    if (selectedFilter.value == "7days") {
      return logs.where((log) {
        return now.difference(log.startedAt).inDays <= 7;
      }).toList();
    }

    if (selectedFilter.value == "month") {
      return logs.where((log) {
        return log.startedAt.month == now.month;
      }).toList();
    }

    return logs;
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }
}
