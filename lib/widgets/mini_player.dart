import 'package:flutter/material.dart';
import 'package:m3u8_player_plus/m3u8_player_plus.dart';
import '../video_player_provider.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  Offset? _startPanPosition;
  bool _isDragging = false;

  void _handleSwipeUp() {
    final videoController = VideoPlayerInheritedWidget.of(context)!.videoController;
    videoController.setMinimized(false);
  }

  @override
  Widget build(BuildContext context) {
    final videoController = VideoPlayerInheritedWidget.of(context)!.videoController;

    return ValueListenableBuilder(
      valueListenable: videoController.state,
      builder: (context, videoState, child) {
        if (!videoState.isMinimized || !videoState.isInitialized) {
          return const SizedBox.shrink();
        }

        return Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: GestureDetector(
            onTap: () {
              final videoController = VideoPlayerInheritedWidget.of(context)!.videoController;
              videoController.setMinimized(false);
            },
            onPanStart: (details) {
              _startPanPosition = details.globalPosition;
              _isDragging = false;
            },
            onPanUpdate: (details) {
              if (_startPanPosition == null || _isDragging) return;

              final delta = details.globalPosition - _startPanPosition!;
              final distance = delta.distance;

              if (distance > 60) {
                final dx = delta.dx;
                final dy = delta.dy;

                // Swipe up and left to restore
                if (dx < -20 && dy < -20) {
                  _isDragging = true;
                  _handleSwipeUp();
                }
              }
            },
            onPanEnd: (details) {
              _startPanPosition = null;
              _isDragging = false;
            },
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Mini video preview
                    Container(
                      width: 160,
                      height: 90,
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                      child: videoState.playerConfig != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: SizedBox(
                                width: 160,
                                height: 90,
                                child: M3u8PlayerWidget(config: videoState.playerConfig!),
                              ),
                            )
                          : const Icon(Icons.play_circle_outline, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Stream HLS', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Tocando agora...', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(videoState.isPlaying ? Icons.pause : Icons.play_arrow),
                      onPressed: () {
                        final videoController = VideoPlayerInheritedWidget.of(context)!.videoController;
                        videoController.setPlaying(!videoState.isPlaying);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        final videoController = VideoPlayerInheritedWidget.of(context)!.videoController;
                        videoController.setMinimized(false);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
