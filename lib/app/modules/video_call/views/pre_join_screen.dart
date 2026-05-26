import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/video_call_controller.dart';
import 'video_call_view.dart';

class PreJoinView extends GetView<VideoCallController> {
  const PreJoinView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),

            const Text(
              "Ready to join?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Icon(Icons.videocam, color: Colors.white54, size: 80),
                ),
              ),
            ),

            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: controller.toggleMic,
                    icon: Icon(
                      controller.isMicOn.value ? Icons.mic : Icons.mic_off,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),

                  const SizedBox(width: 30),

                  IconButton(
                    onPressed: controller.toggleCamera,
                    icon: Icon(
                      controller.isCameraOn.value
                          ? Icons.videocam
                          : Icons.videocam_off,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  await controller.joinCall();

                  Get.off(() => const VideoCallView());
                },
                child: const Text("Join Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
