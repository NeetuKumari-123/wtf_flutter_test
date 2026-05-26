import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ChatController extends GetxController {
  final RxBool canJoinCall = false.obs;

  void checkJoinAvailability() {
    final rawRequests = _box.get('call_requests', defaultValue: []);

    for (var r in rawRequests) {
      if (r is Map) {
        final map = Map<String, dynamic>.from(r);

        if (map['status'] == 'approved') {
          final slot = DateTime.parse(map['slot']);

          final canJoinNow = DateTime.now().isAfter(
            slot.subtract(const Duration(minutes: 10)),
          );

          if (canJoinNow) {
            canJoinCall.value = true;
            return;
          }
        }
      }
    }

    canJoinCall.value = false;
  }

  final String role =
      Get.arguments['role'] ?? 'member'; // 'member' or 'trainer'

  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final RxBool isTyping = false.obs;
  final RxString otherPersonName = ''.obs;

  late final Box _box;
  StreamSubscription? _boxSubscription;

  final List<String> quickReplies = [
    'Got it 👍',
    'Can we talk at 6?',
    'Share plan?',
  ];

  @override
  void onInit() {
    super.onInit();
    _box = Hive.box('app_state');

    // Set other person's name
    if (role == 'member') {
      otherPersonName.value =
          _box.get('guru_trainer', defaultValue: 'Aarav (Lead Trainer)')
              as String;
    } else {
      otherPersonName.value =
          _box.get('guru_name', defaultValue: 'DK') as String;
    }
    checkJoinAvailability();
    loadMessages();
    markAsRead();

    // Listen to changes in Hive box for real-time dual-app sync
    _boxSubscription = _box.watch(key: 'messages').listen((event) {
      loadMessages();
      markAsRead();
    });
  }

  @override
  void onClose() {
    _boxSubscription?.cancel();
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void loadMessages() {
    final rawMsgs = _box.get('messages', defaultValue: []);
    final List<Map<String, dynamic>> loaded = [];
    for (var m in rawMsgs) {
      if (m is Map) {
        loaded.add(Map<String, dynamic>.from(m));
      }
    }
    messages.value = loaded;
    _scrollToBottom();
  }

  void markAsRead() {
    bool hasChanged = false;
    final List<Map<String, dynamic>> updated = messages.map((m) {
      // If the message is from the other person and status is sent, mark it as read
      final isOther =
          (role == 'member' && m['sender'] == 'trainer') ||
          (role == 'trainer' && m['sender'] == 'member');
      if (isOther && m['status'] == 'sent') {
        m['status'] = 'read';
        hasChanged = true;
      }
      return m;
    }).toList();

    if (hasChanged) {
      _box.put('messages', updated);
    }
  }

  Future<void> sendMessage(String text, {String? attachmentPath}) async {
    if (text.trim().isEmpty && attachmentPath == null) return;

    final newMessage = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'sender': role,
      'text': text.trim(),
      'timestamp': DateTime.now().toIso8601String(),
      'status': 'sent',
      'isAttachment': attachmentPath != null,
      'attachmentPath': attachmentPath ?? '',
    };

    final rawMsgs = _box.get('messages', defaultValue: []);
    final List<Map<String, dynamic>> updated = [];
    for (var m in rawMsgs) {
      if (m is Map) updated.add(Map<String, dynamic>.from(m));
    }
    updated.add(newMessage);

    await _box.put('messages', updated);
    textController.clear();
    loadMessages();
    _scrollToBottom();

    // Trigger typing simulation on other side (Real-time feel)
    _simulateOtherPersonTypingAndResponse(text);
  }

  void _simulateOtherPersonTypingAndResponse(String userText) {
    // 400 - 800ms typing delay
    isTyping.value = true;
    Timer(const Duration(milliseconds: 800), () async {
      isTyping.value = false;

      // Determine what the simulated reply should be
      String replyText = '';
      if (role == 'member') {
        // Coach replies to DK
        if (userText.contains('👍')) {
          replyText =
              'Keep up the momentum, DK! 🔥 Let me know if you need changes.';
        } else if (userText.contains('6')) {
          replyText =
              'Sure! I have marked 6 PM on my calendar for our sync. 📞';
        } else if (userText.contains('plan')) {
          replyText =
              'Sure thing! Just uploaded the custom strength and diet plan. Check your portal!';
        } else {
          replyText =
              'Awesome message, DK! Let\'s stay consistent with the workout routine this week.';
        }
      } else {
        // DK replies to Coach Aarav
        if (userText.contains('plan') || userText.contains('workout')) {
          replyText =
              'Got it coach, will check the schedule and log my workouts! 🏋️‍♂️';
        } else {
          replyText = 'Understood! Looking forward to today\'s session. 👍';
        }
      }

      final autoReply = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'sender': role == 'member' ? 'trainer' : 'member',
        'text': replyText,
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'read', // Already read by self
        'isAttachment': false,
        'attachmentPath': '',
      };

      final rawMsgs = _box.get('messages', defaultValue: []);
      final List<Map<String, dynamic>> updated = [];
      for (var m in rawMsgs) {
        if (m is Map) updated.add(Map<String, dynamic>.from(m));
      }
      updated.add(autoReply);

      await _box.put('messages', updated);
      loadMessages();
      _scrollToBottom();
    });
  }

  void pickMockAttachment(String type) {
    String mockImage = '';
    String textDesc = '';

    if (type == 'progress') {
      mockImage = '📈';
      textDesc = 'Progress Chart updated';
    } else if (type == 'meal') {
      mockImage = '🥗';
      textDesc = 'Healthy Diet log shared';
    } else {
      mockImage = '🏋️‍♂️';
      textDesc = 'Workout snap uploaded';
    }

    sendMessage(
      '$mockImage [Mock Attachment: $textDesc]',
      attachmentPath: mockImage,
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
