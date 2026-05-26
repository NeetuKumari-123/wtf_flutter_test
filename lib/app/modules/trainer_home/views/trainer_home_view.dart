import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/trainer_home_controller.dart';

class TrainerHomeView extends GetView<TrainerHomeController> {
  const TrainerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Trainer Workspace',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => controller.logOut(),
            icon: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626)),
            tooltip: 'Log Out (Reset login state)',
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
              // Trainer Welcome Banner
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Dummy Avatar
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '👨‍🏫',
                        style: TextStyle(fontSize: 36),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Active Session',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF64748B),
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.trainerName.value,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Lead Coach | Gym Operations',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF4F46E5),
                              fontWeight: FontWeight.w600,
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
                'MANAGEMENT DASHBOARD',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF64748B),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 16),

              // 2x2 Grid of Management Tiles
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.15,
                children: [
                  _buildDashboardTile(
                    title: 'Members',
                    count: '14 Active',
                    icon: Icons.people_alt_rounded,
                    color: const Color(0xFF4F46E5), // Indigo-600
                    onTap: () {
                      Get.snackbar(
                        'Members List',
                        'Loading active trainees and clients...',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFFEEF2FF),
                      );
                    },
                  ),
                  _buildDashboardTile(
                    title: 'Chats',
                    count: '3 New',
                    icon: Icons.forum_rounded,
                    color: const Color(0xFF0EA5E9), // Sky-500
                    onTap: () {
                      Get.snackbar(
                        'Chats Dashboard',
                        'Opening trainee live chatrooms...',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFFF0F9FF),
                      );
                    },
                  ),
                  _buildDashboardTile(
                    title: 'Requests',
                    count: '2 Pending',
                    icon: Icons.notification_important_rounded,
                    color: const Color(0xFFF59E0B), // Amber-500
                    onTap: () {
                      Get.snackbar(
                        'Trainee Requests',
                        'Reviewing auto-assign and coaching requests...',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFFFEF3C7),
                      );
                    },
                  ),
                  _buildDashboardTile(
                    title: 'Sessions',
                    count: '5 Today',
                    icon: Icons.event_available_rounded,
                    color: const Color(0xFF10B981), // Emerald-500
                    onTap: () {
                      Get.snackbar(
                        'Training Schedule',
                        'Loading today\'s sessions calendar...',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFFECFDF5),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 36),

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

  Widget _buildDashboardTile({
    required String title,
    required String count,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.015),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 24, color: color),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: const Color(0xFF94A3B8).withOpacity(0.6),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
