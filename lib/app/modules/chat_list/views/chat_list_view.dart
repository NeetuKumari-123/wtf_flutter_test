import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/chat_list_controller.dart';

class ChatListView extends GetView<ChatListController> {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Chats Inbox',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
      ),
      body: Obx(() {
        // If no messages at all, show a neat invitation state
        final hasMessages = controller.lastMessage.value != 'No messages yet';

        if (!hasMessages) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Text('📬', style: TextStyle(fontSize: 64)),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'No Active Chats',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your client dashboard is ready. When a client initiates a conversation, it will show up here!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),
                  // CTA Button "Say hi" (simulates launching the chat with client DK directly)
                  ElevatedButton.icon(
                    onPressed: () => Get.toNamed(
                      Routes.CHAT,
                      arguments: {'role': 'trainer'},
                    ),
                    icon: const Icon(Icons.waving_hand_rounded, size: 18),
                    label: const Text(
                      'Say hi to DK 👋',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC2626), // Trainer Red
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            const Text(
              'RECENT CLIENT CONVERSATIONS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF64748B),
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),

            // Chat List Item for client DK
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
              ),
              child: InkWell(
                onTap: () =>
                    Get.toNamed(Routes.CHAT, arguments: {'role': 'trainer'}),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 16.0,
                  ),
                  child: Row(
                    children: [
                      // Avatar with initials
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: const Color(0xFFEEF2FF),
                        child: Text(
                          controller.clientName.value
                              .substring(
                                0,
                                controller.clientName.value.length >= 2 ? 2 : 1,
                              )
                              .toUpperCase(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4F46E5),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Client Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  controller.clientName.value,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  controller.lastTimestamp.value,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    controller.lastMessage.value,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight:
                                          controller.unreadCount.value > 0
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: controller.unreadCount.value > 0
                                          ? const Color(0xFF0F172A)
                                          : const Color(0xFF64748B),
                                    ),
                                  ),
                                ),

                                // Unread Count Badge
                                if (controller.unreadCount.value > 0) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFDC2626), // Alert Red
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    constraints: const BoxConstraints(
                                      minWidth: 20,
                                      minHeight: 20,
                                    ),
                                    child: Text(
                                      '${controller.unreadCount.value}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
