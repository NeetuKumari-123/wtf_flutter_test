import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/role_selection_controller.dart';

class RoleSelectionView extends GetView<RoleSelectionController> {
  const RoleSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Modern slate-50 light background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),
              // Brand/Header
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.directions_run_rounded,
                    size: 48,
                    color: Color(0xFF4F46E5), // Indigo-600
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Training & Mentorship',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B), // Slate-800
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose your role to enter the application flow',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B), // Slate-500
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(flex: 2),

              // Guru App (DK) Selector Card
              _buildRoleCard(
                context: context,
                title: 'Guru App (Client)',
                subtitle: 'Personal onboarding, trainer selection & direct chat.',
                icon: Icons.person_search_rounded,
                primaryColor: const Color(0xFF4F46E5), // Indigo-600
                onTap: () => controller.selectGuruRole(),
              ),

              const SizedBox(height: 20),

              // Trainer App Selector Card
              _buildRoleCard(
                context: context,
                title: 'Trainer App (Coach)',
                subtitle: 'Manage members, view chat requests & schedule sessions.',
                icon: Icons.psychology_rounded,
                primaryColor: const Color(0xFF0F172A), // Slate-900
                onTap: () => controller.selectTrainerRole(),
              ),

              const Spacer(flex: 2),

              // Reset persistence button for testing
              TextButton.icon(
                onPressed: () => controller.clearAllData(),
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: const Text(
                  'Reset App (Clear Persistence & States)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFDC2626), // Red-600
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                size: 32,
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: primaryColor.withOpacity(0.7),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
