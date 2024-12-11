import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoControllerProvider extends ChangeNotifier {
  Map<int, VideoPlayerController> videoControllers = {};

  VideoPlayerController? getController(int videoId) {
    return videoControllers[videoId];
  }


  Future<void> preloadVideo(int uploadId, Uri videoUrl) async {
    if (!videoControllers.containsKey(uploadId)) {
      final controller = VideoPlayerController.networkUrl(videoUrl);
      await controller.setLooping(true);
      await controller.initialize();
      videoControllers[uploadId] = controller;
    }
  }

  bool isVideoPreloaded(int uploadId) {
    return videoControllers.containsKey(uploadId);
  }

  void disposeController(int videoId) {
    if (videoControllers.containsKey(videoId)) {
      videoControllers[videoId]?.dispose();
      videoControllers.remove(videoId);
      notifyListeners();
    }
  }

  void disposeUnusedControllers(List<int> activeVideoIds) {
    final unusedControllers = videoControllers.keys
        .where((id) => !activeVideoIds.contains(id))
        .toList();
    for (var id in unusedControllers) {
      disposeController(id);
    }
  }

  @override
  void dispose() {
    for (var controller in videoControllers.values) {
      controller.dispose();
    }
    videoControllers.clear();
    super.dispose();
  }
}