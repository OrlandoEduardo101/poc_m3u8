import 'package:flutter/material.dart';
import '../video_player_provider.dart';
import 'shared_video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final Function(bool) setMinimized;

  const CustomVideoPlayer({super.key, required this.setMinimized});

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  Offset? _startPanPosition;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final videoController = VideoPlayerInheritedWidget.of(context)!.videoController;

    return ValueListenableBuilder(
      valueListenable: videoController.state,
      builder: (context, videoState, child) {
        if (!videoState.isInitialized || videoState.playerConfig == null) {
          return const AspectRatio(
            aspectRatio: 16 / 9,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // M3U8 Player Widget
              SharedVideoPlayerWidget(config: videoState.playerConfig!, isMinimized: false),

              // Gesture detector for swipe to minimize
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanStart: (details) {
                  _startPanPosition = details.globalPosition;
                  _isDragging = false;
                },
                onPanUpdate: (details) {
                  if (_startPanPosition == null || _isDragging) return;

                  final delta = details.globalPosition - _startPanPosition!;
                  final distance = delta.distance;

                  if (distance > 80) {
                    final dx = delta.dx;
                    final dy = delta.dy;

                    if (dx > 30 && dy > 30) {
                      _isDragging = true;
                      widget.setMinimized(true);
                    }
                  }
                },
                onPanEnd: (details) {
                  _startPanPosition = null;
                  _isDragging = false;
                },
                child: const SizedBox.expand(),
              ),

              // Minimize button overlay
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                  child: IconButton(
                    icon: const Icon(Icons.minimize),
                    color: Colors.white,
                    onPressed: () => widget.setMinimized(true),
                  ),
                ),
              ),

              // Helper text overlay
              Positioned(
                left: 16,
                bottom: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
                  child: const Text(
                    'Arraste diagonalmente para minimizar',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
