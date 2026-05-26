import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class VideoCallController extends GetxController implements HMSUpdateListener {
  late HMSSDK hmsSDK;

  final RxBool isMicOn = true.obs;
  final RxBool isCameraOn = true.obs;
  final RxBool reconnecting = false.obs;
  final RxBool joinedRoom = false.obs;

  final RxList<HMSPeer> peers = <HMSPeer>[].obs;

  DateTime? callStartedAt;

  @override
  void onInit() async {
    super.onInit();

    hmsSDK = HMSSDK();

    await hmsSDK.build();

    hmsSDK.addUpdateListener(listener: this);
  }

  Future<void> joinCall() async {
    try {
      callStartedAt = DateTime.now();

      HMSConfig config = HMSConfig(authToken: "TOKEN_HERE", userName: "DK");

      await hmsSDK.join(config: config);
    } catch (e) {
      Get.snackbar(
        "Join Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> leaveCall() async {
    try {
      await hmsSDK.leave();

      final end = DateTime.now();

      final duration = end.difference(callStartedAt!).inSeconds;

      debugPrint("CALL DURATION: $duration");

      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: const Text(
            "Session saved to logs.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } catch (e) {
      Get.snackbar("Leave Failed", e.toString());
    }
  }

  void toggleMic() {
    isMicOn.value = !isMicOn.value;

    hmsSDK.switchAudio(isOn: isMicOn.value);
  }

  void toggleCamera() {
    isCameraOn.value = !isCameraOn.value;

    hmsSDK.switchVideo(isOn: isCameraOn.value);
  }

  void flipCamera() {
    hmsSDK.switchCamera();
  }

  // =========================
  // HMS LISTENERS
  // =========================

  @override
  void onJoin({required HMSRoom room}) {
    joinedRoom.value = true;

    debugPrint("JOINED ROOM");
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    if (update == HMSPeerUpdate.peerJoined) {
      if (!peers.contains(peer)) {
        peers.add(peer);
      }
    }

    if (update == HMSPeerUpdate.peerLeft) {
      peers.removeWhere((p) => p.peerId == peer.peerId);
    }
  }

  @override
  void onPeerListUpdate({
    required List<HMSPeer> addedPeers,
    required List<HMSPeer> removedPeers,
  }) {
    peers.addAll(addedPeers);

    for (var peer in removedPeers) {
      peers.removeWhere((p) => p.peerId == peer.peerId);
    }
  }

  @override
  void onTrackUpdate({
    required HMSTrack track,
    required HMSTrackUpdate trackUpdate,
    required HMSPeer peer,
  }) {}

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {}

  @override
  void onMessage({required HMSMessage message}) {}

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {}

  @override
  void onReconnecting() {
    reconnecting.value = true;
  }

  @override
  void onReconnected() {
    reconnecting.value = false;
  }

  @override
  void onHMSError({required HMSException error}) {
    debugPrint(error.message);

    Get.snackbar(
      "100ms Error",
      error.message ?? "Unknown Error",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onRemovedFromRoom({
    required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer,
  }) {
    Get.snackbar("Removed", "You were removed from the room.");
  }

  @override
  void onAudioDeviceChanged({
    HMSAudioDevice? currentAudioDevice,
    List<HMSAudioDevice>? availableAudioDevice,
  }) {}

  @override
  void onChangeTrackStateRequest({
    required HMSTrackChangeRequest hmsTrackChangeRequest,
  }) {}

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {}

  @override
  void onSessionStoreAvailable({HMSSessionStore? hmsSessionStore}) {}
}
