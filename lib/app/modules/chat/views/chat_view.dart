import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    // Member = Indigo/Blue theme, Trainer = Crimson/Red theme
    final isMember = controller.role == 'member';
    final primaryColor = isMember
        ? const Color(0xFF4F46E5)
        : const Color(0xFFDC2626);
    final bubbleSelfColor = isMember
        ? const Color(0xFFEEF2FF)
        : const Color(0xFFFEF2F2);
    final textSelfColor = isMember
        ? const Color(0xFF312E81)
        : const Color(0xFF7F1D1D);
    final borderSelfColor = isMember
        ? const Color(0xFFC7D2FE)
        : const Color(0xFFFCA5A5);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0F172A)),
        ),

        title: Obx(
          () => Row(
            children: [
              CircleAvatar(
                backgroundColor: primaryColor.withOpacity(0.1),
                child: Text(
                  isMember ? '👨‍🏫' : 'DK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.otherPersonName.value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),

                    const SizedBox(height: 2),

                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                        ),

                        const SizedBox(width: 6),

                        const Text(
                          'Online',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        actions: [
          Obx(() {
            final canJoin = controller.canJoinCall.value;

            if (!canJoin) {
              return const SizedBox();
            }

            return Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Get.toNamed(
                      Routes.PRE_JOIN,
                      arguments: {"role": controller.role},
                    );
                  },
                  icon: const Icon(
                    Icons.videocam_rounded,
                    color: Color(0xFF10B981),
                    size: 28,
                  ),
                ),

                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            );
          }),

          const SizedBox(width: 8),
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
      ),
      body: Obx(
        () => Column(
          children: [
            // Chat Area
            Expanded(
              child: controller.messages.isEmpty
                  ? _buildEmptyState(primaryColor)
                  : RefreshIndicator(
                      onRefresh: () async {
                        controller.loadMessages();
                        Get.snackbar(
                          'History Loaded',
                          'Pull down to load full chat history was successful.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xFFF1F5F9),
                        );
                      },
                      child: ListView.builder(
                        controller: controller.scrollController,
                        padding: const EdgeInsets.all(20.0),
                        itemCount: controller.messages.length,
                        itemBuilder: (context, index) {
                          final msg = controller.messages[index];
                          final isSelf = msg['sender'] == controller.role;
                          return _buildChatBubble(
                            msg,
                            isSelf,
                            bubbleSelfColor,
                            textSelfColor,
                            borderSelfColor,
                          );
                        },
                      ),
                    ),
            ),

            // Typing Indicator bubble
            if (controller.isTyping.value)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            3,
                            (index) => Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: const BoxDecoration(
                                color: Color(0xFF64748B),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Typing...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Quick reply chips
            if (controller.messages.isNotEmpty)
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.quickReplies.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final chipText = controller.quickReplies[index];
                    return InputChip(
                      label: Text(
                        chipText,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      backgroundColor: Colors.white,
                      selectedColor: primaryColor.withOpacity(0.2),
                      side: BorderSide(color: primaryColor.withOpacity(0.4)),
                      onPressed: () => controller.sendMessage(chipText),
                    );
                  },
                ),
              ),

            // Input Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                children: [
                  // Attachment Icon Button
                  IconButton(
                    onPressed: () => _showAttachmentModal(context),
                    icon: Icon(
                      Icons.add_photo_alternate_rounded,
                      color: primaryColor,
                      size: 28,
                    ),
                    tooltip: 'Send Attachments',
                  ),
                  const SizedBox(width: 8),

                  // Text input field
                  Expanded(
                    child: TextField(
                      controller: controller.textController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                        fillColor: const Color(0xFFF1F5F9),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A),
                      ),
                      onSubmitted: (val) => controller.sendMessage(val),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Send Button
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => controller.sendMessage(
                        controller.textController.text,
                      ),
                      icon: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color themeColor) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Text(
                '💬',
                style: TextStyle(fontSize: 64, color: themeColor),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Messages Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start a live connection with your ${controller.role == 'member' ? 'coach' : 'client'} now!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),

            // CTA Button "Say hi"
            ElevatedButton.icon(
              onPressed: () => controller.sendMessage('Say hi 👋'),
              icon: const Icon(Icons.waving_hand_rounded, size: 18),
              label: const Text(
                'Say hi 👋',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
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

  Widget _buildChatBubble(
    Map<String, dynamic> msg,
    bool isSelf,
    Color bubbleSelfColor,
    Color textSelfColor,
    Color borderSelfColor,
  ) {
    final otherColor = const Color(0xFFF1F5F9);
    final otherBorderColor = const Color(0xFFE2E8F0);

    final isAttachment = msg['isAttachment'] == true;
    final isRead = msg['status'] == 'read';

    // Parse time
    String timeStr = '';
    try {
      final dt = DateTime.parse(msg['timestamp']);
      timeStr =
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      timeStr = 'Just now';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: isSelf
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isSelf
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isSelf) ...[
                CircleAvatar(
                  radius: 14,
                  backgroundColor: const Color(0xFFCBD5E1),
                  child: Text(
                    controller.role == 'member' ? '👨‍🏫' : 'DK',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
              ],

              // Bubble Container
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelf ? bubbleSelfColor : otherColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isSelf ? 20 : 4),
                      bottomRight: Radius.circular(isSelf ? 4 : 20),
                    ),
                    border: Border.all(
                      color: isSelf ? borderSelfColor : otherBorderColor,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Thumbnail image in bubble for Attachments bonus
                      if (isAttachment) ...[
                        Container(
                          width: 120,
                          height: 120,
                          margin: const EdgeInsets.only(bottom: 8.0),
                          decoration: BoxDecoration(
                            color: isSelf
                                ? borderSelfColor.withOpacity(0.4)
                                : const Color(0xFFCBD5E1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            msg['attachmentPath'] ?? '🖼️',
                            style: const TextStyle(fontSize: 48),
                          ),
                        ),
                      ],
                      Text(
                        msg['text'] ?? '',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isSelf
                              ? textSelfColor
                              : const Color(0xFF1E293B),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Meta details (time & ticks)
          Padding(
            padding: EdgeInsets.only(
              top: 4.0,
              left: isSelf ? 0.0 : 36.0,
              right: isSelf ? 8.0 : 0.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeStr,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isSelf) ...[
                  const SizedBox(width: 4),
                  // Double checkmark for read, single checkmark for sent
                  Text(
                    isRead ? '✓✓' : '✓',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isRead
                          ? const Color(0xFF10B981)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAttachmentModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Share Fitness Mock Attachment',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAttachmentOption(
                    context: context,
                    icon: Icons.bar_chart_rounded,
                    label: 'Progress Chart',
                    color: const Color(0xFF4F46E5),
                    onTap: () {
                      Navigator.pop(context);
                      controller.pickMockAttachment('progress');
                    },
                  ),
                  _buildAttachmentOption(
                    context: context,
                    icon: Icons.restaurant_menu_rounded,
                    label: 'Meal Log',
                    color: const Color(0xFF10B981),
                    onTap: () {
                      Navigator.pop(context);
                      controller.pickMockAttachment('meal');
                    },
                  ),
                  _buildAttachmentOption(
                    context: context,
                    icon: Icons.fitness_center_rounded,
                    label: 'Workout snap',
                    color: const Color(0xFFF59E0B),
                    onTap: () {
                      Navigator.pop(context);
                      controller.pickMockAttachment('workout');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
