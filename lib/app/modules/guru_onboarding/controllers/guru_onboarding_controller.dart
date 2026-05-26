import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../routes/app_pages.dart';

class GuruOnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final TextEditingController nameController = TextEditingController(text: 'DK');
  
  final List<Map<String, String>> trainers = [
    {
      'name': 'Aarav',
      'role': 'Lead Trainer',
      'avatar': '👨‍🏫',
      'bio': '10+ years experience in premium conditioning.'
    },
    {
      'name': 'Sarah Connor',
      'role': 'Strength Specialist',
      'avatar': '👩‍🔬',
      'bio': 'Elite powerlifter, focused on strength and posture.'
    },
    {
      'name': 'Michael Chang',
      'role': 'Cardio & HIIT Coach',
      'avatar': '🏃‍♂️',
      'bio': 'Endurance expert, high energy performance.'
    },
  ];

  final RxnString selectedTrainer = RxnString();

  @override
  void onClose() {
    pageController.dispose();
    nameController.dispose();
    super.onClose();
  }

  void onPageChanged(int page) {
    currentPage.value = page;
  }

  void nextPage() {
    if (currentPage.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void selectTrainer(String name) {
    selectedTrainer.value = name;
  }

  Future<void> completeProfile() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar(
        'Required Field',
        'Please enter a name for your profile.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedTrainer.value == null) {
      Get.snackbar(
        'Trainer Required',
        'Please select a trainer to complete profile.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final box = Hive.box('app_state');
      await box.put('guru_name', name);
      await box.put('guru_trainer', selectedTrainer.value!);
      await box.put('guru_onboarding_completed', true);
      await box.put('guru_profile_created', true);

      Get.snackbar(
        'Success',
        'Profile Created! Auto-assigned to ${selectedTrainer.value}.',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.offAllNamed(Routes.GURU_HOME);
    } catch (e) {
      Get.offAllNamed(Routes.GURU_HOME);
    }
  }
}
