import 'package:flutter/material.dart';
import 'state_management/video_controller.dart';

class VideoPlayerInheritedWidget extends InheritedWidget {
  final VideoController videoController;

  const VideoPlayerInheritedWidget({super.key, required this.videoController, required super.child});

  static VideoPlayerInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VideoPlayerInheritedWidget>();
  }

  @override
  bool updateShouldNotify(VideoPlayerInheritedWidget oldWidget) {
    return videoController != oldWidget.videoController;
  }
}

class VideoPlayerProvider extends StatefulWidget {
  final Widget child;
  final String hlsUrl;

  const VideoPlayerProvider({super.key, required this.child, required this.hlsUrl});

  @override
  State<VideoPlayerProvider> createState() => _VideoPlayerProviderState();
}

class _VideoPlayerProviderState extends State<VideoPlayerProvider> {
  late VideoController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoController(hlsUrl: widget.hlsUrl);
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayerInheritedWidget(videoController: _videoController, child: widget.child);
  }
}
