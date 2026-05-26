import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/guru_home_controller.dart';

class GuruHomeView extends GetView<GuruHomeController> {
  const GuruHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate-50 light background
      appBar: AppBar(
        title: const Text(
          'Guru Client Home',
          style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => controller.logOut(),
            icon: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626)),
            tooltip: 'Log Out (Reset first-run)',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE2E8F0), height: 1),
        ),
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Client Welcome Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF6366F1)], // Indigo gradients
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4F46E5).withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    // Dummy avatar
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Text(
                        'DK',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back, ${controller.clientName.value}!',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  'Trainer: ${controller.assignedTrainer.value}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'YOUR MENTORSHIP HUD',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF64748B),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 16),

              // Card 1: Chat with Trainer
              _buildHomeCard(
                title: 'Chat with Trainer',
                description: 'Direct live messaging with ${controller.assignedTrainer.value}',
                icon: Icons.chat_bubble_rounded,
                cardColor: Colors.white,
                iconColor: const Color(0xFF4F46E5),
                onTap: () {
                  Get.snackbar(
                    'Chat Initiated',
                    'Connecting you to ${controller.assignedTrainer.value}...',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xFFEEF2FF),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Card 2: Schedule Call
              _buildHomeCard(
                title: 'Schedule Call',
                description: 'Book a 1:1 strategy consultation call',
                icon: Icons.video_call_rounded,
                cardColor: Colors.white,
                iconColor: const Color(0xFF0EA5E9),
                onTap: () {
                  Get.snackbar(
                    'Schedule Booking',
                    'Opening call scheduler...',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xFFF0F9FF),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Card 3: My Sessions
              _buildHomeCard(
                title: 'My Sessions',
                description: 'View workout and goal review history',
                icon: Icons.history_rounded,
                cardColor: Colors.white,
                iconColor: const Color(0xFF10B981),
                onTap: () {
                  Get.snackbar(
                    'My Sessions',
                    'Loading your session records...',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xFFECFDF5),
                  );
                },
              ),

              const SizedBox(height: 40),
              
              // Back to selector
              OutlinedButton.icon(
                onPressed: () => Get.offAllNamed(Routes.ROLE_SELECTION),
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text('Return to Role Selection'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF475569),
                  side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeCard({
    required String title,
    required String description,
    required IconData icon,
    required Color cardColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 28,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF94A3B8),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
