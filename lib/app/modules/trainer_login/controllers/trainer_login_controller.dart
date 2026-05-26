import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../routes/app_pages.dart';

class TrainerLoginController extends GetxController {
  final TextEditingController emailController = TextEditingController(
    text: 'aarav@trainer.com',
  );
  final TextEditingController passwordController = TextEditingController(
    text: 'password123',
  );
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Required Fields',
        'Please enter both email and password.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final box = Hive.box('app_state');
      await box.put('trainer_logged_in', true);
      await box.put('trainer_name', 'Aarav (Lead Trainer)');

      Get.snackbar(
        'Welcome Back',
        'Logged in successfully as Aarav (Lead Trainer)',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.offAllNamed(Routes.TRAINER_HOME);
    } catch (e) {
      Get.offAllNamed(Routes.TRAINER_HOME);
    } finally {
      isLoading.value = false;
    }
  }
}
