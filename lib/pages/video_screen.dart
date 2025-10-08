import 'package:flutter/material.dart';

import '../widgets/custom_video_player.dart';
import '../widgets/mini_player.dart';
import '../video_player_provider.dart';

class VideoScreen extends StatefulWidget {
  final String? videoTitle;
  final String? videoUrl;

  const VideoScreen({super.key, this.videoTitle, this.videoUrl});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  void _setMinimized(bool isMinimized) {
    final videoController = VideoPlayerInheritedWidget.of(context)!.videoController;
    videoController.setMinimized(isMinimized);
  }

  @override
  Widget build(BuildContext context) {
    final videoController = VideoPlayerInheritedWidget.of(context)!.videoController;

    return ValueListenableBuilder(
      valueListenable: videoController.state,
      builder: (context, videoState, child) {
        if (videoState.isMinimized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context);
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.videoTitle ?? 'HLS Player PoC'),
            actions: [IconButton(icon: const Icon(Icons.minimize), onPressed: () => _setMinimized(true))],
          ),
          body: Stack(
            children: [
              ListView(
                children: [
                  CustomVideoPlayer(setMinimized: _setMinimized),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.videoTitle != null) ...[
                          Text(widget.videoTitle!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                        ],
                        const Text('Player M3U8 com controles avançados. Arraste para minimizar.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 800),
                ],
              ),
              const MiniPlayer(),
            ],
          ),
        );
      },
    );
  }
}
