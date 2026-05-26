import 'dart:async';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ChatListController extends GetxController {
  final RxString lastMessage = 'No messages yet'.obs;
  final RxString lastTimestamp = ''.obs;
  final RxInt unreadCount = 0.obs;
  final RxString clientName = 'DK'.obs;
  
  late final Box _box;
  StreamSubscription? _boxSubscription;

  @override
  void onInit() {
    super.onInit();
    _box = Hive.box('app_state');
    clientName.value = _box.get('guru_name', defaultValue: 'DK') as String;

    refreshChatSummary();

    // Listen to real-time changes in messages key
    _boxSubscription = _box.watch(key: 'messages').listen((event) {
      refreshChatSummary();
    });
  }

  @override
  void onClose() {
    _boxSubscription?.cancel();
    super.onClose();
  }

  void refreshChatSummary() {
    clientName.value = _box.get('guru_name', defaultValue: 'DK') as String;
    final rawMsgs = _box.get('messages', defaultValue: []);
    
    if (rawMsgs.isEmpty) {
      lastMessage.value = 'No messages yet';
      lastTimestamp.value = '';
      unreadCount.value = 0;
      return;
    }

    // Count unread messages sent by member
    int count = 0;
    Map<String, dynamic>? last;
    
    for (var m in rawMsgs) {
      if (m is Map) {
        final msg = Map<String, dynamic>.from(m);
        if (msg['sender'] == 'member' && msg['status'] == 'sent') {
          count++;
        }
        last = msg;
      }
    }

    unreadCount.value = count;

    if (last != null) {
      lastMessage.value = last['text'] ?? '';
      lastTimestamp.value = getRelativeTime(last['timestamp'] ?? '');
    }
  }

  String getRelativeTime(String timestampIso) {
    if (timestampIso.isEmpty) return '';
    try {
      final dt = DateTime.parse(timestampIso);
      final diff = DateTime.now().difference(dt);
      if (diff.inSeconds < 10) return 'Just now';
      if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${dt.day}/${dt.month}';
    } catch (e) {
      return '';
    }
  }
}
