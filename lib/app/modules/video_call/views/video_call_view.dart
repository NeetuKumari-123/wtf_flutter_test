import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/video_call_controller.dart';

class VideoCallView extends GetView<VideoCallController> {
  const VideoCallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              if (controller.peers.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return GridView.builder(
                itemCount: controller.peers.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (_, index) {
                  final peer = controller.peers[index];

                  return Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        const Center(
                          child: Icon(
                            Icons.person,
                            color: Colors.white54,
                            size: 60,
                          ),
                        ),

                        Positioned(
                          left: 10,
                          bottom: 10,
                          child: Text(
                            peer.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),

            Obx(
              () => controller.reconnecting.value
                  ? Container(
                      color: Colors.black54,
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox(),
            ),

            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: "mic",
                    onPressed: controller.toggleMic,
                    child: Obx(
                      () => Icon(
                        controller.isMicOn.value ? Icons.mic : Icons.mic_off,
                      ),
                    ),
                  ),

                  FloatingActionButton(
                    heroTag: "cam",
                    onPressed: controller.toggleCamera,
                    child: Obx(
                      () => Icon(
                        controller.isCameraOn.value
                            ? Icons.videocam
                            : Icons.videocam_off,
                      ),
                    ),
                  ),

                  FloatingActionButton(
                    heroTag: "flip",
                    onPressed: controller.flipCamera,
                    child: const Icon(Icons.flip_camera_ios),
                  ),

                  FloatingActionButton(
                    backgroundColor: Colors.red,
                    heroTag: "end",
                    onPressed: controller.leaveCall,
                    child: const Icon(Icons.call_end),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
