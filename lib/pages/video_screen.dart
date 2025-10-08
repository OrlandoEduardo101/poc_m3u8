import 'package:flutter/material.dart';

import '../widgets/custom_video_player.dart';
import '../widgets/mini_player.dart';
import '../video_player_provider.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

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
            title: const Text('HLS Player PoC'),
            actions: [IconButton(icon: const Icon(Icons.minimize), onPressed: () => _setMinimized(true))],
          ),
          body: Stack(
            children: [
              ListView(
                children: [
                  CustomVideoPlayer(setMinimized: _setMinimized),
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Player M3U8 com controles avançados. Arraste para minimizar.'),
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
