import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state_management/video_controller.dart';

class CustomVideoPlayer extends StatelessWidget {
  const CustomVideoPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoController>(
      builder: (context, videoController, _) {
        final controller = videoController.playerController;
        if (!videoController.isInitialized || controller == null) {
          return const AspectRatio(
            aspectRatio: 16 / 9,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return AspectRatio(
          aspectRatio: controller.videoPlayerController!.value.aspectRatio == 0
              ? 16 / 9
              : controller.videoPlayerController!.value.aspectRatio,
          child: Stack(
            fit: StackFit.expand,
            children: [
              BetterPlayer(
                controller: controller,
              ),
              // Double-tap zones
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onDoubleTap: () => videoController.seekRelative(const Duration(seconds: -10)),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onDoubleTap: () => videoController.seekRelative(const Duration(seconds: 10)),
                      child: const SizedBox.expand(),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 12,
                top: 12,
                child: IconButton(
                  icon: const Icon(Icons.hd),
                  color: Colors.white,
                  onPressed: () async {
                    final selected = await showModalBottomSheet<BetterPlayerAsmsTrack?>(
                      context: context,
                      builder: (_) => _QualitySheet(),
                    );
                    if (selected != null) {
                      videoController.setQualityTrack(selected);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QualitySheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tracks = context.read<VideoController>().tracks;
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            title: const Text('Auto'),
            onTap: () => Navigator.of(context).pop(null),
          ),
          for (final t in tracks)
            ListTile(
              title: Text('${t.height}p • ${(t.bitrate ?? 0) ~/ 1000} kbps'),
              onTap: () => Navigator.of(context).pop(t),
            ),
        ],
      ),
    );
  }
}


